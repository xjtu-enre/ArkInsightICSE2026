const a = 2;
const b = 4;

enum Foo {
    a = 1,
    b,
}

enum Far {
    c = a | b,  // 3, but not 6, since it references Foo.a and Foo.b
    d,
}