interface I {
    create(s: string): I
}

function fn(i: I) {
    return i.create("hello")
}