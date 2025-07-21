# src/normalizer.py
# -*- coding: utf-8 -*-
from src.constants import TYPE_EQUIVALENCE, SKIPPABLE_TYPES
from src.loader import ASTNode
from src.utils import assign_unique_ids


class NormalizedNode:
    __slots__ = ("raw_node", "raw_type", "normalized_type",
                 "label", "children", "skip", "uid")

    def __init__(self, raw_node: ASTNode):
        self.raw_node = raw_node
        self.raw_type = raw_node.type
        # 规范类型映射
        self.normalized_type = TYPE_EQUIVALENCE.get(self.raw_type, self.raw_type)
        # 继承 ASTNode.label
        self.label = raw_node.label
        # 跳过逻辑
        self.skip = (self.raw_type in SKIPPABLE_TYPES) or (self.raw_type == "ClassBody")
        # 子节点扁平化：跳过 skip 的直接提升
        self.children = []
        for c in raw_node.children:
            cn = NormalizedNode(c)
            if cn.skip:
                self.children.extend(cn.children)
            else:
                self.children.append(cn)
        self.uid = None

    def __repr__(self):
        return f"<Norm {self.normalized_type}[{self.uid}] label={self.label!r}>"


class ASTNormalizer:
    @staticmethod
    def normalize(root: ASTNode) -> NormalizedNode:
        norm = NormalizedNode(root)
        assign_unique_ids(norm)
        return norm
