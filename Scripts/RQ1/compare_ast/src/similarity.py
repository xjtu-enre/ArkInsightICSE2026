# src/similarity.py
# -*- coding: utf-8 -*-
"""
similarity.py: 基于 MatchResult.mapping 计算两棵 AST 的总体相似度得分。
"""

from src.utils import traverse_preorder


class SimilarityCalculator:
    @staticmethod
    def compute_score(match_result) -> float:
        """
        计算并返回 0~1 之间的 AST 相似度得分：
            score = 2 * |MatchedNodes| / (|Nodes_our| + |Nodes_normal|)
        """
        # 计算两棵树的节点总数
        N1 = sum(1 for _ in traverse_preorder(match_result.our_root))
        N2 = sum(1 for _ in traverse_preorder(match_result.normal_root))
        # 匹配对数
        M = len(match_result.mapping)
        if N1 + N2 == 0:
            return 1.0
        return 2.0 * M / (N1 + N2)
        # return M / N1
