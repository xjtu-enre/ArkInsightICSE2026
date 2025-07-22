## Entity: Field

A `Field Entity` is a public / private *variable* defined inside a `Class Entity`.

### Supported Patterns

```yaml
name: Field declaration
```

#### Syntax: Field Declarations

```text
FieldDefinition :
    MethodDefinition
    ClassElementName [Initializer]

ClassElementName :
    PropertyName
    PrivateIdentifier

PropertyName :
    LiteralPropertyName
    ComputedPropertyName

LiteralPropertyName :
    IdentifierName
    StringLiteral
    NumericLiteral

ComputedPropertyName :
    `[` AssignmentExpression `]`
    
PrivateIdentifier :
    `#` IdentifierName
```

##### Examples

###### Public fields

```js
class Foo {
    a;
    b = 1;

    /**
     * Any unicode character is supported,
     * unless the literal fails the cast towards identifier,
     * this will be the same as an identifier.
     */
    'c';
    '✅';

    /**
     * Numeric literal will firstly be converted to standard
     * number in base 10, then be cast to string as a key.
     */
    3;
    1_000_000;
    1e-3;

    /**
     * Computed key will NOT be extracted by ArkInsight.
     */
    [`!computed${d}`];
}

/**
 * After instantiating, an instance will contain following fields:
 *
 * foo {
 *   '3': undefined,
 *   '1000000': undefined,
 *   a: undefined,
 *   b: 1,
 *   c: undefined,
 *   '✅': undefined,
 *   '0.001': undefined,
 *   '!computedKey': undefined // Assume d is 'Key'
 * }
 */
```

```yaml
name: Public class fields
entity:
  type: field
  extra: false
  items:
    - name: a
      qualified: Foo.a
      loc: 2:5
    - name: b
      qualified: Foo.b
      loc: 3:5
    - name: <Str c>
      qualified: Foo.c
      loc: 10:5:3
    - name: <Str ✅>
      qualified: Foo.'✅'
      loc: 11:5:3
    - name: <Num 3>
      qualified: Foo.'3'
      loc: 17:5:1
    - name: <Num 1_000_000>
      qualified: Foo.'1000000'
      loc: 18:5:9
    - name: <Num 1e-3>
      qualified: Foo.'0.001'
      loc: 19:5:4
```

###### Private fields

A private field must be declared explicitly before using.

```ets 
class Foo {
    private bar: number;
    private baz = 1;

    /**
     * No more other than IdentifierName is allowed
     *
     * e.g.:
     * #'c'
     * #3
     * #[`!computed${d}`]
     *
     * These examples are all INVALID.
     */
}
```

```yaml
name: Private class fields
entity:
  type: field
  extra: false
  items:
    - name: bar
      qualified: Foo.bar
      loc: 2:13
      type: field
      private: false
      TSVisibility: private
    - name: baz
      qualified: Foo.baz
      loc: 3:13
      type: field
      private: false
      TSVisibility: private
```

#### Syntax: Static Fields

```text
ClassElement :
    `static` FieldDefinition `;`
    ...
```

##### Examples

###### Static fields

```ets
class Foo {
    static a;
    static private bar;
}
```

```yaml
name: Static class fields
entity:
  type: field
  extra: false
  items:
    - name: a
      qualified: Foo.a
      loc: 2:12
      type: field
      static: true
      TSVisibility: public
    - name: bar
      qualified: Foo.bar
      loc: 3:20
      type: field
      static: true
      TSVisibility: private
```

#### Runtime: Implicitly Declare Using `this.*`

Public field declarations could be omitted in the up-front of a class declaration, however, doing so would make the code
less self-document.

##### Examples

###### Implicit field declaration

```ets
class Rectangle {
  height: number;
  width: number;

  // Valid
  constructor({height, width}) {
    this.height = height;
    this.width = width;
  }
}
```

```yaml
name: Implicit field declaration
entity:
  type: field
  extra: false
  items:
    - name: height
      qualified: Rectangle.constructor.height
      type: parameter
      loc: 6:16
    - name: width
      qualified: Rectangle.constructor.width
      type: parameter
      loc: 6:24
    - name: height
      qualified: Rectangle.height
      loc: 2:3
      type: field
      implicit: true
      TSVisibility: public
    - name: width
      qualified: Rectangle.width
      loc: 3:3
      type: field
      implicit: true
      TSVisibility: public
```

#### Syntax: TypeScript Field Accessibility Modifiers

```text
ClassElementName :
    [AccessibilityModifier] PropertyName
    PrivateIdentifier
    
AccessibilityModifier :
    `public`
    `protected`
    `private`
```

TypeScript field accessibility modifiers are only enforced at **compile-time**, and can also be defeated by cast the
type of instances into `any`. In contract, ECMAScript 2019 added private fields feature that works at **run-time**.
ECMAScript private fields **CANNOT** be modified by TypeScript field accessibility modifiers.

##### Examples

###### The `public` modifier

Fields modified by `public` can be accessed anywhere, which is the default behavior.

```ets
class Foo {
  public field0: number;
  field1: number;
}
```

```yaml
name: TS public field modifier
entity:
  type: field
  extra: false
  items:
    - name: field0
      qualified: Foo.field0
      loc: 2:10
      TSVisibility: public
    - name: field1
      qualified: Foo.field1
      loc: 3:3
      TSVisibility: public
```

###### The `protected` modifier

Fields modified by `protected` can be accessed from the base class and also derived classes.

```ets
class Foo {
  protected field0: number;
}
```

```yaml
name: TS field protected modifier
entity:
  type: field
  extra: false
  items:
    - name: field0
      qualified: Foo.field0
      loc: 2:13
      TSVisibility: protected
```

###### The `private` modifier

Fields modified by `private` can only be accessed from the base class.

```ets
class Foo {
  private field0: number;
}
```

```yaml
name: TS field private modifier
entity:
  type: field
  extra: false
  items:
    - name: field0
      qualified: Foo.field0
      loc: 2:11
      TSVisibility: private
```

###### Cannot be used with private identifier

```ets
class Foo {
  protected #a;
  // TSError: An accessibility modifier cannot be used with a private identifier.
}
```

```yaml
name: TS modifier cannot be used with private identifier
entity:
  type: field
  extra: false
  items:
    - name: <Pvt a>
      qualified: Foo.#a
      loc: 2:13
      TSVisibility: protected
      negative: true
```

#### Syntax: TypeScript Implicit Field Declarations

```text
ConstructorDeclaration:
    [AccessibilityModifier] `constructor` `(` ParameterList `)` `{` FunctionBody `}`
    [AccessibilityModifier] `constructor` `(` ParameterList `)` `;`
```

`BindingPattern` of parameters cannot be used with parameters' `AccessibilityModifier`.

##### Examples

###### Implicit field declarations with accessibility modifier

```ets
class Rectangle {
  /**
   * In TypeScript, fields must be explicitly declared
   * before referenced using `this.*`.
   * If this is forced to be ignored, then it will fallback to
   * JS implicit field declaration that works in runtime.
   */
  area: number;
  private height: number;
  private width: number;
  constructor(height: number, width: number) {
    /**
     * Below two expressions are not necessary.
     * TypeScript will automatically insert these at compile time.
     */
    // this.height = height;
    // this.width = width;
    this.area = height * width;
  }
}
```

```yaml
name: TS implicit field declaration with accessibility modifier
entity:
  type: field
  extra: false
  items:
    - name: height
      qualified: Rectangle.height
      loc: 9:11
      TSVisibility: private
    - name: width
      qualified: Rectangle.width
      loc: 10:11
      TSVisibility: private
    - name: area
      qualified: Rectangle.area
      loc: 8:3
      TSVisibility: public
```

###### Clarify: Parameter fields vs parameters

```ets
class Foo {
  public a: number;
  constructor(a: number, b: number, c: number) {
    /**
     * `a` is modified by `public`, thus becomes a field,
     * which makes following commented expresssion unnecessary.
     */
    // this.a = a;

    /**
     * JS style implicit field declaration.
     */
    // @ts-ignore
    this.b = b;

    /**
     * `c` can only be referenced as parameter.
     */
    console.log(c);
  }
}
```

```yaml
name: Parameter fields and parameters clarify
entity:
  type: field
  extra: false
  items:
    - name: a
      qualified: Foo.a
      loc: 2:10
      type: field
      TSVisibility: public
    - name: a
      qualified: Foo.constructor.a
      loc: 3:15
      type: parameter
    - name: b
      qualified: Foo.constructor.b
      loc: 3:26
      type: parameter
    - name: c
      qualified: Foo.constructor.c
      loc: 3:37
      type: parameter
```

#### Syntax: TypeScript Abstract Field

```text
(No official doc found)
TSAbstract Property :
    `abstract` PropertyName [PropertySignature]
```

Abstract fields cannot be initialized within any abstract classes.

> Fields with `MethodSignature` are extracted as `Method Entity`, continue
> reading [abstract methods](./method.md#abstract-methods) section to learn more.

##### Examples

###### Abstract fields

```ets
abstract class Foo {
  abstract field0: number;
  public abstract field1: number;
  protected abstract field2: number;

  // Invalid
  // TSError: 'private' modifier cannot be used with 'abstract' modifier.
  private abstract field3: number;
  // TSError: 'abstract' modifier cannot be used with a private identifier.
  abstract #field4: number;
  // TSError: 'static' modifier cannot be used with 'abstract' modifier.
  static abstract field5: number;
}
```

```yaml
name: Abstract fields
entity:
  type: field
  extra: false
  items:
    - name: field0
      qualified: Foo.field0
      loc: 2:12
      abstract: true
      TSVisibility: public
    - name: field1
      qualified: Foo.field1
      loc: 3:19
      abstract: true
      TSVisibility: public
    - name: field2
      qualified: Foo.field2
      loc: 4:22
      abstract: true
      TSVisibility: protected
    - name: field3
      qualified: Foo.field3
      loc: 8:20
      abstract: true
      TSVisibility: private
      negative: true
    - name: <Pvt field4>
      qualified: Foo.#field4
      loc: 10:12
      abstract: true
      negative: true
    - name: field5
      qualified: Foo.field5
      loc: 12:19
      abstract: true
      static: true
      negative: true
```

<!-- ###### `abstract` fields must be declared within an abstract class -->

```ets
class Foo {
  // TSError: Abstract methods can only appear within an abstract class.
  abstract foo: number;
}
```

```yaml
name: Abstract fields in a non-abstract class
entity:
  extra: false
  items:
    - name: Foo
      type: class
      loc: 1:7:3
      abstract: false
```

#### Syntax: Auto-Accessor Fields

```text
https://github.com/microsoft/TypeScript/pull/49705
https://github.com/tc39/proposal-decorators
https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-9.html#auto-accessors-in-classes
```

Stage 3 proposal. Available in TypeScript 4.9.But NOT support in Babel/Arkbel.

##### Examples

###### Auto-accessor fields

```ts
class Example {
    accessor myBool;
}
```

```yaml
entity:
    type: field
    extra: false
    items:
        -   name: myBool
            loc: 2:14
            TSVisibility: accessor
```

### Properties

| Name         | Description                                              |                           Type                           |   Default   |
|--------------|----------------------------------------------------------|:--------------------------------------------------------:|:-----------:|
| isStatic     | Indicates a static field.                                |                        `boolean`                         |   `false`   |
| isPrivate    | Indicates a private field.                               |                        `boolean`                         |   `false`   |
| isImplicit   | Indicates a field is created implicitly.                 |                        `boolean`                         |   `false`   |
| isAbstract   | Indicates an abstract field in an abstract class.        |                        `boolean`                         |   `false`   |
| TSVisibility | TypeScript class hierarchy visibility.                   | `undefined` \| 'public'` \| `'protected'` \| `'private'` | `undefined` |
| isAccessor   | (New stage 3 proposal) Indicates an auto-accessor field. |                        `boolean`                         |   `false`   |
