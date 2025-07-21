## Entity: Struct

An `Struct Entity` is a sample of Custom Components or System Components containing properties and methods defined by keyword `struct`.

> Custom components must be decorated by @Component and contain build() functions. It can contain other member functions and member variables under certain constraints

### Supported Patterns

```yaml
name: Struct statement
```

#### Syntax: struct Definitions

```text
StructDeclaration :
    `struct` BindingIdentifier StructTail
    `struct` StructTail /* Default */
StructTail :
    `{` [StructBody] `}`
```

##### Examples

###### Simple custom struct declaration

```ets
@Component
struct Foo {
    build()
    /* Empty */
}
```

```yaml
name: Simple custom struct declaration
entity:
    type: struct
    items:
        -   name: Foo
            isDecorate: true
            loc: 2:8
```

###### System struct declaration

> In ArkTS,there is many system component, just like inline function for python.These need configuration files to be extracted.
> One example is as below.

```ets
struct Column {
    build(){
        /* Empty */
    }
}
```

```yaml
name: ArkTS system struct declaration
entity:
    type: struct
    items:
        -   name: Column
            isDecorate: false
            loc: 1:8
```

### Properties

| Name         | Description                                                          |       type       |   default   |
|--------------|----------------------------------------------------------------------|:----------------:|:-----------:|
| isDecorate | Each item as Custom components should be decorated with at least one decorator `@Component`. | `Boolean` | `True` |

