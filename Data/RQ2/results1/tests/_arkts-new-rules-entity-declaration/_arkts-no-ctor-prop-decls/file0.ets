class Person {
    protected ssn: string
    private firstName: string
    private lastName: string

    constructor(ssn: string, firstName: string, lastName: string) {
        this.ssn = ssn
        this.firstName = firstName
        this.lastName = lastName
    }

    getFullName(): string {
        return this.firstName + " " + this.lastName
    }
}