# -*- coding: utf-8 -*-
"""
通用工具：
- AST 树的遍历与唯一 ID 分配
- 基于 hashlib 的子树哈希
- 二分图最大权匹配（Hungarian 算法封装）
"""

import hashlib
from collections import deque

import numpy as np

from src.constants import HASH_SEED


def traverse_preorder(root):
    """
    对 ASTNode 树做前序遍历，yield 每个节点。
    """
    stack = [root]
    while stack:
        node = stack.pop()
        yield node
        # 保持原始孩子顺序，从右向左入栈
        for child in reversed(getattr(node, "children", [])):
            stack.append(child)


def assign_unique_ids(root):
    """
    给每个节点分配唯一递增的整型 ID，挂在 node.uid 上，便于后续索引和矩阵构建。
    """
    counter = 0
    for node in traverse_preorder(root):
        node.uid = counter
        counter += 1


def compute_subtree_hash(node):
    """
    为子树计算一个稳定哈希值（字符串），用于 Top-Down 完全相同子树的快速匹配。
    包含：
      - 规范化节点类型（若有 normalized_type）
      - 回退到原始类型（NormalizedNode.raw_type 或 ASTNode.type）
      - 如果有 name 或 value，也纳入哈希
      - 递归子节点哈希（按原始顺序）
    """
    import hashlib
    m = hashlib.sha256()
    # 先把种子加进去，降低碰撞风险
    m.update(str(HASH_SEED).encode("utf-8"))

    # 1) 类型标识：确保是字符串
    if hasattr(node, "normalized_type") and node.normalized_type is not None:
        type_repr = node.normalized_type
    elif hasattr(node, "raw_type") and node.raw_type is not None:
        type_repr = node.raw_type
    else:
        # ASTNode 上可能有 .type；若仍为 None，就退回空串
        type_repr = getattr(node, "type", "") or ""
    m.update(type_repr.encode("utf-8"))

    # 2) 标识符/名称
    if hasattr(node, "name") and node.name is not None:
        m.update(str(node.name).encode("utf-8"))

    # 3) 字面量值
    if hasattr(node, "value") and node.value is not None:
        m.update(str(node.value).encode("utf-8"))

    # 4) 子树哈希
    for child in getattr(node, "children", []):
        # 递归时同样使用这个安全逻辑
        child_hash = compute_subtree_hash(child)
        m.update(child_hash.encode("utf-8"))

    return m.hexdigest()



def bipartite_max_weight_match(weight_matrix):
    """
    传入形如 (n x m) 的权重矩阵（NumPy array 或等价的嵌套 list）,
    返回：
      - matches: [(row_idx, col_idx), …]
      - confidences: [weight_matrix[row_idx,col_idx], …]
    内部使用 scipy.optimize.linear_sum_assignment 求最大权匹配。
    """
    try:
        from scipy.optimize import linear_sum_assignment
    except ImportError as e:
        raise ImportError(
            "bipartite matching 需要 scipy，"
            "请通过 `pip install scipy` 安装。"
        ) from e

    weights = np.array(weight_matrix)
    if weights.size == 0:
        return [], []

    # Hungarian 算法是最小成本匹配，将最大权转为最小成本
    max_w = weights.max()
    cost = max_w - weights
    row_idx, col_idx = linear_sum_assignment(cost)
    matches = list(zip(row_idx.tolist(), col_idx.tolist()))
    confidences = [float(weights[i, j]) for i, j in matches]
    return matches, confidences
