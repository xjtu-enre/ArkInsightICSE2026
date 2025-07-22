# ARKINSIGHT

ArkInsight is an entity relationship extractor for ArkTS, ECMAScript and TypeScript.

## Entity Categories

| Entity Name                               | Definition                                                                                                         |
|-------------------------------------------|--------------------------------------------------------------------------------------------------------------------|
| [Package](entity/package.md) | A `Package Entity` is a Node.js package, which usually contains a `package.json` file to indicate this, and its name can be used as an import specifier. |
| [File](entity/file.md)           | A `File Entity` is mostly a ArkTS source file, and can also be something relevant to the project.                           |
| [Variable](entity/variable.md)   | A `Variable Entity` is a variable defined by keywords `let`/`const`/`var`.                                                       |
| [Function](entity/function.md)   | A `Function Entity` is either a block of code defined with keyword `function` or an arrow function `() => {}`.                   |
| [Parameter](entity/parameter.md) | A `Parameter Entity` is a variable defined either as function's formal parameter or in a `catch` clause.                         |
| [Class](entity/class.md)         | A `Class Entity` is a template of object containing properties and methods defined by keyword `class`.                           |
| [Field](entity/field.md)         | A `Field Entity` is a public / private *variable* defined inside a `Class Entity`. |
| [Method](entity/method.md)       | A `Method Entity` is a 'function' or function-like thing (getter / setter) defined inside a `Class Entity` or an object literal. |
| [Namespace](entity/namespace.md)           | A `Namespace Entity` is a named container for types providing a hierarchical mechanism for organizing code and declarations. |
| [Type Alias](entity/type-alias.md)         | A `Type Alias Entity` is a convenient alias for a compound type.                                                             |
| [Enum](entity/enum.md)                     | An `Enum Entity` is a set of named constants for document intent, or create a set of distinct cases.                         |
| [Enum Member](entity/enum-member.md)       | An `Enum Member Entity` is a member defined inside an enum body.                                                             |
| [Interface](entity/interface.md)           | An `Interface Entity` is a name and parameterized representation of an object type and can be implemented by classes.        |
| [Type Parameter](entity/type-parameter.md) | A `Type Parameter Entity` is a placeholder for an actual type.                                                               |
| [Property](entity/property.md)             | A `Property Entity` is a public *variable* or *function* defined inside an Entity but not class         |
| [Alias](entity/alias.md)                   | An `Alias Entity` is a convenient alias usually for a import entity.            |
| [Struct](entity/struct.md)                | An `Struct Entity` is a sample of Custom Components containing properties and methods defined by keyword `struct`. |
| [ArkTS](entity/arkts_new_rules_entity.md) | An `ArkTS Entity` is a sample of Custom Components containing properties and methods defined by keyword `arkts`.   |
| [Module](entity/module.md)                | An `Module Entity` is is a ArkTS MODULE, which usually contains a `module.json5` file to indicate this.            |
| [Block](entity/block.md) | Any declaration space spanned by `{}` and is a non-functional entity. |

## Relation Categories

| Relation Name                                 | Definition                                                                                                                    |
|-----------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------|
| [Import](explicit-dependency/import.md)     | An `Import Relation` establishes a link between a `File Entity` and any other kinds of entity that the latter one is imported for use.                                                    |
| [Export](explicit-dependency/export.md)     | An `Export Relation` establishes a link between a `Package Entity` or `File Entity` and any other kinds of entity that the latter one is exported so that other files can import and use. |
| [Call](explicit-dependency/call.md)         | A `Call Relation` establishes a link between an upper entity and a `Function Entity` or `Method Entity` that the latter one is called within the former one's scope.                      |
| [Set](explicit-dependency/set.md)           | A `Set Relation` establishes a link between an upper entity and any other named value entities which appear on the left side of assignment expressions.                                   |
| [Use](explicit-dependency/use.md)           | A `Use Relation` establishes a link between an upper entity and any other entities that appear on its scope for real purpose.                                                             |
| [Modify](explicit-dependency/modify.md)     | A `Modify Relation` establishes a link between an upper entity and any other named value entities which appear on both sides of assignment expressions or unary operators.                |
| [Extend](explicit-dependency/extend.md)     | An `Extend Relation` establishes a link between `Class Entity`s and `Interface Entity`s that enables hierarchical reusing , or setups a restriction on `Type Parameter Entity`..          |
| [Override](explicit-dependency/override.md) | An `Override Relation` establishes a link between two `Method Entity`s that a subclass one overrides a superclass one.                                                                    |
| [Type](explicit-dependency/type.md)           | A `Type Relation` establishes a link between a value entity that accepts `TypeAnnotation` and any other type entities which appear on the typing context. |
| [Implement](explicit-dependency/implement.md) | An `Implement Relation` establishes a constraint (type checking) on `Class Entity` according to `Interface Entity`'s declarations.                        |
| [ArkTS](explicit-dependency/arkts_new_rules_relation.md) | An `ArkTS Relation` is a sample of Custom Components containing properties and methods defined by keyword `arkts`.            |
| [Bind](explicit-dependency/bind.md)                      | An `Bind Relation` establishes a link between `Field Entity`s to setups a bidirectional synchronization on their value.|