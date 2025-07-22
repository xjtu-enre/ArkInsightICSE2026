interface Foo {
    prop0: string,
}

interface Bar {
    prop1: string,
}

interface Baz extends Foo {
    prop2: string,
}

interface Baz extends Bar {
    prop3: string,
}