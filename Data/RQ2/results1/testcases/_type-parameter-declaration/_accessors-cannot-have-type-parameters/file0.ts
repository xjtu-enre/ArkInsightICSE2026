class Foo {
    get foo<T>() {
        // TSError: An accessor cannot have type parameters.
        return 0;
    }

    set foo<T>(val: T) {
        // TSError: An accessor cannot have type parameters.
        this.foo = val;
    }
}