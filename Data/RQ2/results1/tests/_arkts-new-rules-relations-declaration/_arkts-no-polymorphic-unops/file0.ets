let a = +5        // 5（number类型）
// let b = +"5"      // 编译时错误
let c = -5        // -5（number类型）
// let d = -"5"      // 编译时错误
let e = ~5        // -6（number类型）
// let f = ~"5"      // 编译时错误
// let g = +"string" // 编译时错误

function returnTen(): string {
    return "-10"
}

function returnString(): string {
    return "string"
}

// let x = +returnTen()    // 编译时错误
// let y = +returnString() // 编译时错误