class Point {
    x: number = 0
    y: number = 0
}
let p: Point = {x: 1, y: 2}
console.log(p.x)

class Person {
    name: string
    age: number
    email: string
    phoneNumber: string

    constructor(name: string, age: number, email: string,
                phoneNumber: string) {
        this.name = name
        this.age = age
        this.email = email
        this.phoneNumber = phoneNumber
    }
}

let person = new Person("John", 30, "***@example.com", "18*********")
console.log(person["name1"])         // 编译时错误
console.log(person.unknownProperty) // 编译时错误

let arr = new Int32Array(1)
console.log(arr[0])