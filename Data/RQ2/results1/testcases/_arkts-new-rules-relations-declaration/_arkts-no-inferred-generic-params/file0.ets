function choose<T>(x: T, y: T): T {
    return Math.random() < 0.5 ? x : y
}

let x = choose(10, 20)   // OK，推断choose<number>(...)
// let y = choose("10", 20) // 编译时错误

function greet<T>(): T {
    return "Hello" as T
}
let z = greet<string>()