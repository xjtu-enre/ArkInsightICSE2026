# src/loader.py
# -*- coding: utf-8 -*-
import json
from src.utils import assign_unique_ids


def _extract_label(raw: dict) -> str | None:
    """
    从原始节点 raw 中提取一个核心语义标签：
    1) identifier/keyword: raw['name'] 或 raw['text']
    2) literal: raw['value'] 或 raw['text']
    3) call/decorator/property: 看子节点
    """
    # 1. 显式 name 优先
    name = raw.get("name")
    if name:
        return name
    # 2. value 字面量
    if raw.get("value") is not None:
        return str(raw["value"])
    # 3. text 字段
    text = raw.get("text")
    if text and text.strip():
        return text.strip("` ")
    # 4. 特殊情况：CallExpression、Decorator、ObjectProperty 等
    if raw.get("type") in ("CallExpression", "ArkTSCallExpression", "EtsComponentExpression"):
        callee = raw.get("callee") or raw.get("expression")
        if isinstance(callee, dict):
            return _extract_label(callee)
    if raw.get("type") == "Decorator":
        expr = raw.get("expression") or raw.get("callee")
        if isinstance(expr, dict):
            return _extract_label(expr)
    if raw.get("type") in ("ObjectProperty", "PropertyAssignment"):
        key = raw.get("key")
        if isinstance(key, dict):
            return _extract_label(key)
    return None


class ASTNode:
    def __init__(self, raw: dict):
        self.raw = raw
        self.type = raw.get("type") or raw.get("kind")
        # 把 program.body 扁平化为 children
        children_raw = []
        if "program" in raw and isinstance(raw["program"].get("body"), list):
            children_raw = raw["program"]["body"]
        else:
            for k, v in raw.items():
                if isinstance(v, dict) and ("type" in v or "kind" in v):
                    children_raw.append(v)
                elif isinstance(v, list):
                    for itm in v:
                        if isinstance(itm, dict) and ("type" in itm or "kind" in itm):
                            children_raw.append(itm)
        # 构建子节点
        self.children = [ASTNode(ch) for ch in children_raw]
        # 位置
        self.start = raw.get("start", raw.get("pos"))
        self.end = raw.get("end")
        self.loc = raw.get("loc")
        # 新增核心标签
        self.label = _extract_label(raw)
        # uid 后面分配
        self.uid = None

    def __repr__(self):
        return f"<ASTNode {self.type}[{self.uid}] label={self.label!r}>"


class ASTLoader:
    @staticmethod
    def load_from_file(path: str) -> ASTNode:
        with open(path, encoding="utf-8") as f:
            raw = json.load(f)
        root = ASTNode(raw)
        assign_unique_ids(root)
        return root
