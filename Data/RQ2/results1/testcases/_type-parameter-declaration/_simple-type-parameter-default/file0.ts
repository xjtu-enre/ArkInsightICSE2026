interface Foo<T = number> {
    prop0: T;
}

// Default usage
let instance0: Foo;

// Overrides default
let instance1: Foo<string>;