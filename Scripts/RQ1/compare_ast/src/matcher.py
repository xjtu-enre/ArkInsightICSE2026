"""
matcher.py: ASTMatcher implements two-phase node matching (Top-Down & Bottom-Up),
outputting MatchResult information such as mapping and confidence matrix.
"""

import numpy as np
from collections import defaultdict

from src.utils import (
    traverse_preorder,
    compute_subtree_hash,
    bipartite_max_weight_match
)
from src.constants import SIMILARITY_THRESHOLD, WEIGHTS


class MatchResult:
    """
    Stores the matching results:
    - our_root, normal_root: normalized AST root nodes
    - mapping: dict of our_uid -> normal_uid
    - confidences: dict of (our_uid, normal_uid) -> confidence float
    - confidence_matrix: np.ndarray shape (N1, N2)
    """

    def __init__(self, our_root, normal_root):
        self.our_root = our_root
        self.normal_root = normal_root
        self.mapping = {}
        self.confidences = {}
        self.confidence_matrix = None


class ASTMatcher:
    def __init__(self, our_root, normal_root):
        """
        :param our_root: NormalizedNode tree root
        :param normal_root: NormalizedNode tree root
        """
        self.our_root = our_root
        self.normal_root = normal_root
        self.result = MatchResult(our_root, normal_root)
        self._our_matched = set()
        self._normal_matched = set()

    def match(self) -> MatchResult:
        # 1. Top-Down exact subtree matching
        self._top_down_match()
        # 2. Bottom-Up global matching based on local similarity
        self._bottom_up_match()
        # 3. Build confidence matrix
        self._build_confidence_matrix()
        return self.result

    def _top_down_match(self):
        # Build hash -> node list
        our_map = defaultdict(list)
        norm_map = defaultdict(list)
        for n in traverse_preorder(self.our_root):
            h = compute_subtree_hash(n)
            our_map[h].append(n)
        for n in traverse_preorder(self.normal_root):
            h = compute_subtree_hash(n)
            norm_map[h].append(n)

        # Recursively match subtrees with the same hash
        for h in set(our_map.keys()).intersection(norm_map.keys()):
            ours = our_map[h]
            norms = norm_map[h]
            # Pair in order of appearance
            for a, b in zip(ours, norms):
                if a.uid in self._our_matched or b.uid in self._normal_matched:
                    continue
                self._match_subtree(a, b)

    def _match_subtree(self, a, b):
        """
        When a and b subtrees are confirmed to be isomorphic, align them and their descendants recursively.
        """
        # Record the match
        self.result.mapping[a.uid] = b.uid
        self.result.confidences[(a.uid, b.uid)] = 1.0
        self._our_matched.add(a.uid)
        self._normal_matched.add(b.uid)
        # Align children one by one
        for ca, cb in zip(a.children, b.children):
            if ca.uid in self._our_matched or cb.uid in self._normal_matched:
                continue
            self._match_subtree(ca, cb)

    def _bottom_up_match(self):
        # Collect unmatched node lists
        our_remain = [n for n in traverse_preorder(self.our_root)
                      if n.uid not in self._our_matched]
        norm_remain = [n for n in traverse_preorder(self.normal_root)
                       if n.uid not in self._normal_matched]

        if not our_remain or not norm_remain:
            return

        # Construct weight matrix
        n1, n2 = len(our_remain), len(norm_remain)
        weight_matrix = np.zeros((n1, n2), dtype=float)

        # —— Collect all raw similarity scores here (without threshold filtering)
        # raw_scores = []

        for i, a in enumerate(our_remain):
            for j, b in enumerate(norm_remain):
                w = self._node_similarity(a, b)

                # if w > 0: raw_scores.append(w)

                # Below threshold is considered unmatched
                weight_matrix[i, j] = w if w >= SIMILARITY_THRESHOLD else 0.0

            # # —— Plot similarity distribution histogram

            # try:
            #     import matplotlib.pyplot as plt
            #     plt.hist(raw_scores, bins=50)
            #     plt.title("Node Similarity Score Distribution")
            #     plt.xlabel("Similarity Score")
            #     plt.ylabel("Frequency")
            #     # Save to current directory if out_dir is not defined in script
            #     plt.savefig(r"C:\Users\lijiale\Desktop\ArkTS\my_output\8", bbox_inches="tight")
            #     plt.close()
            # except ImportError:
            #     # Skip if matplotlib is not installed
            #     pass

        # Maximum weight matching
        pairs, confs = bipartite_max_weight_match(weight_matrix)
        for (i, j), conf in zip(pairs, confs):
            if conf <= 0:
                continue
            a = our_remain[i]
            b = norm_remain[j]
            # May need to recheck unmatched status
            if a.uid in self._our_matched or b.uid in self._normal_matched:
                continue
            # Record match and confidence
            self.result.mapping[a.uid] = b.uid
            self.result.confidences[(a.uid, b.uid)] = conf
            self._our_matched.add(a.uid)
            self._normal_matched.add(b.uid)

    def _node_similarity(self, a, b) -> float:
        """
        Perform core matching based on `label`:
        1. Add score if types match
        2. Add score if labels match
        3. If types differ but labels match, add downgraded score
        4. Proportion of matching child nodes
        """
        w = 0.0
        # 1) Type match
        if a.normalized_type == b.normalized_type:
            w += WEIGHTS["type_match"]
        # 2) Label match
        if a.label and b.label and a.label == b.label:
            w += WEIGHTS["label_match"]
        # 3) Type mismatch but label match
        elif a.normalized_type != b.normalized_type and a.label and b.label and a.label == b.label:
            w += WEIGHTS["type_mismatch_penalty"]
        # 4) Ratio of matched immediate children
        ca, cb = a.children, b.children
        if ca and cb:
            matched = sum(1 for c in ca if c.uid in self.result.mapping and
                          self.result.mapping[c.uid] in {x.uid for x in cb})
            denom = max(len(ca), len(cb))
            w += WEIGHTS["subtree_match"] * (matched / denom)
        return float(w)

    def _build_confidence_matrix(self):
        """
        Build N1 x N2 confidence matrix and store in result.confidence_matrix.
        """
        # Count the number of nodes in both trees
        all_our = list(traverse_preorder(self.our_root))
        all_norm = list(traverse_preorder(self.normal_root))
        N1, N2 = len(all_our), len(all_norm)

        mat = np.zeros((N1, N2), dtype=float)
        for (a_uid, b_uid), conf in self.result.confidences.items():
            mat[a_uid, b_uid] = conf
        self.result.confidence_matrix = mat
