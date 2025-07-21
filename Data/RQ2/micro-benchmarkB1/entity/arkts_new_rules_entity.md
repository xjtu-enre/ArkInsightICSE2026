## Entity: All entity

An `ArkTS Entity` is a sample of Custom Components containing properties and methods defined by keyword `arkts`.

### Supported Patterns

```yaml
name: ArkTS new rules entity declaration
```

#### Syntax: Block Statement

```text
(Not class/enum/function/interface/method/namespace/struct)
    `{` ... `}`
```

##### Examples

###### arkts-no-private-identifiers

```ets
class B {
    #faz: number = 42
}
class C {
    private foo: number = 42
}
```

```yaml
name: arkts-no-private-identifiers
entity:
    type: field
    extra: false
    items:
        -   name: foo
            qualified: C.foo
            loc: 5:13
            type: field
            TSVisibility: private
        # 反例，不允许这里出现#符号作为private标识符
        -   name: <Pvt faz>
            qualified: B.<Pvt faz>
            loc: 2:5
            type: field
            private: true
            negative: true
```

###### arkts-no-class-literals

```ets
const Rectangle_false = class {
    constructor(height: number, width: number) {
        this.height = height
        this.width = width
    }

    height
    width
}

const rectangle_false = new Rectangle_false(0.0, 0.0)

class Rectangle {
    constructor(height: number, width: number) {
        this.height = height
        this.width = width
    }

    height: number
    width: number
}

const rectangle = new Rectangle(0.0, 0.0)
```

```yaml
name: arkts-no-class-literals
entity:
    type: class
    extra: false
    items:
        # 反例，arkts不允许出现如此的未命名类
        -   name: <Anon Class>
            loc: 1:25
            type: class
        -   name: Rectangle
            loc: 13:7
            type: class
```

###### arkts-no-var

```ets
let upper_let = 0
var scoped_var = 0
```

```yaml
name: arkts-no-var
entity:
    type: variable
    extra: false
    items:
        -   name: upper_let
            loc: 1:5
            type: variable
            kind: let
        # 反例，不允许这里出现var标识符的变量
        -   name: scoped_var
            loc: 2:5
            type: variable
            kind: var
```

###### arkts-no-call-signatures

```ets
type DescribableFunction_false = {
    description: string
    (someArg: number): string // call signature
}
```


```yaml
name: arkts-no-call-signatures
entity:
    type: property
    extra: false
    items:
        -   name: description
            qualified: DescribableFunction_false.description
            loc: 2:5
            type: property
        # 反例，不允许这里出现call signature
        -   name: <Sig Callable>
            qualified: DescribableFunction_false.<Sig Callable>
            loc: 3:5
            type: property
```
###### arkts-no-symbol

```ets
class SomeClass {
    public someProperty : string = ""
}
let o = new SomeClass()

let arr:string[] = ['a', 'b', 'c']
for (let t of arr) {
    console.log('name_' + t)
}
```


```yaml
name: arkts-no-symbol
entity:
    type: method
    extra: false
    items:
        -   name: SomeClass
            loc: 1:7
            type: class
        -   name: someProperty
            loc: 2:12
            type: field
            TSVisibility: public
```

###### arkts-no-typing-with-this

```ets
interface ListItem {
    getHead(): ListItem
}

class C {
    n: number = 0

    m(c: C) {
        console.log(c)
    }
}
```


```yaml
name: arkts-no-typing-with-this
entity:
    extra: false
    items:
        -   name: ListItem
            loc: 1:11
            type: interface
        -   name: C
            loc: 5:7
            type: class
        -   name: n
            qualified: C.n
            loc: 6:5
            type: field
            TSVisibility: public
        -   name: m
            qualified: C.m
            loc: 8:5
            type: method
            TSVisibility: public
```

###### arkts-no-conditional-types

```ets
// 在类型别名中提供显式约束
type X1<T extends number> = T

// 用Object重写，这种情况下，类型控制较少，需要更多的类型检查以确保安全
type X2<T> = Object

// Item必须作为泛型参数使用，并能正确实例化
type YI<Item, T extends Array<Item>> = Item
```

```yaml
name: arkts-no-conditional-types
entity:
    extra: false
    items:
        -   name: X1
            loc: 2:6
            type: type alias
        -   name: X2
            loc: 5:6
            type: type alias
        -   name: YI
            loc: 8:6
            type: type alias
```

###### arkts-no-multiple-static-blocks

```ets
class C {
    static s: string

    static {
        C.s = "aa"
        C.s = C.s + "bb"
    }
}
```

```yaml
name: arkts-no-multiple-static-blocks
entity:
    extra: false
    items:
        -   name: C
            loc: 1:7
            type: class
        -   name: s
            qualified: C.s
            loc: 2:12
            type: field
            static: true
            TSVisibility: public
        -   name: <Block 4:5>
            qualified: C.<Block 4:5>
            loc: 4:5
            type: block
            kind: class-static-block
```

###### arkts-no-ctor-prop-decls

```ets
class Person {
    protected ssn: string
    private firstName: string
    private lastName: string

    constructor(ssn: string, firstName: string, lastName: string) {
        this.ssn = ssn
        this.firstName = firstName
        this.lastName = lastName
    }

    getFullName(): string {
        return this.firstName + " " + this.lastName
    }
}
```

```yaml
name: arkts-no-ctor-prop-decls
entity:
    extra: false
    items:
        -   name: Person
            loc: 1:7
            type: class
        -   name: ssn
            qualified: Person.ssn
            loc: 2:15
            type: field
            TSVisibility: protected
        -   name: firstName
            qualified: Person.firstName
            loc: 3:13
            type: field
            TSVisibility: private
        -   name: lastName
            qualified: Person.lastName
            loc: 4:13
            type: field
            TSVisibility: private
        -   name: constructor
            qualified: Person.constructor
            loc: 6:5
            type: method
            kind: constructor
            TSVisibility: public
```

###### arkts-no-indexed-signatures

```ets
class X {
    public f: string[] = []
}

let myArray: X = new X()
const secondItem = myArray.f[1]
```

```yaml
name: arkts-no-indexed-signatures
entity:
    extra: false
    items:
        -   name: X
            loc: 1:7
            type: class
        -   name: f
            qualified: X.f
            loc: 2:12
            type: field
            TSVisibility: public
        -   name: myArray
            loc: 5:5
            type: variable
            kind: let
        -   name: secondItem
            loc: 6:7
            type: variable
            kind: const
```

###### arkts-no-aliases-by-index

```ets
class Point {x: number = 0; y: number = 0}
type N = number
```

```yaml
name: arkts-no-aliases-by-index
entity:
    extra: false
    items:
        -   name: Point
            loc: 1:7
            type: class
        -   name: x
            qualified: Point.x
            loc: 1:14
            type: field
            TSVisibility: public
        -   name: y
            qualified: Point.y
            loc: 1:29
            type: field
            TSVisibility: public
        -   name: N
            loc: 2:6
            type: type alias
```


###### arkts-no-as-const

```ets
// 'string'类型
let x : string = "hello"

// 'number[]'类型
let y : number[] = [10, 20]

class Label {
    text : string = ""
}

// 'Label'类型
let z : Label = {
    text: "hello"
}
```

```yaml
name: arkts-no-as-const
entity:
    extra: false
    items:
        -   name: x
            loc: 2:5
            type: variable
            kind: let
        -   name: y
            loc: 5:5
            type: variable
            kind: let
        -   name: Label
            loc: 7:7
            type: class
            kind: let
        -   name: text
            qualified: Label.text
            loc: 8:5
            type: field
            TSVisibility: public
        -   name: z
            loc: 12:5
            type: variable
            kind: let
```

###### arkts-no-any-unknown

```ets
let value_b: boolean = true // 或者 let value_b = true
let value_n: number = 42 // 或者 let value_n = 42
let value_o1: Object = true
let value_o2: Object = 42
```

```yaml
name: arkts-no-any-unknown
entity:
    type: variable
    extra: false
    items:
        -   name: value_b
            loc: 1:5
            kind: let
        -   name: value_n
            loc: 2:5
            kind: let
        -   name: value_o1
            loc: 3:5
            kind: let
        -   name: value_o2
            loc: 4:5
            kind: let
```

###### arkts-no-tuples
```ets
let t: Object[] = [3, "three"]
let n = t[0]
let s = t[1]
```

```yaml
name: arkts-no-tuples
entity:
    type: variable
    extra: false
    items:
        -   name: t
            loc: 1:5
            kind: let
        -   name: n
            loc: 2:5
            kind: let
        -   name: s
            loc: 3:5
            kind: let
```

###### arkts-no-utility-types
```ets
class C {
    p: number = 0
    m() {
        console.log(this.p)
    }
    q(r: number) {
        return this.p == r
    }
}
```

```yaml
name: arkts-no-utility-types
entity:
    extra: false
    items:
        -   name: C
            loc: 1:7
            type: class
        -   name: p
            qualified: C.p
            loc: 2:5
            type: field
            TSVisibility: public
        -   name: m
            qualified: C.m
            loc: 3:5
            type: method
            TSVisibility: public
        -   name: q
            qualified: C.q
            loc: 6:5
            type: method
            TSVisibility: public
        -   name: r
            qualified: C.q.r
            loc: 6:7
            type: parameter
# relation:
#     type: implement
#     extra: false
#     items:
```

###### arkts-no-iife
```ets
namespace C {
    // ...
}
```

```yaml
name: arkts-no-iife
entity:
    extra: false
    items:
        -   name: C
            loc: 1:11
            type: namespace
```

###### arkts-no-func-expressions
```ets
let f = (s: string) => {
    console.log(s)
}
```

```yaml
name: arkts-no-func-expressions
entity:
    extra: false
    items:
        -   name: f
            loc: 1:5
            type: variable
            kind: let
        -   name: <Anon ArrowFunction>
            loc: 1:9
            type: function
            arrowfunction: true
        -   name: s
            loc: 1:10
            type: parameter
```

<!-- 暂未支持 -->
###### arkts-no-type-query
```ets
let n1 = 42
let s1 = "foo"
console.log(typeof n1) // "number"
console.log(typeof s1) // "string"
let n2: number
let s2: string
```

```yaml
name: arkts-no-type-query
entity:
    extra: false
    items:
        -   name: n1
            loc: 1:5
            type: variable
            kind: let
        -   name: s1
            loc: 2:5
            type: variable
            kind: let
        -   name: n2
            loc: 5:5
            type: variable
            kind: let
        -   name: s2
            loc: 6:5
            type: variable
            kind: let
```

###### arkts-no-misplaced-imports
```ets
import foo from "module1"

class C {
    s: string = ""
    n: number = 0
}
```

```yaml
name: arkts-no-misplaced-imports
entity:
    extra: false
    items:
        -   name: foo
            loc: 1:8
            type: alias
        -   name: C
            loc: 3:7
            type: class
        -   name: s
            qualified: C.s
            loc: 4:5
            type: field
            TSVisibility: public
        -   name: n
            qualified: C.n
            loc: 5:5
            type: field
            TSVisibility: public
```

###### arkts-no-misplaced-imports
```ets
import foo from "module1"

class C {
    s: string = ""
    n: number = 0
}
```

```yaml
name: arkts-no-misplaced-imports
entity:
    extra: false
    items:
        -   name: foo
            loc: 1:8
            type: alias
        -   name: C
            loc: 3:7
            type: class
        -   name: s
            qualified: C.s
            loc: 4:5
            type: field
            TSVisibility: public
        -   name: n
            qualified: C.n
            loc: 5:5
            type: field
            TSVisibility: public
```

###### arkts-strict-typing
```ets
class C {
    n: number = 0
    s: string = ""
}

function foo(s: string): string {
    console.log(s)
    return s
}

let n1: number | null = null
let n2: number = 0
```

```yaml
name: arkts-strict-typing
entity:
    extra: false
    items:
        -   name: foo
            loc: 6:10
            type: function
        -   name: C
            loc: 1:7
            type: class
        -   name: s
            qualified: C.s
            loc: 3:5
            type: field
            TSVisibility: public
        -   name: n
            qualified: C.n
            loc: 2:5
            type: field
            TSVisibility: public
        -   name: n1
            loc: 11:5
            type: variable
            kind: let
        -   name: n2
            loc: 12:5
            type: variable
            kind: let
```

###### arkts-no-types-in-catch
```ets
try {
    // 一些代码
}
catch (a) {
    // 处理异常
}
```

```yaml
name: arkts-no-types-in-catch
entity:
    extra: false
    items:
        -   name: <Block 1:5>
            loc: 1:5
            type: block
            kind: any
        -   name: a
            loc: 4:8
            type: variable
            kind: let
        -   name: <Block 4:11>
            loc: 4:11
            type: block
            kind: any
```

###### arkts-no-for-in
```ets
let a: number[] = [1.0, 2.0, 3.0]
for (let i = 0; i < a.length; ++i) {
    console.log(a[i])
}
```

```yaml
name: arkts-no-for-in
entity:
    extra: false
    items:
        -   name: <Block 2:36>
            loc: 2:36
            type: block
            kind: any
        -   name: a
            loc: 1:5
            type: variable
            kind: let     
        -   name: i
            loc: 2:10
            type: variable
            kind: let    
```

###### arkts-for-of-str-arr
```ets
let a: Set<number> = new Set([1, 2, 3])
let numbers = Array.from(a.values())
for (let n of numbers) {
    console.log(n)
}
```

```yaml
name: arkts-for-of-str-arr
entity:
    extra: false
    items:
        -   name: <Block 3:24>
            loc: 3:24
            type: block
            kind: any
        -   name: a
            loc: 1:5
            type: variable
            kind: let     
        -   name: numbers
            loc: 2:5
            type: variable
            kind: let    
        -   name: n
            loc: 3:10
            type: variable
            kind: let                
```

###### arkts-no-with
```ets
let r: number = 42
console.log("Area: ", Math.PI * r * r)
```

```yaml
name: arkts-no-with
entity:
    extra: false
    items:
        -   name: r
            loc: 1:5
            type: variable
            kind: let  
```

<!-- 暂未支持 -->
###### arkts-no-decl-merging
```ets
interface Document {
    createElement(tagName: number): HTMLDivElement
    createElement(tagName: boolean): HTMLSpanElement
    createElement(tagName: string, value: number): HTMLCanvasElement
    createElement(tagName: string): HTMLElement
    createElement(tagName: Object): Element
}
```

```yaml
name: arkts-no-decl-merging
entity:
    extra: false
    items:
        -   name: Document
            loc: 1:11
            type: interface
        # 下方的实体即就是暂未支持的实体
        -   name: createElement
            loc: 2:5
            type: method
```

###### arkts-no-ctor-signatures-funcs
```ets
class Person {
    constructor(
        name: string,
        age: number
    ) {}
}
type PersonCtor = (n: string, a: number) => Person

function createPerson(Ctor: PersonCtor, n: string, a: number): Person {
    return Ctor(n, a)
}

let Impersonizer: PersonCtor = (n: string, a: number): Person => {
    return new Person(n, a)
}

const person = createPerson(Impersonizer, "John", 30)
```

```yaml
name: arkts-no-ctor-signatures-funcs
entity:
    extra: false
    items:
        -   name: Person
            loc: 1:7
            type: class
        -   name: constructor
            qualified: Person.constructor
            loc: 2:5
            type: method
            TSVisibility: public
            kind: constructor
        -   name: createPerson
            loc: 9:10
            type: function
        -   name: <Anon ArrowFunction>
            loc: 13:32
            type: function
```

###### arkts-no-enum-mixed-types
```ets
enum E1 {
    A = 0xa,
    B = 0xb,
    C = 0xc,
    D = 0xd,
    E // 推断出0xe
}

enum E2 {
    A = "0xa",
    B = "0xb",
    C = "0xc",
    D = "0xd"
}
```

```yaml
name: arkts-no-enum-mixed-types
entity:
    extra: false
    items:
        -   name: E1
            loc: 1:6
            type: enum
        -   name: A
            qualified: E1.A
            loc: 2:5
            type: enum member
        -   name: B
            qualified: E1.B
            loc: 3:5
            type: enum member
        -   name: C
            qualified: E1.C
            loc: 4:5
            type: enum member
        -   name: D
            qualified: E1.D
            loc: 5:5
            type: enum member
        -   name: E
            qualified: E1.E
            loc: 6:5
            type: enum member
        -   name: E2
            loc: 9:6
            type: enum
        -   name: A
            qualified: E2.A
            loc: 10:5
            type: enum member
        -   name: B
            qualified: E2.B
            loc: 11:5
            type: enum member
        -   name: C
            qualified: E2.C
            loc: 12:5
            type: enum member
        -   name: D
            qualified: E2.D
            loc: 13:5
            type: enum member
```

###### arkts-no-enum-merging
```ets
enum Color {
    RED,
    GREEN,
    YELLOW,
    BLACK,
    BLUE
}
```

```yaml
name: arkts-no-enum-merging
entity:
    extra: false
    items:
        -   name: Color
            loc: 1:6
            type: enum
        -   name: RED
            qualified: Color.RED
            loc: 2:5
            type: enum member
        -   name: GREEN
            qualified: Color.GREEN
            loc: 3:5
            type: enum member
        -   name: YELLOW
            qualified: Color.YELLOW
            loc: 4:5
            type: enum member
        -   name: BLACK
            qualified: Color.BLACK
            loc: 5:5
            type: enum member
        -   name: BLUE
            qualified: Color.BLUE
            loc: 6:5
            type: enum member
```

###### arkts-no-spread
```ets
function sum_numbers(...numbers: number[]): number {
    let res = 0
    for (let n of numbers)
        res += n
    return res
}
console.log(sum_numbers(1, 2, 3))

function log_numbers(x : number, y : number, z : number) {
    console.log(x, y, z)
}

let numbers: number[] = [1, 2, 3]
log_numbers(numbers[0], numbers[1], numbers[2])

let list1 : number[] = [1, 2]
let list2 : number[] = [list1[0], list1[1], 3, 4]

class Point2D {
    x: number = 0; y: number = 0
}

class Point3D {
    x: number = 0; y: number = 0; z: number = 0
    constructor(p2d: Point2D, z: number) {
        this.x = p2d.x
        this.y = p2d.y
        this.z = z
    }
}

let p3d = new Point3D({x: 1, y: 2} as Point2D, 3)
console.log(p3d.x, p3d.y, p3d.z)
```

```yaml
name: arkts-no-spread
entity:
    extra: false
    items:
        -   name: sum_numbers
            loc: 1:10
            type: function
        -   name: res
            loc: 2:9
            type: variable
            kind: let
        -   name: n
            loc: 3:14
            type: variable
            kind: let
        -   name: log_numbers
            loc: 9:10
            type: function
        -   name: numbers
            loc: 13:5
            type: variable
            kind: let
        -   name: list1
            loc: 16:5
            type: variable
            kind: let
        -   name: list2
            loc: 17:5
            type: variable
            kind: let
        -   name: Point2D
            loc: 19:7
            type: class
        -   name: Point3D
            loc: 23:7
            type: class
        -   name: p3d
            loc: 32:5
            type: variable
            kind: let
```

###### arkts-no-regexp-literals
```ets
let regex: RegExp = new RegExp("/bc*d/")
```

```yaml
name: arkts-no-regexp-literals
entity:
    extra: false
    items:
        -   name: regex
            loc: 1:5
            type: variable
            kind: let
```

###### arkts-no-mapped-types
```ets
class C {
    n: number = 0
    s: string = ""
}

class CFlags {
    n: boolean = false
    s: boolean = false
}
```

```yaml
name: arkts-no-mapped-types
entity:
    extra: false
    items:
        -   name: C
            loc: 1:7
            type: class
        -   name: n
            qualified: C.n
            loc: 2:5
            type: field
            TSVisibility: public
        -   name: s
            qualified: C.s
            loc: 3:5
            type: field
            TSVisibility: public
        -   name: CFlags
            loc: 6:7
            type: class
        -   name: n
            qualified: CFlags.n
            loc: 7:5
            type: field
            TSVisibility: public
        -   name: s
            qualified: CFlags.s
            loc: 8:5
            type: field
            TSVisibility: public        
```

###### arkts-unique-names
```ets
let X: string
type T = number[] // 为避免名称冲突，此处不允许使用X
```

```yaml
name: arkts-unique-names
entity:
    extra: false
    items:
        -   name: X
            loc: 1:5
            type: variable
            kind: let
        -   name: T
            loc: 2:6
            type: type alias
```

<!-- 暂未支持 -->
###### arkts-no-new-target
```ets
class CustomError extends Error {
    constructor(message?: string) {
        // 调用父类构造函数，继承链是静态的，且不能在运行时被改变
        super(message)
        console.log(this instanceof Error) // true
    }
}
let ce = new CustomError()
```

```yaml
name: arkts-no-new-target
entity:
    extra: false
    items:
        -   name: CustomError
            loc: 1:7
            type: class
        -   name: constructor
            qualified: CustomError.constructor
            loc: 2:5
            type: method
            kind: constructor
            TSVisibility: public
        -   name: ce
            loc: 8:5
            type: variable
            kind: let
relation:
    type: call
    extra: false
    items:
        -   from: file:'<File file0.ets>'
            to: class:'CustomError'
            loc: file0:8:14
        -   from: file:'<File file0.ets>'
            to: method:'CustomError.constructor'
            loc: file0:8:14
```

###### arkts-no-readonly-params
```ets
function foo(arr: string[]) {
    arr.slice()        // OK
    arr.push("hello!") // OK
}
```

```yaml
name: arkts-no-readonly-params
entity:
    extra: false
    items:
        -   name: foo
            loc: 1:10
            type: function
        -   name: arr
            qualified: foo.arr
            loc: 1:14
            type: parameter
relation:
    type: use
    extra: false
    items:
        -   from: function:'foo'
            to: parameter:'foo.arr'
            loc: file0:2:5
        -   from: function:'foo'
            to: parameter:'foo.arr'
            loc: file0:3:5
```

###### arkts-strict-typing-required
```ets
let s1: string | null = null // No ERROR 没有报错，合适的类型
// let s2: string = null // 编译时报错
```

```yaml
name: arkts-strict-typing-required
entity:
    extra: false
    items:
        -   name: s1
            loc: 1:5
            type: variable
            kind: let
relation:
    type: set
    extra: false
    items:
        -   from: file:'<File file0.ets>'
            to: variable:'s1'
            loc: file0:1:5
            init: true
```

###### arkts-no-decorators-except-arkui
```ets
function classDecorator(x: number, y: number): void {
    //
}

// @classDecorator // 编译时错误
class BugReport {
}
```

```yaml
name: arkts-no-decorators-except-arkui
entity:
    extra: false
    items:
        -   name: classDecorator
            loc: 1:10
            type: function
        -   name: x
            qualified: classDecorator.x
            loc: 1:25
            type: parameter
        -   name: y
            qualified: classDecorator.y
            loc: 1:36
            type: parameter
        -   name: BugReport
            loc: 6:7
            type: class
```

### Properties

| Name         | Description                                       |                           Type                           |   Default   |
|--------------|---------------------------------------------------|:--------------------------------------------------------:|:-----------:|
| isStatic     | Indicates a static field.                         |                        `boolean`                         |   `false`   |
| isPrivate    | Indicates a private field.                        |                        `boolean`                         |   `false`   |
| isImplicit   | Indicates a field is created implicitly.          |                        `boolean`                         |   `false`   |
| isAbstract   | Indicates an abstract field in an abstract class. |                        `boolean`                         |   `false`   |
| TSVisibility | TypeScript class hierarchy visibility.            | `undefined` \| 'public'` \| `'protected'` \| `'private'` | `undefined` |
| isArrowFunction | Indicates an arrow function    | `boolean` | `false` |

