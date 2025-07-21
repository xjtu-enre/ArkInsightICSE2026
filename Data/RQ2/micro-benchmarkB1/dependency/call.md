## Relation: Call

A `Call Relation` establishes a link between an upper entity and any other entities which are callable that the latter
one is called within the former one's scope.

### Supported Patterns

```yaml
name: Relation call
```

#### Syntax: Call

```text
CallExpression :
    CoverCallExpressionAndAsyncArrowHead
    SuperCall
    ImportCall
    CallExpression Arguments
    CallExpression `[` Expression `]`
    CallExpression `.` IdentifierName
    CallExpression TemplateLiteral
    CallExpression `.` PrivateIdentifier

CoverCallExpressionAndAsyncArrowHead :
    MemberExpression Arguments

Arguments :
    `(` `)`
    `(` ArgumentList `)`
    `(` ArgumentList `,` `)`

SuperCall :
    `super` Arguments

ImportCall :
    `import` `(` AssignmentExpression `)`
```

##### Examples

###### File calls callables

```ts
function foo() {
    return () => {
        /* Empty */
    }
}

class Foo {
    /**
     * When a class is 'called', it is actually the
     * constructor that is being called.
     */
    constructor() {
        /* Empty */
    }

    method0() {
        /* Empty */
    }
}

const baz = {
    prop: () => {
        /* Empty */
    }
}

const bar = foo();
bar();

new Foo().method0();

baz.prop();

/**
 * A function can also be called with `new`.
 * This is a convenient way to create an object and assign properties to it.
 */
function NewFunction() {
    this.prop = 1;
}

new NewFunction().prop // 1
```

```yaml
name: File call callables
relation:
  type: call
  extra: false
  items:
    - from: file:'<File file0.ts>'
      to: function:'foo'
      loc: file0:27:13
    - from: file:'<File file0.ts>'
      to: variable:'bar'
      loc: file0:28:1
    - from: file:'<File file0.ts>'
      to: function:'<Anon ArrowFunction>'[@loc=file0:22:11]
      loc: file0:32:1
    - from: file:'<File file0.ts>'
      to: class:'Foo'
      loc: file0:30:5
      new: true
    - from: file:'<File file0.ts>'
      to: method:'Foo.constructor'
      loc: file0:30:5
      new: true
    - from: file:'<File file0.ts>'
      to: method:'Foo.method0'
      loc: file0:30:11
    - from: file:'<File file0.ts>'
      to: function:'NewFunction'
      loc: file0:42:5
      new: true
```

###### Class with/without constructor

```ts
class A {
    constructor() {
        /* Empty */
    }
}

class B {
    /* Empty */
}

new A();
new B();
```

```yaml
name: Class with/without constructor
relation:
  type: call
  items:
    # A call to class will first try to bind to its constructor
    - from: file:'<File file0.ts>'
      to: method:'A.constructor'
      loc: 11:5:1
    # If no constructor is found, it will bind to the class itself
    - from: file:'<File file0.ts>'
      to: class:'B'
      loc: 12:5
```

#### Semantic: Immediate Call

Function expressions can be called immediately after declaration. This technique is useful as a workaround in ECMAScript
under version 2017 for using top-level `await`.

##### Examples

###### Normal immediate call

```ts
// Named
(function foo() {
    console.log('hello world');
})();

// Anonymous
(function () {
    /* Empty */
})();

// Arrow function
(() => {
    /* Empty */
})();
```

```yaml
name: Normal immediate call
entity:
  type: function
  extra: false
  items:
    - name: foo
      loc: 2:11
    - name: <Anon Function>
      loc: 7:2
    - name: <Anon ArrowFunction>
      loc: 12:2
relation:
  type: call
  extra: false
  items:
    - from: file:'<File file0.ts>'
      to: function:'foo'
      loc: file0:2:1
    - from: file:'<File file0.ts>'
      to: function:'<Anon Function>'[@loc=7]
      loc: file0:7:1
    - from: file:'<File file0.ts>'
      to: function:'<Anon Function>'[@loc=12]
      loc: file0:12:1
```

### Properties

| Name  | Description                  |   Type    | Default |
|-------|------------------------------|:---------:|:-------:|
| isNew | Indicates a `new xxx()` call | `boolean` | `false` |
