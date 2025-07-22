## Relation: Implement

An `ArkTS relation` is a sample of Custom Components containing properties and methods defined by keyword `arkts`.

### Supported Patterns

```yaml
name: ArkTS new rules relations declaration
```

#### Syntax: Block Statement

```text
(Not class/enum/function/interface/method/namespace/struct)
    `{` ... `}`
```

##### Examples

###### arkts-implements-only-iface

```ets
class Foo {
    prop0: number;
}

class Bar implements Foo {
    prop0: number;
}
```

```yaml
name: arkts-implements-only-iface
relation:
    type: implement
    extra: false
    items:
        -   from: class:'Bar'
            to: class:'Foo'
            loc: file0:5:22
```

###### arkts-no-ctor-signatures-type

```ets
class SomeObject {
    public f: string
    constructor (s: string) {
        this.f = s
    }
}

function fn(s: string): SomeObject {
    return new SomeObject(s)
}
```

```yaml
name: arkts-no-ctor-signatures-type
relation:
    type: call
    extra: false
    items:
        -   from: function:'fn'
            to: method:'SomeObject.constructor'
            loc: 9:16
            new: true
        -   from: function:'fn'
            to: class:'SomeObject'
            loc: 9:16
            new: true
```

###### arkts-no-intersection-types

```ets
interface Identity {
    id: number
    name: string
}

interface Contact {
    email: string
    phoneNumber: string
}

interface Employee extends Identity,  Contact {}
```

```yaml
name: arkts-no-intersection-types
entity:
    extra: false
    items:
        -   name: Identity
            loc: 1:11
            type: interface
        -   name: Contact
            qualified: X.f
            loc: 6:11
            type: interface
        -   name: Employee
            loc: 11:11
            type: interface
relation:
    type: extend
    extra: false
    items:
        -   from: interface:'Employee'
            to: interface:'Identity'
            loc: file0:11:28
        -   from: interface:'Employee'
            to: interface:'Contact'
            loc: file0:11:39
```

###### arkts-no-ctor-signatures-iface

```ets
interface I {
    create(s: string): I
}

function fn(i: I) {
    return i.create("hello")
}
```

```yaml
name: arkts-no-ctor-signatures-iface
entity:
    extra: false
    items:
        -   name: I
            loc: 1:11
            type: interface
        -   name: fn
            loc: 5:10
            type: function
        -   name: i
            qualified: fn.i
            loc: 5:13
            type: parameter
relation:
    type: use
    extra: false
    items:
        -   from: function:'fn'
            to: parameter:'fn.i'
            loc: file0:6:12
        -   from: interface:'I'
            to: method:'create'
            loc: file0:2:24
            type: type
        -   from: interface:'I'
            to: parameter:'fn.i'
            loc: file0:5:16
            type: type
```

###### arkts-no-props-by-index

problem: an excess "use" relation is extracted

```ets
class Point {
    x: number = 0
    y: number = 0
}
let p: Point = {x: 1, y: 2}
console.log(p.x)

class Person {
    name: string
    age: number
    email: string
    phoneNumber: string

    constructor(name: string, age: number, email: string,
                phoneNumber: string) {
        this.name = name
        this.age = age
        this.email = email
        this.phoneNumber = phoneNumber
    }
}

let person = new Person("John", 30, "***@example.com", "18*********")
console.log(person["name1"])         // Compile-time error
console.log(person.unknownProperty) // Compile-time error

let arr = new Int32Array(1)
console.log(arr[0])
```

```yaml
name: arkts-no-props-by-index
relation:
    type: use
    extra: true
    items:
        -   from: method:'Person.constructor'
            to: parameter:'Person.constructor.name'
            loc: file0:16:21
        -   from: method:'Person.constructor'
            to: parameter:'Person.constructor.age'
            loc: file0:17:20
        -   from: method:'Person.constructor'
            to: parameter:'Person.constructor.email'
            loc: file0:18:22
        -   from: method:'Person.constructor'
            to: parameter:'Person.constructor.phoneNumber'
            loc: file0:19:28
        -   from: file:'<File file0.ets>'
            to: variable:'p'
            loc: file0:6:13
        -   from: file:'<File file0.ets>'
            to: variable:'person'
            loc: file0:24:13
        -   from: file:'<File file0.ets>'
            to: variable:'person'
            loc: file0:25:13        
        -   from: file:'<File file0.ets>'
            to: variable:'arr'
            loc: file0:28:13
```

###### arkts-no-structural-typing

```ets
interface I1 {
    f(): string
}

type I2 = I1 // I2 is an alias of I1

class B {
    n: number = 0
    s: string = ""
}

// D extends B, establishing a child‑parent relationship
class D extends B {
    constructor() {
        super()
    }
}

let b = new B()
let d = new D()

console.log("Assign D to B")
b = d // Valid assignment because B is the parent class of D

// Assigning b to d will cause a compile‑time error
// d = b

interface Z {
   n: number
   s: string
}

// Class X implements interface Z
class X implements Z {
    n: number = 0
    s: string = ""
}

// Class Y implements interface Z
class Y implements Z {
    n: number = 0
    s: string = ""
}

let x: Z = new X()
let y: Z = new Y()

console.log("Assign X to Y")
y = x // Valid assignment; they are the same type

console.log("Assign Y to X")
x = y // Valid assignment; they are the same type

function foo(c: Z): void {
    console.log(c.n, c.s)
}

// Since classes X and Y implement the same interface, both calls below are valid
foo(new X())
foo(new Y())
```

```yaml
name: arkts-no-structural-typing
relation:
    extra: false
    items:
        -   from: class:'Y'
            to: interface:'Z'
            loc: file0:40:20
            type: implement
        -   from: class:'X'
            to: interface:'Z'
            loc: file0:34:20
            type: implement
        -   from: class:'D'
            to: class:'B'
            loc: file0:13:17
            type: extend
        -   from: file:'<File file0.ets>'
            to: class:'Y'
            loc: file0:60:9
            type: call
        -   from: file:'<File file0.ets>'
            to: function:'foo'
            loc: file0:59:1
            type: call
        -   from: file:'<File file0.ets>'
            to: class:'X'
            loc: file0:59:9
            new: true
            type: call
```

###### arkts-no-func-apply-bind-call
<!-- Not fully implemented yet -->
```ets
class Person {
    firstName : string

    constructor(firstName : string) {
        this.firstName = firstName
    }
    fullName() : string {
        return this.firstName
    }
}

let person = new Person("")
let person1 = new Person("Mary")

// This will print "Mary"
console.log(person1.fullName())
```

```yaml
name: arkts-no-func-apply-bind-call
entity:
    extra: false
    items:
        -   name: person
            loc: 12:5
            type: variable
            kind: let
        -   name: person1
            loc: 13:5
            type: variable
            kind: let
        -   name: Person
            loc: 1:7
            type: class
        -   name: constructor
            qualified: Person.constructor
            loc: 4:5
            type: method
            kind: constructor
            TSVisibility: public
        -   name: fullName
            qualified: Person.fullName
            loc: 7:5
            type: method
            TSVisibility: public
relation:
    type: call
    extra: false
    items:
        -   from: file:'<File file0.ets>'
            to: class:'Person'
            loc: 12:18
        -   from: file:'<File file0.ets>'
            to: method:'Person.constructor'
            loc: 12:18
        -   from: file:'<File file0.ets>'
            to: class:'Person'
            loc: 13:19
        -   from: file:'<File file0.ets>'
            to: method:'Person.constructor'
            loc: 13:19
        -   from: file:'<File file0.ets>'
            to: method:'Person.fullName'
            loc: 16:13       
```

###### arkts-no-definite-assignment
<!-- Not fully implemented yet -->
```ets
function initialize() : number {
    return 10
}

let x: number = initialize()

console.log("x = " + x)
```

```yaml
name: arkts-no-definite-assignment
entity:
    extra: false
    items:
        -   name: initialize
            loc: 1:10
            type: function
        -   name: x
            loc: 5:5
            type: variable
            kind: let
relation:
    type: call
    extra: false
    items:
        -   from: file:'<File file0.ets>'
            to: function:'initialize'
            loc: file0:5:17
```

###### arkts-no-js-extension
```js
export function func() {
    /* Empty */
}
```

```ets
import {func} from './file0';
```

```yaml
name: arkts-no-js-extension
pkg:
    type: module
relation:
    type: import
    extra: false
    items:
        -   from: file:'<File file1.ets>'
            to: function:'func'
            loc: file1:1:9
```

###### arkts-no-umd
<!-- Not fully implemented yet -->
```ts
export namespace mathLib {
    export function isPrime(x: number): boolean
}
```

```ets
import {mathLib} from './file0'
mathLib.isPrime(2)
```

```yaml
name: arkts-no-umd
pkg:
    type: module
relation:
    type: import
    extra: false
    items:
        -   from: file:'<File file1.ets>'
            to: namespace:'mathLib'
            loc: file1:1:9 
```

###### arkts-no-ts-deps
```ts
export class C {
    // ...
}
```

```ets
import {C} from './file0'
```

```yaml
name: arkts-no-ts-deps
pkg:
    type: module
relation:
    type: import
    extra: false
    items:
        -   from: file:'<File file1.ets>'
            to: class:'C'
            loc: file1:1:9
```

<!-- Not fully implemented yet -->
###### arkts-no-obj-literals-as-types
```ets
class O {
    x: number = 0
    y: number = 0
}

let o: O = {x: 2, y: 3}

type S = Set<O>
```

```yaml
name: arkts-no-obj-literals-as-types
entity:
    extra: false
    items:
        -   name: O
            loc: 1:7
            type: class
        -   name: o
            loc: 6:5
            type: variable
            kind: let
        -   name: S
            loc: 8:6
            type: type alias
relation:
    extra: false
    items:
        -   from: file:'<File file0.ets>'
            to: variable:'o'
            loc: file0:6:5
            type: set
            init: true
        -   from: class:'O'
            to: variable:'o'
            loc: file0:6:8
            type: type
```

###### arkts-no-noninferrable-arr-literals
```ets
class C {
    n: number = 0
    s: string = ""
}

let a1 = [{n: 1, s: "1"} as C, {n: 2, s : "2"} as C] // type of a1 is “C[]”
let a2: C[] = [{n: 1, s: "1"}, {n: 2, s : "2"}]      // type of a2 is “C[]”
```

```yaml
name: arkts-no-noninferrable-arr-literals
entity:
    extra: false
    items:
        -   name: a1
            loc: 6:5
            type: variable
            kind: let
        -   name: a2
            loc: 7:5
            type: variable
            kind: let
relation:
    extra: false
    items:
        -   from: file:'<File file0.ets>'
            to: variable:'a1'
            loc: file0:6:5
            type: set
            init: true
        -   from: file:'<File file0.ets>'
            to: variable:'a2'
            loc: file0:7:5
            type: set
            init: true
```

###### arkts-no-func-expressions
```ets
function generic_func<T extends String>(x: T): T {
    return x
}

generic_func<String>("string")
```

```yaml
name: arkts-no-func-expressions
entity:
    extra: false
    items:
        -   name: generic_func
            loc: 1:10
            type: function
        -   name: x
            qualified: generic_func.x
            loc: 1:41
            type: parameter
        -   name: T
            qualified: generic_func.T
            loc: 1:23
            type: type parameter
relation:
    extra: false
    items:
        -   from: function:'generic_func'
            to: parameter:'generic_func.x'
            loc: file0:2:12
            type: use
        -   from: file:'<File file0.ets>'
            to: function:'generic_func'
            loc: file0:5:1
            type: call
        -   from: type parameter:'generic_func.T'
            to: parameter:'generic_func.x'
            loc: file0:1:44
            type: type
        -   from: type parameter:'generic_func.T'
            to: function:'generic_func'
            loc: file0:1:48
            type: type
```

<!-- Not fully implemented yet -->//TODO:Calling a superclass method from a subclass
###### arkts-no-method-reassignment

```ets
class C {
    foo() {
        console.log("foo")
    }
}

class Derived extends C {
    foo() {
        console.log("Extra")
        super.foo()
    }
}

function bar() {
    console.log("bar")
}

let c1 = new C()
let c2 = new C()
c1.foo() // foo
c2.foo() // foo

let c3 = new Derived()
c3.foo() // Extra foo
```

```yaml
name: arkts-no-method-reassignment
entity:
    extra: false
    items:
        -   name: C
            loc: 1:7
            type: class
        -   name: foo
            qualified: C.foo
            loc: 2:5
            type: method
            TSVisibility: public
        -   name: Derived
            loc: 7:7
            type: class
        -   name: foo
            qualified: Derived.foo
            loc: 8:5
            type: method
            TSVisibility: public
        -   name: bar
            loc: 14:10
            type: function
        -   name: c1
            loc: 18:5
            type: variable
            kind: let
        -   name: c2
            loc: 19:5
            type: variable
            kind: let
        -   name: c3
            loc: 23:5
            type: variable
            kind: let
relation:
    type: call
    extra: false
    items:
        -   from: class:'Derived'
            to: class:'C'
            loc: file0:7:23
            type: extend
        -   from: file:'<File file0.ets>'
            to: class:'C'
            loc: file0:18:14
        -   from: file:'<File file0.ets>'
            to: class:'C'
            loc: file0:19:14
        -   from: file:'<File file0.ets>'
            to: class:'Derived'
            loc: file0:23:14
        -   from: file:'<File file0.ets>'
            to: method:'C.foo'
            loc: file0:20:1
        -   from: file:'<File file0.ets>'
            to: method:'C.foo'
            loc: file0:21:1
        -   from: file:'<File file0.ets>'
            to: method:'Derived.foo'
            loc: file0:24:1
```


###### arkts-as-casts
problem: Need to be fixed soon(I don't know it neither)
```ets
class Shape {}
class Circle extends Shape { x: number = 5 }
class Square extends Shape { y: string = "a" }

function createShape(): Shape {
    return new Circle()
}

let c2 = createShape() as Circle

// Throws ClassCastException at runtime:
// let c3 = createShape() as Square

// Creating a Number object yields expected result:
let e2 = (new Number(5.0)) instanceof Number // true
```

```yaml
name: arkts-as-casts
entity:
    extra: false
    items:
        -   name: Shape
            loc: 1:7
            type: class
        -   name: Circle
            loc: 2:7
            type: class
        -   name: Square
            loc: 3:7
            type: class
        -   name: createShape
            loc: 5:10
            type: function
        -   name: c2
            loc: 9:5
            type: variable
            kind: let
        -   name: e2
            loc: 15:5
            type: variable
            kind: let
relation:
    extra: false
    items:
        -   from: class:'Circle'
            to: class:'Shape'
            loc: file0:2:22
            type: extend
        -   from: class:'Square'
            to: class:'Shape'
            loc: file0:3:22
            type: extend
        -   from: class:'Shape'
            to: function:'createShape'
            loc: file0:5:25
            type: type
        -   from: function:'createShape'
            to: class:'Circle'
            loc: file0:6:16
            type: call
            new: true
        -   from: file:'<File file0.ets>'
            to: function:'createShape'
            loc: file0:9:10
            type: call
```

<!-- Not fully implemented yet -->
###### arkts-no-delete
```ets
// You can declare a nullable type and use null as the default value
class Point {
    x: number | null = 0
    y: number | null = 0
}

let p = new Point()
p.y = null
```

```yaml
name: arkts-no-delete
entity:
    extra: false
    items:
        -   name: Point
            loc: 2:7
            type: class
        -   name: x
            qualified: Point.x
            loc: 3:5
            type: field
            TSVisibility: public
        -   name: y
            qualified: Point.y
            loc: 4:5
            type: field
            TSVisibility: public
        -   name: p
            loc: 7:5
            type: variable
            kind: let
relation:
    type: call
    extra: false
    items:
        -   from: file:'<File file0.ets>'
            to: class:'Point'
            loc: file0:7:5
            new: true
```


###### arkts-instanceof-ref-types
problem:May be ignore this kind of expression when get task?
```ets
class X {
    // ...
}

let a = (new X()) instanceof Object // true
let b = (new X()) instanceof X      // true
// let c = X instanceof Object         // Compile-time error: left operand is a type
// let d = X instanceof X              // Compile-time error: left operand is a type
```

```yaml
name: arkts-instanceof-ref-types
entity:
    extra: false
    items:
        -   name: X
            loc: 1:7
            type: class
        -   name: a
            loc: 5:5
            type: variable
            kind: let
        -   name: b
            loc: 6:5
            type: variable
            kind: let
relation:
    type: call
    extra: false
    items:
        -   from: file:'<File file0.ets>'
            to: class:'X'
            loc: file0:5:5
            new: true
        -   from: file:'<File file0.ets>'
            to: class:'X'
            loc: file0:6:5
            new: true
```

<!-- Not fully implemented yet -->
###### arkts-no-in
```ets
class Person {
    name: string = ""
}
let p = new Person()

let b = p instanceof Person // true, and the property 'name' definitely exists
```

```yaml
name: arkts-no-in
entity:
    extra: false
    items:
        -   name: Person
            loc: 1:7
            type: class
        -   name: name
            loc: 2:5
            type: field
            TSVisibility: public
        -   name: p
            loc: 4:5
            type: variable
            kind: let
        -   name: b
            loc: 6:5
            type: variable
            kind: let
relation:
    type: set
    extra: false
    items:
        -   from: file:'<File file0.ets>'
            to: class:'Person'
            loc: file0:4:5
            type: call
            new: true
        -   from: file:'<File file0.ets>'
            to: variable:'p'
            loc: file0:4:5
            init: true
        -   from: file:'<File file0.ets>'
            to: variable:'b'
            loc: file0:6:5
            init: true
        -   from: class:'Person'
            to: field:'name'
            loc: file0:2:5
            init: true
```
<!-- Not fully implemented yet -->
###### arkts-no-destruct-assignment
```ets
let arr: number[] = [1, 2]
let one = arr[0]
let two = arr[1]

let tmp = one
one = two
two = tmp

let data: Number[] = [1, 2, 3, 4]
let head = data[0]
let tail: Number[] = []
for (let i = 1; i < data.length; ++i) {
    tail.push(data[i])
}
```

```yaml
name: arkts-no-destruct-assignment
entity:
    extra: false
    items:
        -   name: arr
            loc: 1:5
            type: variable
            kind: let
        -   name: one
            loc: 2:5
            type: variable
            kind: let
        -   name: two
            loc: 3:5
            type: variable
            kind: let
        -   name: tmp
            loc: 5:5
            type: variable
            kind: let
        -   name: data
            loc: 9:5
            type: variable
            kind: let
        -   name: head
            loc: 10:5
            type: variable
            kind: let
        -   name: tail
            loc: 11:5
            type: variable
            kind: let
        -   name: i
            loc: 12:10
            type: variable
            kind: let
relation:
    type: set
    extra: false
    items:
        -   from: file:'<File file0.ets>'
            to: variable:'one'
            loc: file0:2:5
            init: true
        -   from: file:'<File file0.ets>'
            to: variable:'two'
            loc: file0:3:5
            init: true
        -   from: file:'<File file0.ets>'
            to: variable:'head'
            loc: file0:10:5
            init: true
        -   from: file:'<File file0.ets>'
            to: variable:'i'
            loc: file0:12:10
            init: true
        # The dependencies above are not yet completed.
        -   from: file:'<File file0.ets>'
            to: variable:'arr'
            loc: file0:1:5
            init: true
        -   from: file:'<File file0.ets>'
            to: variable:'tmp'
            loc: file0:5:5
            init: true
        -   from: file:'<File file0.ets>'
            to: variable:'data'
            loc: file0:9:5
            init: true
        -   from: file:'<File file0.ets>'
            to: variable:'tail'
            loc: file0:11:5
            init: true
        -   from: file:'<File file0.ets>'
            to: variable:'one'
            loc: file0:6:1
        -   from: file:'<File file0.ets>'
            to: variable:'two'
            loc: file0:7:1

```

<!-- Not fully implemented yet -->
###### arkts-no-comma-outside-loops
```ets
for (let i = 0, j = 0; i < 10; ++i, j += 2) {
    console.log(i)
    console.log(j)
}

// Use statements to express execution order, not the comma operator
let x = 0
++x
x = x++
```

```yaml
name: arkts-no-comma-outside-loops
entity:
    extra: false
    items:
        -   name: i
            loc: 1:10
            type: variable
            kind: let
        -   name: j
            loc: 1:17
            type: variable
            kind: let
        -   name: x
            loc: 7:5
            type: variable
            kind: let
relation:
    extra: false
    type: modify
    items:
        -   from: file:'<File file0.ets>'
            to: variable:'x'
            loc: file0:7:5
            type: set
            init: true
        -   from: file:'<File file0.ets>'
            to: variable:'x'
            loc: file0:8:1
        -   from: file:'<File file0.ets>'
            to: variable:'x'
            loc: file0:9:5
        # The above dependency has not been implemented yet.
        -   from: file:'<File file0.ets>'
            to: variable:'j'
            loc: file0:1:37
        -   from: file:'<File file0.ets>'
            to: variable:'i'
            loc: file0:1:32
        -   from: file:'<File file0.ets>'
            to: variable:'x'
            loc: file0:9:1
            type: set
```

<!-- Not fully implemented yet -->
###### arkts-no-destruct-decls
```ets
class Point {
    x: number = 0.0
    y: number = 0.0
}

function returnZeroPoint(): Point {
    return new Point()
}

// Create a local variable to handle each field
let zp = returnZeroPoint()
let x = zp.x
let y = zp.y
```

```yaml
name: arkts-no-destruct-decls
entity:
    extra: false
    items:
        -   name: Point
            loc: 1:7
            type: class
        -   name: x
            qualified: Point.x
            loc: 2:5
            type: field
            TSVisibility: public
        -   name: y
            qualified: Point.y
            loc: 3:5
            type: field
            TSVisibility: public
        -   name: returnZeroPoint
            loc: 6:10
            type: function
        -   name: zp
            loc: 11:5
            type: variable
            kind: let
        -   name: x
            loc: 12:5
            type: variable
            kind: let
        -   name: y
            loc: 13:5
            type: variable
            kind: let
relation:
    extra: false
    items:
        -   from: file:'<File file0.ets>'
            to: function:'returnZeroPoint'
            loc: file0:11:10
            type: call
        -   from: file:'<File file0.ets>'
            to: variable:'x'
            loc: file0:12:10
            type: set
            init: true            
        -   from: file:'<File file0.ets>'
            to: variable:'y'
            loc: file0:13:10
            type: set
            init: true
        # The above dependency has not been implemented yet.
        -   from: function:'returnZeroPoint'
            to: class:'Point'
            loc: file0:7:16
            type: call
            new: true
```



###### arkts-no-implicit-return-types
```ets
// Return type must be specified:
function f(x: number) : number {
    if (x <= 0) {
        return x
    }
    return g(x)
}

// Return type can be omitted because it can be inferred from f's type annotation
function g(x: number) : number {
    return f(x - 1)
}

// Return type can be omitted
function doOperation(x: number, y: number) {
    return x + y
}

console.log(f(10))
console.log(doOperation(2, 3))
```

```yaml
name: arkts-no-implicit-return-types
entity:
    extra: false
    items:
        -   name: f
            loc: 2:10
            type: function
        -   name: g
            loc: 10:10
            type: function
        -   name: doOperation
            loc: 15:10
            type: function
relation:
    extra: false
    items:
        -   from: function:'f'
            to: function:'g'
            loc: file0:6:12
            type: call
        -   from: function:'g'
            to: function:'f'
            loc: file0:11:12
            type: call
        -   from: file:'<File file0.ets>'
            to: function:'f'
            loc: file0:19:13
            type: call
        -   from: file:'<File file0.ets>'
            to: function:'doOperation'
            loc: file0:20:13
            type: call
```

###### arkts-no-destruct-params
```ets
function drawText(text: String, location: number[], bold: boolean) {
    let x = location[0]
    let y = location[1]
    console.log(text)
    console.log(x)
    console.log(y)
    console.log(bold)
}

function main() {
    drawText("Hello, world!", [100, 50], true)
}
```

```yaml
name: arkts-no-destruct-params
entity:
    extra: false
    items:
        -   name: drawText
            loc: 1:10
            type: function
        -   name: main
            loc: 10:10
            type: function
relation:
    extra: false
    items:
        -   from: function:'main'
            to: function:'drawText'
            loc: file0:11:5
            type: call
```

###### arkts-no-nested-funcs
```ets
function addNum(a: number, b: number): void {
    // Use a lambda function instead of a declared function:
    let logToConsole: (message: string) => void = (message: string): void => {
        console.log(message)
    }

    let result = a + b

    logToConsole("result is " + result)
}
```

```yaml
name: arkts-no-nested-funcs
entity:
    extra: false
    items:
        -   name: addNum
            loc: 1:10
            type: function
        -   name: logToConsole
            loc: 3:9
            type: variable
            kind: let
        -   name: <Anon ArrowFunction>
            loc: 3:51
            type: function
            arrowfunction: true
relation:
    extra: false
    items:
        -   from: function:'addNum'
            to: variable:'logToConsole'
            loc: file0:3:9
            type: set
            init: true
        -   from: function:'addNum'
            to: variable:'logToConsole'
            loc: file0:9:5
            type: call
        -   from: function:'addNum'
            to: function:'<Anon ArrowFunction>'
            loc: file0:9:5
            type: call
```

<!-- Not fully implemented yet -->
###### arkts-no-standalone-this
```ets
class A {
    count: number = 1
    m(i: number): void {
        this.count = i
    }
}

function main(): void {
    let a = new A()
    console.log(a.count)  // print "1"
    a.m(2)
    console.log(a.count)  // print "2"
}
```

```yaml
name: arkts-no-standalone-this
entity:
    extra: false
    items:
        -   name: A
            loc: 1:7
            type: class
        -   name: count
            qualified: A.count
            loc: 2:5
            type: field
            TSVisibility: public
        -   name: m
            qualified: A.m
            loc: 3:5
            type: method
            TSVisibility: public
        -   name: main
            loc: 8:10
            type: function
        -   name: a
            qualified: main.a
            loc: 9:9
            type: variable
            kind: let
relation:
    extra: false
    items:
        -   from: function:'main'
            to: class:'A'
            loc: file0:9:17
            type: call
        -   from: function:'main'
            to: method:'A.m'
            loc: file0:11:7
            type: call
        # Missing implicit dependency call relationships
        -   from: function:'main'
            to: variable:'main.a'
            loc: file0:10:17
            type: use
        -   from: function:'main'
            to: variable:'main.a'
            loc: file0:11:5
            type: use
        -   from: function:'main'
            to: variable:'main.a'
            loc: file0:12:17
            type: use
```

<!-- Not fully implemented yet -->
###### arkts-no-generators
```ets
async function complexNumberProcessing(n : number) : Promise<number> {
    //...
    return n
}

async function foo() {
    for (let i = 1; i <= 5; i++) {
        console.log(await complexNumberProcessing(i))
    }
}

foo()
```

```yaml
name: arkts-no-generators
entity:
    extra: false
    items:
        -   name: complexNumberProcessing
            loc: 1:16
            type: function
            async: true
        -   name: foo
            loc: 6:16
            type: function
            async: true
relation:
    type: call
    extra: false
    items:
        -   from: block:'<Block 7:34>'
            to: function:'complexNumberProcessing'
            loc: file0:8:27
        # The above dependencies have not been implemented yet.
        -   from: file:'<File file0.ets>'
            to: function:'foo'
            loc: file0:12:1
```

<!-- Not fully implemented yet -->
###### arkts-no-keyof
```ets
class Point {
    x: number = 1
    y: number = 2
}

function getPropertyValue(obj: Point, key: string): number {
    if (key == "x") {
        return obj.x
    }
    if (key == "y") {
        return obj.y
    }
    throw new Error()  // Handle the branch where the property does not exist
    return 0
}

function main(): void {
    let obj = new Point()
    console.log(getPropertyValue(obj, "x"))  // print"1"
    console.log(getPropertyValue(obj, "y"))  // print"2"
}
```

```yaml
name: arkts-no-keyof
entity:
    extra: false
    items:
        -   name: Point
            loc: 1:7
            type: class
        -   name: getPropertyValue
            loc: 6:10
            type: function
        -   name: main
            loc: 17:10
            type: function
relation:
    type: call
    extra: false
    items:
        -   from: function:'main'
            to: class:'Point'
            loc: file0:18:19
            new: true
        # The above represents the missing part of the call relationships.
        -   from: function:'main'
            to: function:'getPropertyValue'
            loc: file0:19:17
        -   from: function:'main'
            to: function:'getPropertyValue'
            loc: file0:20:17
```

###### arkts-extends-only-class
```ets
interface Control {
    state: number
}

interface SelectableControl extends Control {
    select(): void
}
```

```yaml
name: arkts-extends-only-class
entity:
    extra: false
    items:
        -   name: Control
            loc: 1:11
            type: interface
        -   name: SelectableControl
            loc: 5:11
            type: interface
relation:
    extra: false
    items:
        -   from: interface:'SelectableControl'
            to: interface:'Control'
            loc: file0:5:37
            type: extend
```


<!-- Not fully implemented yet -->
###### arkts-no-prop-existence-check
```ets
class A {
    foo(): void {}
    bar(): void {}
}

function getSomeObject(): A {
    return new A()
}

function main(): void {
    let tmp: Object = getSomeObject()
    let obj: A = tmp as A
    obj.foo()       // OK
    obj.bar()       // OK
//    obj.some_foo()  // Compile-time error: Method `some_foo` does not exist on this type.
}
```

```yaml
name: arkts-no-prop-existence-check
entity:
    extra: false
    items:
        -   name: A
            loc: 1:7
            type: class
        -   name: foo
            qualified: A.foo
            loc: 2:5
            type: method
            TSVisibility: public
        -   name: bar
            qualified: A.bar
            loc: 3:5
            type: method
            TSVisibility: public
        -   name: getSomeObject
            loc: 6:10
            type: function
        -   name: main
            loc: 10:10
            type: function
        -   name: tmp
            qualified: main.tmp
            loc: 11:9
            type: variable
            kind: let
        -   name: obj
            qualified: main.obj
            loc: 12:9
            type: variable
            kind: let
relation:
    type: call
    extra: false
    items:
        -   from: function:'main'
            to: function:'getSomeObject'
            loc: file0:11:23
        -   from: function:'main'
            to: method:'A.foo'
            loc: file0:13:9
        -   from: function:'main'
            to: method:'A.bar'
            loc: file0:14:9
        # The above dependencies represent the missing call relationships.
        -   from: function:'getSomeObject'
            to: class:'A'
            loc: file0:7:16
            new: true
```

###### aarkts-no-ns-as-obj
```ets
namespace MyNamespace {
    export let x: number
}

MyNamespace.x = 2
```

```yaml
name: arkts-no-ns-as-obj
entity:
    extra: false
    items:
        -   name: MyNamespace
            loc: 1:11
            type: namespace
        -   name: x
            qualified: MyNamespace.x
            loc: 2:16
            type: variable
            kind: let
relation:
    extra: false
    items:
        -   from: file:'<File file0.ets>'
            to: variable:'MyNamespace.x'
            loc: file0:5:1
            type: use
        -   from: file:'<File file0.ets>'
            to: variable:'MyNamespace.x'
            loc: file0:5:1
            type: set
        -   from: namespace:'MyNamespace'
            to: variable:'MyNamespace.x'
            loc: file0:2:16
            type: export
            kind: any
```

<!-- Not fully implemented yet -->
###### arkts-no-ns-statements
```ets
namespace A {
    export let x: number

    export function init() {
      x = 1
    }
}


A.init()
```

```yaml
name: arkts-no-ns-statements
entity:
    extra: false
    items:
        -   name: A
            loc: 1:11
            type: namespace
        -   name: x
            qualified: A.x
            loc: 2:16
            type: variable
            kind: let
        -   name: init
            loc: 4:21
            type: function            
relation:
    extra: false
    items:
        -   from: file:'<File file0.ets>'
            to: function:'A.init'
            loc: file0:10:3
            type: call   
        # The above dependencies represent the missing call relationships.
        -   from: namespace:'A'
            to: variable:'A.x'
            loc: file0:2:16
            type: export
            kind: any
```

###### arkts-no-special-imports
```ts
export type APIResponseType = number | undefined;
```

```ets
import { APIResponseType } from "./file0"
```

```yaml
name: arkts-no-special-imports
relation:
    extra: false
    items:
        -   from: file:'<File file1.ets>'
            to: type alias:'APIResponseType'
            loc: file0:1:10
            type: import
```

###### arkts-no-side-effects-imports
```ets
export const variable = 0

export function func() {
    /* Empty */
}

export class Class {
    /* Empty */
}

export type OptionalNumber = number | undefined;

export default interface Foo {
    /* Empty */
}
```

```ets
import * as ns from './file0';
```

```yaml
name: arkts-no-side-effects-imports
relation:
    extra: false
    items:
        -   from: file:'<File file1.ets>'
            to: file:'<File file0.ets>'
            loc: file1:1:8
            type: import
            alias: ns
```

###### arkts-no-import-default-as
```ets
export default interface Foo {
    /* Empty */
}
```

```ets
import Foo from './file0';
```

```yaml
name: arkts-no-import-default-as
relation:
    extra: false
    items:
        -   from: file:'<File file1.ets>'
            to: interface:'Foo'
            loc: file1:1:8
            type: import
```

###### arkts-no-require
```ets
export const variable = 0

export function func() {
    /* Empty */
}

export class Class {
    /* Empty */
}

export type OptionalNumber = number | undefined;

export default interface Foo {
    /* Empty */
}
```

```ets
import * as m from './file0';
```

```yaml
name: arkts-no-require
relation:
    extra: false
    items:
        -   from: file:'<File file1.ets>'
            to: file:'<File file0.ets>'
            loc: file1:1:8
            type: import
            alias: m
```

###### arkts-no-export-assignment
```ets
export class Point {
    constructor(x: number, y: number) {}
    static origin = new Point(0, 0)
}
```

```ets
import * as Pt from "./file0"

let p = Pt.origin
```

```yaml
name: arkts-no-export-assignment
relation:
    extra: false
    items:
        -   from: file:'<File file1.ets>'
            to: file:'<File file0.ets>'
            loc: file1:1:8
            type: import
            alias: Pt
```

###### arkts-no-special-exports
```ets
// explicitly export class1：
export class Class1 {
    // ...
}

// explicitly export class2：
export class Class2 {
    // ...
}
```

```yaml
name: arkts-no-special-exports
relation:
    type: export
    extra: false
    items:
        -   from: file:'<File file0.ets>'
            to: class:'Class1'
            loc: file0:2:14
            kind: any
        -   from: file:'<File file0.ets>'
            to: class:'Class2'
            loc: file0:7:14
            kind: any
```

<!-- ###### arkts-no-ambient-decls

```ets
// import
import { normalize } from "someModule"
```

```yaml
name: arkts-no-ambient-decls
relation:
    extra: false
    items:
        -   from: file:'<File file1.ets>'
            to: interface:'Foo'
            loc: file1:1:8
            type: import
``` -->


###### arkts-no-module-wildcards
```ets
export const variable = 0

export function func() {
    /* Empty */
}

export class Class {
    /* Empty */
}

export type OptionalNumber = number | undefined;

export default interface Foo {
    /* Empty */
}
```

```ets
// del
declare namespace N {
    function foo(x: number): number
}

import * as m from "./file0"
console.log("N.foo called: ", N.foo(42))
```

```yaml
name: arkts-no-module-wildcards
entity:
    extra: false
    items:
        -   name: N
            loc: file0:2:19
            type: namespace
        # Missing entity resolution
        -   name: foo
            qualified: N.foo
            loc: file0:3:14
            type: function        
relation:
    extra: false
    items:
        -   from: file:'<File file1.ets>'
            to: file:'<File file0.ets>'
            loc: file1:6:8
            type: import
            alias: m
```

<!-- Not fully implemented yet -->
###### arkts-no-untyped-obj-literals
```ets
class C1 {
    n: number = 0
    s: string = ""
}

let o1: C1 = { n: 42, s: "foo" }
let o2: C1 = { n: 42, s: "foo" }
let o3: C1 = { n: 42, s: "foo" }

let oo: C1[] = [{ n: 1, s: "1" }, { n: 2, s: "2" }]

class C2 {
    s: string
    constructor(s: string) {
        this.s = "s =" + s
    }
}
let o4 = new C2("foo")

class C3 {
    n: number = 0
    s: string = ""
}
let o5: C3 = { n: 42, s: "foo" }

abstract class A {}
class C extends A {}
let o6: C = {}  // or let o6: C = new C()

class C4 {
    n: number = 0
    s: string = ""
    f() {
        console.log("Hello")
    }
}
let o7 = new C4()
o7.n = 42
o7.s = "foo"

class Point {
    x: number = 0
    y: number = 0

    // When using constructor() before literal initialization to create a valid object.
    // Since no constructor is defined explicitly, compiler adds a default constructor.
}

function id_x_y(o: Point): Point {
    return o
}

// Literal initialization requires explicit type definition
let p: Point = { x: 5, y: 10 }
id_x_y(p)

// id_x_y accepts Point type; literal initialization creates a new Point instance
id_x_y({ x: 5, y: 10 })
```

```yaml
name: arkts-no-untyped-obj-literals
entity:
    extra: false
    items:
        -   name: C1
            loc: 1:7
            type: class
        -   name: o1
            loc: 6:5
            type: variable
            kind: let
        -   name: o2
            loc: 7:5
            type: variable
            kind: let
        -   name: o3
            loc: 8:5
            type: variable
            kind: let
        -   name: oo
            loc: 10:5
            type: variable
            kind: let
        -   name: C2
            loc: 12:7
            type: class
        -   name: constructor
            qualified: C2.constructor
            loc: 14:5
            type: method
            kind: constructor
            TSVisibility: public
        -   name: o4
            loc: 18:5
            type: variable
            kind: let
        -   name: C3
            loc: 20:7
            type: class
        -   name: o5
            loc: 24:5
            type: variable
            kind: let
        -   name: A
            loc: 26:16
            type: class
            abstract: true
        -   name: C
            loc: 27:7
            type: class
        -   name: o6
            loc: 28:5
            type: variable
            kind: let
        -   name: C4
            loc: 30:7
            type: class
        -   name: f
            loc: 33:5
            type: method
            kind: method
            TSVisibility: public
        -   name: o7
            loc: 37:5
            type: variable
            kind: let
        -   name: Point
            loc: 41:7
            type: class
        -   name: id_x_y
            loc: 49:10
            type: function
        -   name: p
            loc: 54:5
            type: variable
            kind: let
relation:
    type: set
    extra: true
    items:
        -   from: file:'<File file0.ets>'
            to: variable:'o1'
            loc: file0:6:5
            init: true
        -   from: file:'<File file0.ets>'
            to: variable:'o2'
            loc: file0:7:5
            init: true
        -   from: file:'<File file0.ets>'
            to: variable:'o3'
            loc: file0:8:5
            init: true
        -   from: file:'<File file0.ets>'
            to: variable:'oo'
            loc: file0:10:5
            init: true
        -   from: file:'<File file0.ets>'
            to: variable:'o4'
            loc: file0:18:5
            init: true
        -   from: file:'<File file0.ets>'
            to: variable:'o7'
            loc: file0:37:5
            init: true
        -   from: file:'<File file0.ets>'
            to: variable:'o5'
            loc: file0:24:5
            init: true
        -   from: file:'<File file0.ets>'
            to: variable:'o6'
            loc: file0:28:5
            init: true
        -   from: file:'<File file0.ets>'
            to: variable:'p'
            loc: file0:54:5
            init: true
```

###### arkts-no-globalthis
```ets
export let abc : number = 0
```

```ets
import * as M from "./file0"

M.abc = 200
```

```yaml
name: arkts-no-globalthis
relation:
    extra: false
    items:
        -   from: file:'<File file1.ets>'
            to: file:'<File file0.ets>'
            loc: file0:1:8
            type: import
            alias: M
```

###### arkts-no-import-assertions
```ets
export let abc : number = 0
```

```ets
import {abc} from "./file0"
```

```yaml
name: arkts-no-import-assertions
relation:
    extra: false
    items:
        -   from: file:'<File file1.ets>'
            to: variable:'abc'
            loc: file0:1:8
            type: import
```


###### arkts-limited-reexport
```ets
// explicitly export class1：
export class Class1 {
    // ...
}

// explicitly export class2：
export class Class2 {
    // ...
}
```

```ets
export { Class1 } from "./file0"
export { Class2 } from "./file0"

// support
// export * from "module1"
```

```ets
import { Class1, Class2 } from "./file1"

const myInstance = new MyClass()
```


```yaml
name: arkts-limited-reexport
relation:
    type: export
    extra: false
    items:
        -   from: file:'<File file0.ets>'
            to: class:'Class1'
            loc: file0:2:14
            kind: any
        -   from: file:'<File file0.ets>'
            to: class:'Class2'
            loc: file0:7:14
            kind: any
        -   from: file:'<File file1.ets>'
            to: class:'Class1'
            loc: file1:1:10
            kind: any
        -   from: file:'<File file1.ets>'
            to: class:'Class2'
            loc: file1:2:10
            kind: any
```


<!-- Not fully implemented yet -->
###### arkts-no-polymorphic-unops
```ets
let a = +5        // 5 (number type)
// let b = +"5"      // Compile-time error
let c = -5        // -5 (number type)
// let d = -"5"      // Compile-time error
let e = ~5        // -6 (number type)
// let f = ~"5"      // Compile-time error
// let g = +"string" // Compile-time error

function returnTen(): string {
    return "-10"
}

function returnString(): string {
    return "string"
}

// let x = +returnTen()    // Compile-time error
// let y = +returnString() // Compile-time error
```

```yaml
name: arkts-no-polymorphic-unops
entity:
    extra: false
    items:
        -   name: a
            loc: 1:5
            type: variable
            kind: let
        -   name: c
            loc: 3:5
            type: variable
            kind: let
        -   name: e
            loc: 5:5
            type: variable
            kind: let
        -   name: returnTen
            loc: 9:10
            type: function
        -   name: returnString
            loc: 13:10
            type: function
relation:
    type: set
    extra: false
    items:
        -   from: file:'<File file0.ets>'
            to: variable:'a'
            loc: file0:1:5
            init: true
        -   from: file:'<File file0.ets>'
            to: variable:'c'
            loc: file0:3:5
            init: true
        -   from: file:'<File file0.ets>'
            to: variable:'e'
            loc: file0:5:5
            init: true
```

###### arkts-no-extend-same-prop
```ets
class MoveStatus {
    public speed : number
    constructor() {
        this.speed = 0
    }
}
interface Mover {
    getMoveStatus(): MoveStatus
}

class ShakeStatus {
    public frequency : number
    constructor() {
        this.frequency = 0
    }
}
interface Shaker {
    getShakeStatus(): ShakeStatus
}

class MoveAndShakeStatus {
    public speed : number
    public frequency : number
    constructor() {
        this.speed = 0
        this.frequency = 0
    }
}

class C implements Mover, Shaker {
    private move_status : MoveStatus
    private shake_status : ShakeStatus

    constructor() {
        this.move_status = new MoveStatus()
        this.shake_status = new ShakeStatus()
    }

    public getMoveStatus() : MoveStatus {
        return this.move_status
    }

    public getShakeStatus() : ShakeStatus {
        return this.shake_status
    }

    public getStatus(): MoveAndShakeStatus {
        return {
            speed: this.move_status.speed,
            frequency: this.shake_status.frequency
        }
    }
}
```

```yaml
name: arkts-no-extend-same-prop
entity:
    extra: false
    items:
        -   name: MoveStatus
            loc: 1:7
            type: class
        -   name: Mover
            loc: 7:11
            type: interface
        -   name: ShakeStatus
            loc: 11:7
            type: class
        -   name: Shaker
            loc: 17:11
            type: interface
        -   name: MoveAndShakeStatus
            loc: 21:7
            type: class
        -   name: C
            loc: 30:7
            type: class
        -   name: getMoveStatus
            qualified: C.getMoveStatus
            loc: 39:12
            type: method
            TSVisibility: public
        -   name: getShakeStatus
            qualified: C.getShakeStatus
            loc: 43:12
            type: method
            TSVisibility: public
        -   name: getStatus
            qualified: C.getStatus
            loc: 47:12
            type: method
            TSVisibility: public
relation:
    extra: false
    items:
        -   from: method:'C.constructor'
            to: class:'MoveStatus'
            loc: file0:35:32
            type: call
            new: true
        -   from: method:'C.constructor'
            to: class:'ShakeStatus'
            loc: file0:36:33
            type: call
            new: true 
        -   from: class:'C'
            to: interface:'Mover'
            loc: file0:30:20
            type: implement
        -   from: class:'C'
            to: interface:'Shaker'
            loc: file0:30:27
            type: implement 
        -   from: class:'MoveStatus'
            to: method:'C.getMoveStatus'
            loc: file0:39:12
            type: type             
        -   from: class:'ShakeStatus'
            to: method:'C.getShakeStatus'
            loc: file0:43:12
            type: type 
        -   from: class:'MoveAndShakeStatus'
            to: method:'C.getStatus'
            loc: file0:47:25
            type: type 
```

###### arkts-identifiers-as-prop-names
```ets
class X {
    public name: number = 0
}
let x: X = {name: 1}
console.log(x.name)

let y = [1, 2, 3]
console.log(y[2])

// Use Map\<Object, some\_type> when needing to access data by non-identifier keys 
// (i.e., keys of different types):
let z = new Map<Object, number>()
z.set("name", 1)
z.set(2, 2)
console.log(z.get("name"))
console.log(z.get(2))
```

```yaml
name: arkts-identifiers-as-prop-names
entity:
    extra: false
    items:
        -   name: X
            loc: 1:7
            type: class
        -   name: name
            qualified: X.name
            loc: 2:12
            type: field
            TSVisibility: public
        -   name: x
            loc: 4:5
            type: variable
            kind: let
        -   name: y
            loc: 7:5
            type: variable
            kind: let
        -   name: z
            loc: 11:5
            type: variable
            kind: let
relation:
    type: use
    extra: false
    items:
        -   from: file:'<File file0.ets>'
            to: variable:'x'
            loc: file0:5:13
        -   from: file:'<File file0.ets>'
            to: variable:'y'
            loc: file0:8:13
        -   from: file:'<File file0.ets>'
            to: variable:'z'
            loc: file0:12:1
        -   from: file:'<File file0.ets>'
            to: variable:'z'
            loc: file0:13:1
        -   from: file:'<File file0.ets>'
            to: variable:'z'
            loc: file0:14:13
        -   from: file:'<File file0.ets>'
            to: variable:'z'
            loc: file0:15:13
```

<!-- Not fully implemented yet -->
###### arkts-no-func-props
```ets
class MyImage {
    // ...
}

async function readImage(
    path: string, callback: (err: Error, image: MyImage) => void
) : Promise<MyImage>
{
    return await new MyImage()
}

function readImageSync(path: string) : MyImage {
    return new MyImage()
}
```

```yaml
name: arkts-no-func-props
entity:
    extra: false
    items:
        -   name: MyImage
            loc: 1:7
            type: class
        -   name: readImage
            loc: 5:16
            type: function
            async: true
        -   name: readImageSync
            loc: 12:10
            type: function
relation:
    type: call
    extra: false
    items:
        -   from: function:'readImageSync'
            to: class:'MyImage'
            loc: file0:13:16
            new: true
        # The call dependency relationships have not been implemented yet.
        -   from: function:'readImage'
            to: class:'MyImage'
            loc: file0:9:22
            new: true
```

###### arkts-no-inferred-generic-params
```ets
function choose<T>(x: T, y: T): T {
    return Math.random() < 0.5 ? x : y
}

let x = choose(10, 20)   // OK, infers choose<number>(...)
 // let y = choose("10", 20) // Compile-time error

function greet<T>(): T {
    return "Hello" as T
}
let z = greet<string>()
```

```yaml
name: arkts-no-inferred-generic-params
entity:
    extra: false
    items:
        -   name: choose
            loc: 1:10
            type: function
        -   name: T
            qualified: choose.T
            loc: 1:17
            type: type parameter
        -   name: x
            loc: 5:5
            type: variable
            kind: let
        -   name: greet
            loc: 8:10
            type: function
        -   name: T
            qualified: greet.T
            loc: 8:16
            type: type parameter
        -   name: z
            loc: 11:5
            type: variable
            kind: let
relation:
    type: type
    extra: false
    items:
        -   from: type parameter:'greet.T'
            to: function:'greet'
            loc: file0:8:22 
        -   from: type parameter:'choose.T'
            to: parameter:'choose.y'
            loc: file0:1:29 
        -   from: type parameter:'choose.T'
            to: function:'choose'
            loc: file0:1:33 
        # Below are the missing call dependencies.
        -   from: file:'<File file0.ets>'
            to: function:'choose'
            loc: file0:5:9
            type: call
        -   from: file:'<File file0.ets>'
            to: function:'greet'
            loc: file0:11:9
            type: call  
        # Incorrectly identified type dependency:
        -   from: type parameter:'choose.T'
            to: parameter:'choose.x'
            loc: file0:1:23 
```

### Properties

| Name | Description | Type | Default |
|------|-------------|:----:|:-------:|
