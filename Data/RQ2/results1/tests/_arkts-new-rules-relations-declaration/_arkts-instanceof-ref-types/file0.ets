class X {
    // ...
}

let a = (new X()) instanceof Object // true
let b = (new X()) instanceof X      // true
// let c = X instanceof Object         // 编译时错误, 左操作数是一个类型
// let d = X instanceof X              // 编译时错误, 左操作数是一个类型