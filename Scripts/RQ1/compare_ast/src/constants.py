# -*- coding: utf-8 -*-
"""
全局常量定义：包括节点类型同义映射、可跳过节点类型、权重和阈值等。
"""

# -----------------------------------------------------------------------------
# 把各种 AST 方言中的节点类型映射到统一的“规范类型”
# key: 原始 JSON AST 中的 type 字符串
# value: 统一后的 normalized_type
# -----------------------------------------------------------------------------
TYPE_EQUIVALENCE = {
    # 结构体/类声明
    "ArkTSStructDeclaration": "STRUCT",
    "StructDeclaration": "STRUCT",

    # 方法/函数
    "ClassMethod": "METHOD",
    "MethodDeclaration": "METHOD",
    "ArrowFunction": "ARROW_FN",
    "ArrowFunctionExpression": "ARROW_FN",

    # 属性/签名/参数
    "ClassProperty": "PROP",
    "PropertyDeclaration": "PROP",
    "PropertyAssignment": "PROP",
    "PropertySignature": "PROP",
    "Parameter": "PARAM",

    # 调用/组件表达式
    "ArkTSCallExpression": "CALL",
    "EtsComponentExpression": "CALL",
    "CallExpression": "CALL",

    # 对象/字面量
    "ObjectExpression": "OBJECT",
    "ObjectLiteralExpression": "OBJECT",
    "NumericLiteral": "NUMBER",
    "FirstLiteralToken": "NUMBER",
    "NumberKeyword": "NUMBER",
    "TSNumberKeyword": "NUMBER",
    "StringLiteral": "STRING",
    "TemplateLiteral": "TEMPLATE",
    "TemplateExpression": "TEMPLATE",

    # 表达式语句/表达式包装
    "ExpressionStatement": "EXPR_STMT",
    "BlockStatement": "BLOCK",
    "Block": "BLOCK",

    # 更新/自增等
    "UpdateExpression": "UPDATE",
    "PostfixUnaryExpression": "UPDATE",

    # 访问/成员
    "MemberExpression": "MEMBER",
    "PropertyAccessExpression": "MEMBER",
    "ThisExpression": "THIS",
    "ThisKeyword": "THIS",

    # 非空断言
    "NonNullExpression": "NON_NULL",
    "ArkTSDoubleExclamationExpression": "NON_NULL",

    # 装饰器
    "Decorator": "DECORATOR",

    # 类型注解
    "TSTypeAnnotation": "TYPE_ANN",
    "TSVoidKeyword": "VOID",
    "VoidKeyword": "VOID",
    "TSFunctionType": "FUNC_TYPE",
    "FunctionType": "FUNC_TYPE",

    # 模板字符串碎片
    "TemplateElement": "TEMPLATE_EL",
    "TemplateHead": "TEMPLATE_EL",
    "TemplateSpan": "TEMPLATE_EL",
    "FirstTemplateToken": "TEMPLATE_EL",
    "LastTemplateToken": "TEMPLATE_EL",

    # 顶层容器
    "Program": "PROGRAM",
    "SourceFile": "PROGRAM",
    "File": "PROGRAM",
}

# -----------------------------------------------------------------------------
# 一些无实际语义、可在匹配时跳过的节点类型
# -----------------------------------------------------------------------------
SKIPPABLE_TYPES = {
    "HeritageClause",
    "Constructor",
    "EndOfFileToken",
    "CommentSpace",
    "EmptyStatement",
}

# -----------------------------------------------------------------------------
# 各种匹配/相似度计算时使用的权重与阈值
# -----------------------------------------------------------------------------
# src/constants.py
# 删除旧的 name_match/value_match，改为 label_match
WEIGHTS = {
    "type_match": 1.0,
    "type_mismatch_penalty": 0.5,
    "label_match": 1.0,
    "subtree_match": 1.0,
}


# -----------------------------------------------------------------------------
# 子树哈希（Top-Down 阶段）使用的哈希种子（可选）
# -----------------------------------------------------------------------------
HASH_SEED = 1315423911

# -----------------------------------------------------------------------------
# Bottom-Up 阶段判定“足够相似”的阈值（0~1）
# -----------------------------------------------------------------------------
SIMILARITY_THRESHOLD = 0.5
