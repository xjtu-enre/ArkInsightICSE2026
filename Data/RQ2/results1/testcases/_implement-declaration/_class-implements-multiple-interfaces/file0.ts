interface Foo {
    prop0: number;
}

interface Bar {
    prop1: string;
}

class Baz implements Foo, Bar {
    prop0: number;
    prop1: string;
}