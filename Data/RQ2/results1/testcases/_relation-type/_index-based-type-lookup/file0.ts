interface Foo {
    prop0: number;
    prop1: number;
}

enum Bar {
    a,
    b,
    c,
    d,
}

class Baz {
    field0: number;

    method0(param0: string): number {
        return 0;
    }
}

let foo0: Foo['prop0'];

// Type lookup with more than one property is not extracted yet.
let foo1: Foo['prop0' | 'prop1'];

let bar: Bar.a;

let baz0: Baz['field0'];

let baz1: Baz['method0'];