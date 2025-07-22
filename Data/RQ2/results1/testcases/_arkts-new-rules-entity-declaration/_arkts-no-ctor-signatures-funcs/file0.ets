class Person {
    constructor(
        name: string,
        age: number
    ) {}
}
type PersonCtor = (n: string, a: number) => Person

function createPerson(Ctor: PersonCtor, n: string, a: number): Person {
    return Ctor(n, a)
}

let Impersonizer: PersonCtor = (n: string, a: number): Person => {
    return new Person(n, a)
}

const person = createPerson(Impersonizer, "John", 30)