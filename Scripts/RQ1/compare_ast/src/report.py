# src/report.py
# -*- coding: utf-8 -*-
"""
report.py: Generate matching reports — node mappings, difference lists, similarity matrix, etc.
"""

import os
import json
import numpy as np
from src.utils import traverse_preorder


class ReportGenerator:
    @staticmethod
    def generate(match_result, score: float, out_dir: str):
        """
        Generate in out_dir:
          - mapping.json: list of matched node pairs
          - diffs.json: list of unmatched nodes and type changes
          - matrix.npy: confidence matrix
          - summary.json: metadata such as overall similarity
        """
        os.makedirs(out_dir, exist_ok=True)

        # 1. Build uid -> node maps for node info lookup
        our_nodes = {n.uid: n for n in traverse_preorder(match_result.our_root)}
        norm_nodes = {n.uid: n for n in traverse_preorder(match_result.normal_root)}

        # 2. Output mapping.json
        mapping_list = []
        for our_uid, norm_uid in match_result.mapping.items():
            a = our_nodes[our_uid]
            b = norm_nodes[norm_uid]
            mapping_list.append({
                "our_uid": our_uid,
                "our_type": a.normalized_type,
                "our_raw_type": a.raw_type,
                "our_label": a.label,
                "normal_uid": norm_uid,
                "normal_type": b.normalized_type,
                "normal_raw_type": b.raw_type,
                "normal_label": b.label,
                "confidence": match_result.confidences.get((our_uid, norm_uid), 0.0)
            })
        with open(os.path.join(out_dir, "mapping.json"), "w", encoding="utf-8") as f:
            json.dump(mapping_list, f, ensure_ascii=False, indent=2)

        # 3. Find unmatched nodes (difference list)
        our_only = []
        for uid, n in our_nodes.items():
            if uid not in match_result.mapping:
                our_only.append({
                    "uid": uid,
                    "type": n.normalized_type,
                    "raw_type": n.raw_type,
                    "label": n.label
                })
        norm_only = []
        for uid, n in norm_nodes.items():
            if uid not in set(match_result.mapping.values()):
                norm_only.append({
                    "uid": uid,
                    "type": n.normalized_type,
                    "raw_type": n.raw_type,
                    "label": n.label
                })

        # 4. List of type changes (entries where raw_type differs in matched pairs)
        type_changes = []
        for entry in mapping_list:
            if entry["our_raw_type"] != entry["normal_raw_type"]:
                type_changes.append({
                    "our_uid": entry["our_uid"],
                    "our_raw_type": entry["our_raw_type"],
                    "our_label": entry["our_label"],
                    "normal_uid": entry["normal_uid"],
                    "normal_raw_type": entry["normal_raw_type"],
                    "normal_label": entry["normal_label"],
                    "confidence": entry["confidence"]
                })

        diffs = {
            "our_only": our_only,
            "normal_only": norm_only,
            "type_changes": type_changes
        }
        with open(os.path.join(out_dir, "diffs.json"), "w", encoding="utf-8") as f:
            json.dump(diffs, f, ensure_ascii=False, indent=2)

        # 5. Save confidence matrix
        matrix_path = os.path.join(out_dir, "matrix.npy")
        np.save(matrix_path, match_result.confidence_matrix)

        # 6. Output summary.json
        summary = {
            "similarity_score": score,
            "total_our_nodes": len(our_nodes),
            "total_normal_nodes": len(norm_nodes),
            "matched_pairs": len(mapping_list),
            "our_only_count": len(our_only),
            "normal_only_count": len(norm_only)
        }
        with open(os.path.join(out_dir, "summary.json"), "w", encoding="utf-8") as f:
            json.dump(summary, f, ensure_ascii=False, indent=2)