class C1 {
    n: number = 0
    s: string = ""
}

let o1: C1 = {n: 42, s: "foo"}
let o2: C1 = {n: 42, s: "foo"}
let o3: C1 = {n: 42, s: "foo"}

let oo: C1[] = [{n: 1, s: "1"}, {n: 2, s: "2"}]

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
let o5: C3 = {n: 42, s: "foo"}

abstract class A {}
class C extends A {}
let o6: C = {} // 或 let o6: C = new C()

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

    // 在字面量初始化之前，使用constructor()创建一个有效对象。
    // 由于没有为Point定义构造函数，编译器将自动添加一个默认构造函数。
}

function id_x_y(o: Point): Point {
    return o
}

// 字面量初始化需要显式定义类型
let p: Point = {x: 5, y: 10}
id_x_y(p)

// id_x_y接受Point类型，字面量初始化生成一个Point的新实例
id_x_y({x: 5, y: 10})