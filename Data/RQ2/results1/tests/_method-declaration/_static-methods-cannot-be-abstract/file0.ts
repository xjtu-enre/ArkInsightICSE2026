abstract class Foo {
    // TSError: 'static' modifier cannot be used with 'abstract' modifier.
    abstract static foo(): void;

    // TSError: 'static' modifier cannot be used with 'abstract' modifier.
    static abstract bar(): void;
}