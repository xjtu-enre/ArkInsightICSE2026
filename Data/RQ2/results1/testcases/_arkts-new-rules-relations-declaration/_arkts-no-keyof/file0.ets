class Point {
    x: number = 1
    y: number = 2
}

function getPropertyValue(obj: Point, key: string): number {
    if (key == "x") {
        return obj.x
    }
    if (key == "y") {
        return obj.y
    }
    throw new Error()  // 处理没有该属性的分支
    return 0
}

function main(): void {
    let obj = new Point()
    console.log(getPropertyValue(obj, "x"))  // 打印"1"
    console.log(getPropertyValue(obj, "y"))  // 打印"2"
}