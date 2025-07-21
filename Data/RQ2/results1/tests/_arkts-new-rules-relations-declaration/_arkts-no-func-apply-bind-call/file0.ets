class Person {
    firstName : string

    constructor(firstName : string) {
        this.firstName = firstName
    }
    fullName() : string {
        return this.firstName
    }
}

let person = new Person("")
let person1 = new Person("Mary")

// 将打印“Mary”
console.log(person1.fullName())