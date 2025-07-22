# -*- coding: utf-8 -*-
"""
Global constants definition: includes node type synonyms mapping,
skippable node types, weights, and thresholds.
"""

# -----------------------------------------------------------------------------
# Map node types from various AST dialects to unified "normalized types"
# key: type string in original JSON AST
# value: normalized_type after unification
# -----------------------------------------------------------------------------
TYPE_EQUIVALENCE = {
    # Struct/Class Declarations
    "ArkTSStructDeclaration": "STRUCT",
    "StructDeclaration": "STRUCT",

    # Methods/Functions
    "ClassMethod": "METHOD",
    "MethodDeclaration": "METHOD",
    "ArrowFunction": "ARROW_FN",
    "ArrowFunctionExpression": "ARROW_FN",

    # Properties/Signatures/Parameters
    "ClassProperty": "PROP",
    "PropertyDeclaration": "PROP",
    "PropertyAssignment": "PROP",
    "PropertySignature": "PROP",
    "Parameter": "PARAM",

    # Calls/Component Expressions
    "ArkTSCallExpression": "CALL",
    "EtsComponentExpression": "CALL",
    "CallExpression": "CALL",

    # Objects/Literals
    "ObjectExpression": "OBJECT",
    "ObjectLiteralExpression": "OBJECT",
    "NumericLiteral": "NUMBER",
    "FirstLiteralToken": "NUMBER",
    "NumberKeyword": "NUMBER",
    "TSNumberKeyword": "NUMBER",
    "StringLiteral": "STRING",
    "TemplateLiteral": "TEMPLATE",
    "TemplateExpression": "TEMPLATE",

    # Expression statements/Blocks
    "ExpressionStatement": "EXPR_STMT",
    "BlockStatement": "BLOCK",
    "Block": "BLOCK",

    # Updates/Increments
    "UpdateExpression": "UPDATE",
    "PostfixUnaryExpression": "UPDATE",

    # Access/Member Expressions
    "MemberExpression": "MEMBER",
    "PropertyAccessExpression": "MEMBER",
    "ThisExpression": "THIS",
    "ThisKeyword": "THIS",

    # Non-null assertions
    "NonNullExpression": "NON_NULL",
    "ArkTSDoubleExclamationExpression": "NON_NULL",

    # Decorators
    "Decorator": "DECORATOR",

    # Type annotations
    "TSTypeAnnotation": "TYPE_ANN",
    "TSVoidKeyword": "VOID",
    "VoidKeyword": "VOID",
    "TSFunctionType": "FUNC_TYPE",
    "FunctionType": "FUNC_TYPE",

    # Template string fragments
    "TemplateElement": "TEMPLATE_EL",
    "TemplateHead": "TEMPLATE_EL",
    "TemplateSpan": "TEMPLATE_EL",
    "FirstTemplateToken": "TEMPLATE_EL",
    "LastTemplateToken": "TEMPLATE_EL",

    # Top-level containers
    "Program": "PROGRAM",
    "SourceFile": "PROGRAM",
    "File": "PROGRAM",
}

# -----------------------------------------------------------------------------
# Node types with no semantic meaning that can be skipped during matching
# -----------------------------------------------------------------------------
SKIPPABLE_TYPES = {
    "HeritageClause",
    "Constructor",
    "EndOfFileToken",
    "CommentSpace",
    "EmptyStatement",
}

# -----------------------------------------------------------------------------
# Weights and thresholds used during matching/similarity computation
# -----------------------------------------------------------------------------
# src/constants.py
# Removed old name_match/value_match, replaced with label_match
WEIGHTS = {
    "type_match": 1.0,
    "type_mismatch_penalty": 0.5,
    "label_match": 1.0,
    "subtree_match": 1.0,
}

# -----------------------------------------------------------------------------
# Optional hash seed used for subtree hashing (Top-Down phase)
# -----------------------------------------------------------------------------
HASH_SEED = 1315423911

# -----------------------------------------------------------------------------
# Similarity threshold (0~1) used in Bottom-Up phase to determine "similar enough"
# -----------------------------------------------------------------------------
SIMILARITY_THRESHOLD = 0.5
