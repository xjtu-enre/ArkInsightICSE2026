# The Design of AST Similarity Calculation Algorithm

## Differences between Two AST

The AST representations used by `insight_ast.json`(Our result) and `Analyzer_ast.json` (baseline's result) differ in both structure and semantics. These differences include:

### 1. Node Type Naming Differences

- `insight_ast` uses ArkTS-specific node names such as `ArkTSStructDeclaration` to represent `struct` declarations.
- `Analyzer_ast` follows standard TypeScript AST naming, using names like `StructDeclaration`, `PropertyDeclaration`, and `EtsComponentExpression`.

### 2. Tree Structure Wrapping Differences

- `insight_ast` sometimes includes intermediate wrapper nodes (e.g., `ClassBody`) that are not present in `Analyzer_ast`.
- `Analyzer_ast` may contain placeholder nodes like empty `HeritageClause` and `Constructor` nodes, which have no corresponding nodes in `insight_ast`.

### 3. Syntactic Element Representation Differences

Example: `Column() { ... }`  
- In `insight_ast`: represented as `ArkTSCallExpression` with a `callee` child (`Identifier: "Column"`) and a `trailingClosure` block.
- In `Analyzer_ast`: represented as `EtsComponentExpression` with direct children `Identifier: "Column"` and a `Block`.

Despite structural differences, both representations are semantically equivalent.

---

## Our Algorithm

To compare `insight_ast` and `Analyzer_ast` fairly, both are first converted into a unified intermediate tree structure `ASTNode`, which abstracts away semantically irrelevant differences.

### 1. AST Preprocessing and Normalization

- **Node Type Normalization:**  
  Establish synonym mapping (e.g., `ArkTSStructDeclaration` and `StructDeclaration` → `Struct`).

- **Flatten Redundant Structures:**  
  Remove nodes like `ClassBody`, `HeritageClause`, and empty `Constructor`.

- **Content Standardization:**  
  Discard non-semantic metadata (e.g., line/column/position), retain only meaningful content (e.g., identifier names, literal values).


### 2. Node Similarity Measurement

Define a scoring function for matching nodes from two ASTs:

- **Type Matching:**  
  +1.0 if types match, else 0.

- **Label Matching:**  
  +1.0 if labels (identifier names, constants) match, else 0.

- **Subtree Matching:**  
  Consider the proportion of matched direct children.  
  Score = `1.0 × (ratio of matched children)`.


### 3. Node Matching Mapping

Inspired by the **GumTree** algorithm, use a two-phase strategy:

#### Top-Down Phase: Subtree Hashing

1. **Compute Subtree Signatures**  
2. **Match Identical Subtrees**  
3. **Record Matches and MAnalyzer as Used**

This step anchors the obvious matches using hash-based signature comparison.

#### Bottom-Up Phase: Optimization Matching

- Use previously matched leaves to guide parent matching.
- Discard low-similarity pairs using threshold `SIMILARITY_THRESHOLD`.
- Solve the remaining node mapping as a **maximum weight bipartite matching** using the **Hungarian Algorithm**.

---

### 4. Similarity Calculation

Overall similarity is calculated using the **Dice Coefficient**:

```math
similarity = (2 × |M|) / (|T₁| + |T₂|)
Where:

|M|: number of matched node pairs

|T₁|, |T₂|: total nodes in AST1 and AST2