class Foo {
    field0: Foo;
}

function foo(): Foo {
    return new Foo();
}

class Bar {
    constructor(public field0: Foo): Foo {
        // TSError: Type annotation cannot appear on a constructor declaration.
    }

    get foo(): Foo {
        return this.field0
    };
}