"""
matcher.py: ASTMatcher 实现 Top-Down & Bottom-Up 两阶段节点匹配，
输出匹配映射、置信度矩阵等 MatchResult 信息。
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
    保存匹配结果：
    - our_root, normal_root: 规范化后的 AST 根节点
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
        :param our_root: NormalizedNode 树根
        :param normal_root: NormalizedNode 树根
        """
        self.our_root = our_root
        self.normal_root = normal_root
        self.result = MatchResult(our_root, normal_root)
        self._our_matched = set()
        self._normal_matched = set()

    def match(self) -> MatchResult:
        # 1. Top-Down 完全相同子树匹配
        self._top_down_match()
        # 2. Bottom-Up 基于局部相似度的全局匹配
        self._bottom_up_match()
        # 3. 构建置信度矩阵
        self._build_confidence_matrix()
        return self.result

    def _top_down_match(self):
        # 构造 hash -> 节点 列表
        our_map = defaultdict(list)
        norm_map = defaultdict(list)
        for n in traverse_preorder(self.our_root):
            h = compute_subtree_hash(n)
            our_map[h].append(n)
        for n in traverse_preorder(self.normal_root):
            h = compute_subtree_hash(n)
            norm_map[h].append(n)

        # 对哈希相同的子树做递归匹配
        for h in set(our_map.keys()).intersection(norm_map.keys()):
            ours = our_map[h]
            norms = norm_map[h]
            # 按出现顺序一一配对
            for a, b in zip(ours, norms):
                if a.uid in self._our_matched or b.uid in self._normal_matched:
                    continue
                self._match_subtree(a, b)

    def _match_subtree(self, a, b):
        """
        当确定 a,b 子树完全同构时，递归对齐它们及所有后代。
        """
        # 记录匹配
        self.result.mapping[a.uid] = b.uid
        self.result.confidences[(a.uid, b.uid)] = 1.0
        self._our_matched.add(a.uid)
        self._normal_matched.add(b.uid)
        # 子节点一一对应
        for ca, cb in zip(a.children, b.children):
            if ca.uid in self._our_matched or cb.uid in self._normal_matched:
                continue
            self._match_subtree(ca, cb)

    def _bottom_up_match(self):
        # 收集尚未匹配的节点列表
        our_remain = [n for n in traverse_preorder(self.our_root)
                      if n.uid not in self._our_matched]
        norm_remain = [n for n in traverse_preorder(self.normal_root)
                       if n.uid not in self._normal_matched]

        if not our_remain or not norm_remain:
            return

        # 构造权重矩阵
        n1, n2 = len(our_remain), len(norm_remain)
        weight_matrix = np.zeros((n1, n2), dtype=float)

        # —— 在这里先收集所有原始相似度分数（不做阈值过滤）
        # raw_scores = []

        for i, a in enumerate(our_remain):
            for j, b in enumerate(norm_remain):
                w = self._node_similarity(a, b)

                # if w > 0: raw_scores.append(w)

                # 低于阈值视为不匹配
                weight_matrix[i, j] = w if w >= SIMILARITY_THRESHOLD else 0.0

            # # —— 画出相似度分布直方图

            # try:
            #     import matplotlib.pyplot as plt
            #     plt.hist(raw_scores, bins=50)
            #     plt.title("Node Similarity Score Distribution")
            #     plt.xlabel("Similarity Score")
            #     plt.ylabel("Frequency")
            #     # 如果在脚本里没有 out_dir，可以临时写到当前目录
            #     plt.savefig(r"C:\Users\lijiale\Desktop\ArkTS\AST相似度算法\my_output\8", bbox_inches="tight")
            #     plt.close()
            # except ImportError:
            #     # 如果没有安装 matplotlib，就跳过
            #     pass

        # 最大权匹配
        pairs, confs = bipartite_max_weight_match(weight_matrix)
        for (i, j), conf in zip(pairs, confs):
            if conf <= 0:
                continue
            a = our_remain[i]
            b = norm_remain[j]
            # 可能需要再次检查未匹配
            if a.uid in self._our_matched or b.uid in self._normal_matched:
                continue
            # 记录匹配和置信度
            self.result.mapping[a.uid] = b.uid
            self.result.confidences[(a.uid, b.uid)] = conf
            self._our_matched.add(a.uid)
            self._normal_matched.add(b.uid)

    def _node_similarity(self, a, b) -> float:
        """
        重新用 `label` 进行核心匹配：
        1. 类型相同加分
        2. label 相同时加分
        3. 类型不同 label 同名降级加分
        4. 子树匹配比例
        """
        w = 0.0
        # 1) 类型一致
        if a.normalized_type == b.normalized_type:
            w += WEIGHTS["type_match"]
        # 2) label 相同加分
        if a.label and b.label and a.label == b.label:
            w += WEIGHTS["label_match"]
        # 3) 类型不同但 label 同时降级
        elif a.normalized_type != b.normalized_type and a.label and b.label and a.label == b.label:
            w += WEIGHTS["type_mismatch_penalty"]
        # 4) 子树直接子节点匹配比例
        ca, cb = a.children, b.children
        if ca and cb:
            matched = sum(1 for c in ca if c.uid in self.result.mapping and
                          self.result.mapping[c.uid] in {x.uid for x in cb})
            denom = max(len(ca), len(cb))
            w += WEIGHTS["subtree_match"] * (matched / denom)
        return float(w)

    def _build_confidence_matrix(self):
        """
        构建 N1 x N2 置信度矩阵，存入 result.confidence_matrix。
        """
        # 统计两棵树节点数
        all_our = list(traverse_preorder(self.our_root))
        all_norm = list(traverse_preorder(self.normal_root))
        N1, N2 = len(all_our), len(all_norm)

        mat = np.zeros((N1, N2), dtype=float)
        for (a_uid, b_uid), conf in self.result.confidences.items():
            mat[a_uid, b_uid] = conf
        self.result.confidence_matrix = mat
