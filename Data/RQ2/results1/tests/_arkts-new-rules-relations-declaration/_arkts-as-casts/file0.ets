class Shape {}
class Circle extends Shape {x: number = 5}
class Square extends Shape {y: string = "a"}

function createShape(): Shape {
    return new Circle()
}

let c2 = createShape() as Circle

// 运行时抛出ClassCastException异常：
// let c3 = createShape() as Square

// 创建Number对象，获得预期结果：
let e2 = (new Number(5.0)) instanceof Number // true