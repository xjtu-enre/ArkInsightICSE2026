function sum_numbers(...numbers: number[]): number {
    let res = 0
    for (let n of numbers)
        res += n
    return res
}
console.log(sum_numbers(1, 2, 3))

function log_numbers(x : number, y : number, z : number) {
    console.log(x, y, z)
}

let numbers: number[] = [1, 2, 3]
log_numbers(numbers[0], numbers[1], numbers[2])

let list1 : number[] = [1, 2]
let list2 : number[] = [list1[0], list1[1], 3, 4]

class Point2D {
    x: number = 0; y: number = 0
}

class Point3D {
    x: number = 0; y: number = 0; z: number = 0
    constructor(p2d: Point2D, z: number) {
        this.x = p2d.x
        this.y = p2d.y
        this.z = z
    }
}

let p3d = new Point3D({x: 1, y: 2} as Point2D, 3)
console.log(p3d.x, p3d.y, p3d.z)