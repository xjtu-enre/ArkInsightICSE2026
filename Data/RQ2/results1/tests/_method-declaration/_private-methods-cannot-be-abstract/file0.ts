abstract class Foo {
    // TSError: 'abstract' modifier cannot be used with a private identifier.
    abstract #foo(): void;
}