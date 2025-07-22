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
        # Normalize type mapping
        self.normalized_type = TYPE_EQUIVALENCE.get(self.raw_type, self.raw_type)
        # Inherit ASTNode.label
        self.label = raw_node.label
        # Skip logic
        self.skip = (self.raw_type in SKIPPABLE_TYPES) or (self.raw_type == "ClassBody")
        # Flatten children nodes: directly promote children of skipped nodes
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
