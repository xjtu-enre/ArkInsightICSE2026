class SomeObject {
    public f: string
    constructor (s: string) {
        this.f = s
    }
}

function fn(s: string): SomeObject {
    return new SomeObject(s)
}