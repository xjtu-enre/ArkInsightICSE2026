interface Foo {
    prop0: number,
}

interface Bar {
    prop1: string,
}

interface Baz extends Foo, Bar {
    /**
     * If the same name appears at the subinterface,
     * they must be identical.
     */
    prop1: string,
    prop2: Object,
}