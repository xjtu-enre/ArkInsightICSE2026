// 需标注返回类型：
function f(x: number) : number {
    if (x <= 0) {
        return x
    }
    return g(x)
}

// 可以省略返回类型，返回类型可以从f的类型标注推导得到
function g(x: number) : number {
    return f(x - 1)
}

// 可以省略返回类型
function doOperation(x: number, y: number) {
    return x + y
}

console.log(f(10))
console.log(doOperation(2, 3))