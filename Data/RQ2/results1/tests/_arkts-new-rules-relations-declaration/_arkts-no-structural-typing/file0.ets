interface I1 {
    f(): string
}

type I2 = I1 // I2是I1的别名

class B {
    n: number = 0
    s: string = ""
}

// D是B的继承类，构建了子类型和父类型的关系
class D extends B {
    constructor() {
        super()
    }
}

let b = new B()
let d = new D()

console.log("Assign D to B")
b = d // 合法赋值，因为B是D的父类

// 将b赋值给d将会引起编译时错误
// d = b

interface Z {
   n: number
   s: string
}

// 类X implements 接口Z，构建了X和Y的关系
class X implements Z {
    n: number = 0
    s: string = ""
}

// 类Y implements 接口Z，构建了X和Y的关系
class Y implements Z {
    n: number = 0
    s: string = ""
}

let x: Z = new X()
let y: Z = new Y()

console.log("Assign X to Y")
y = x // 合法赋值，它们是相同的类型

console.log("Assign Y to X")
x = y // 合法赋值，它们是相同的类型

function foo(c: Z): void {
    console.log(c.n, c.s)
}

// 类X和类Y implement 相同的接口，因此下面的两个函数调用都是合法的
foo(new X())
foo(new Y())