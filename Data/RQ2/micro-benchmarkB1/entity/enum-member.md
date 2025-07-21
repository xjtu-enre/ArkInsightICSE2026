## Entity: Enum Member

An `Enum Member Entity` is a member defined inside an enum body.

### Supported Patterns

```yaml
name: Enum member declaration
```

#### Syntax: Enum member Definitions

```text
EnumMember :
    PropertyName
    PropertyName `=` EnumValue

EnumValue :
    AssignmentExpression
```

> (Not documented) The preceding `PropertyName` only accepts `IdentifierName` and `StringLiteral`. In
> addition, `StringLiteral` cannot be evaluated to base10 integers or decimals.

##### Examples

###### Default numeric enum member declaration

Default enum members will be initialized to number starting from 0, and the number is incremented in sequence.

```ets
enum Direction {
    Up,             // 0
    Down,           // 1
    Left,           // 2
    Right,          // 3
}
```

```yaml
name: Default numeric enum member declaration
entity:
    type: enum member
    extra: false
    items:
        -   name: Up
            qualified: Direction.Up
            loc: 2:5
            value: 0
        -   name: Down
            qualified: Direction.Down
            loc: 3:5
            value: 1
        -   name: Left
            qualified: Direction.Left
            loc: 4:5
            value: 2
        -   name: Right
            qualified: Direction.Right
            loc: 5:5
            value: 3
```

###### Numeric enum member with (partial) initializers

```ets
enum Foo {
    Alpha,          // 0, by default
    Beta = 2,       // 2, set by initializer
    Gamma,          // 3, auto-incremented
}
```

```yaml
name: Numeric enum member initializer
entity:
    type: enum member
    extra: false
    items:
        -   name: Alpha
            qualified: Foo.Alpha
            loc: 2:5
            value: 0
        -   name: Beta
            qualified: Foo.Beta
            loc: 3:5
            value: 2
        -   name: Gamma
            qualified: Foo.Gamma
            loc: 4:5
            value: 3
```

###### String enum member

String literals can be used as initializers, in which case, each member has to be constant-initialized with a string
literal, or with another string enum member.

```ets
enum Foo {
    Bar = "BAR",
    Baz = "BAZ",
    Bza = Baz,      // Refers to a previously defined member
}
```

```yaml
name: String enum member initializer
entity:
    type: enum member
    extra: false
    items:
        -   name: Bar
            qualified: Foo.Bar
            loc: 2:5
            value: BAR
        -   name: Baz
            qualified: Foo.Baz
            loc: 3:5
            value: BAZ
        -   name: Bza
            qualified: Foo.Bza
            loc: 4:5
            value: BAZ
```

###### Heterogeneous enum

Numeric literals and string literals can be mixed, but it is not advised to do so.

```ets
enum Foo {
    Bar = 0,
    Baz = "BAZ",
}
```

```yaml
name: Heterogeneous enum
entity:
    type: enum member
    extra: false
    items:
        -   name: Bar
            qualified: Foo.Bar
            loc: 2:5
            value: 0
        -   name: Baz
            qualified: Foo.Baz
            loc: 3:5
            value: BAZ
```

###### Constant expressions as initializers

A constant enum expression is a subset of TypeScript expressions that can be fully evaluated at compile time.

```ets
enum FileAccess {
    // constant members
    Read = 1 << 1,
    Write = 1 << 2,
    ReadWrite = Read | Write,
    // computed member
    G = "123".length,
}
```

```yaml
name: Constant enum expression
entity:
    type: enum member
    extra: false
    items:
        -   name: Read
            qualified: FileAccess.Read
            loc: 3:5
            value: 2
        -   name: Write
            qualified: FileAccess.Write
            loc: 4:5
            value: 4
        -   name: ReadWrite
            qualified: FileAccess.ReadWrite
            loc: 5:5
            value: 6
        -   name: G
            qualified: FileAccess.G
            loc: 7:5
```

###### Corner cases

```ets
enum CornerCase {
    // Valid cases
    'StringLiteral',
    '✅',
    '1e20',
    '0x123',
    '100_000',

    // Invalid cases
    '123',
    '123.456',
}
```

```yaml
name: Enum member corner cases
entity:
    type: enum member
    extra: false
    items:
        -   name: <Str StringLiteral>
            qualified: CornerCase.StringLiteral
            loc: 3:5
            value: 0
        -   name: <Str ✅>
            qualified: CornerCase.'✅'
            loc: 4:5
            value: 1
        -   name: <Str 1e20>
            qualified: CornerCase.'1e20'
            loc: 5:5
            value: 2
        -   name: <Str 0x123>
            qualified: CornerCase.'0x123'
            loc: 6:5
            value: 3
        -   name: <Str 100_000>
            qualified: CornerCase.'100_000'
            loc: 7:5
            value: 4
        -   name: <Str 123>
            loc: 10:5
            negative: true
        -   name: <Str 123.456>
            loc: 11:5
            negative: true
```

###### Numeric literals are not allowed

```ts
//// @no-test
enum DefinitivelyIllegal {
    123,
    123.456,
    1e2,
    0x123,
    0o123,
    0b10,
}
```

These kinds of enum members are actually illegal, and will cause parse errors or be silently omitted by some third-party
parsers.

### Properties

| Name  | Description                 |    Type    | Default  |
|-------|-----------------------------|:----------:|:--------:|
| value | Enum member's static value. | `number` \ | `string` | `undefined` |
