class Point {
    x: number = 0.0
    y: number = 0.0
}

function returnZeroPoint(): Point {
    return new Point()
}

// 创建一个局部变量来处理每个字段：
let zp = returnZeroPoint()
let x = zp.x
let y = zp.y