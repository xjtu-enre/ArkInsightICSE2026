# src/similarity.py
# -*- coding: utf-8 -*-
"""
similarity.py: Calculate the overall similarity score between two ASTs based on MatchResult.mapping.
"""

from src.utils import traverse_preorder


class SimilarityCalculator:
    @staticmethod
    def compute_score(match_result) -> float:
        """
        Compute and return the AST similarity score between 0 and 1:
            score = 2 * |MatchedNodes| / (|Nodes_our| + |Nodes_normal|)
        """
        # Count the total number of nodes in both trees
        N1 = sum(1 for _ in traverse_preorder(match_result.our_root))
        N2 = sum(1 for _ in traverse_preorder(match_result.normal_root))
        # Number of matched pairs
        M = len(match_result.mapping)
        if N1 + N2 == 0:
            return 1.0
        return 2.0 * M / (N1 + N2)
        # return M / N1
