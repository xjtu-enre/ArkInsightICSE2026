# -*- coding: utf-8 -*-
"""
Utility functions:
- Preorder traversal and unique ID assignment for AST trees
- Subtree hashing using hashlib
- Bipartite maximum weight matching (Hungarian algorithm wrapper)
"""

import hashlib
from collections import deque

import numpy as np

from src.constants import HASH_SEED


def traverse_preorder(root):
    """
    Perform preorder traversal on an ASTNode tree and yield each node.
    """
    stack = [root]
    while stack:
        node = stack.pop()
        yield node
        # Maintain original child order by pushing right to left
        for child in reversed(getattr(node, "children", [])):
            stack.append(child)


def assign_unique_ids(root):
    """
    Assign a unique incrementing integer ID to each node (node.uid),
    useful for later indexing and matrix construction.
    """
    counter = 0
    for node in traverse_preorder(root):
        node.uid = counter
        counter += 1


def compute_subtree_hash(node):
    """
    Compute a stable hash (string) for a subtree,
    used for fast matching of identical subtrees in the Top-Down phase.

    The hash includes:
      - Normalized node type (if available)
      - Fallback to raw type (.raw_type or .type)
      - If present, include name or value
      - Recursively hashes children in original order
    """
    m = hashlib.sha256()
    # Include a seed to reduce collision risk
    m.update(str(HASH_SEED).encode("utf-8"))

    # 1) Type identifier: ensure it's a string
    if hasattr(node, "normalized_type") and node.normalized_type is not None:
        type_repr = node.normalized_type
    elif hasattr(node, "raw_type") and node.raw_type is not None:
        type_repr = node.raw_type
    else:
        type_repr = getattr(node, "type", "") or ""
    m.update(type_repr.encode("utf-8"))

    # 2) Identifier / Name
    if hasattr(node, "name") and node.name is not None:
        m.update(str(node.name).encode("utf-8"))

    # 3) Literal value
    if hasattr(node, "value") and node.value is not None:
        m.update(str(node.value).encode("utf-8"))

    # 4) Recursively hash child subtrees
    for child in getattr(node, "children", []):
        child_hash = compute_subtree_hash(child)
        m.update(child_hash.encode("utf-8"))

    return m.hexdigest()


def bipartite_max_weight_match(weight_matrix):
    """
    Given a weight matrix (n x m) as a NumPy array or nested list,
    return:
      - matches: list of (row_idx, col_idx) tuples
      - confidences: corresponding weights for each match

    Internally uses scipy.optimize.linear_sum_assignment
    to solve maximum weight bipartite matching (Hungarian algorithm).
    """
    try:
        from scipy.optimize import linear_sum_assignment
    except ImportError as e:
        raise ImportError(
            "Bipartite matching requires scipy. "
            "Please install it using `pip install scipy`."
        ) from e

    weights = np.array(weight_matrix)
    if weights.size == 0:
        return [], []

    # Hungarian algorithm solves for minimum cost.
    # Convert max-weight problem to min-cost problem.
    max_w = weights.max()
    cost = max_w - weights
    row_idx, col_idx = linear_sum_assignment(cost)
    matches = list(zip(row_idx.tolist(), col_idx.tolist()))
    confidences = [float(weights[i, j]) for i, j in matches]
    return matches, confidences
