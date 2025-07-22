// 可以声明一个可空类型并使用null作为缺省值
class Point {
    x: number | null = 0
    y: number | null = 0
}

let p = new Point()
p.y = null