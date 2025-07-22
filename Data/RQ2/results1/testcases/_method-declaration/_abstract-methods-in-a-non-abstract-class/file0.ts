class Foo {
    // TSError: Abstract methods can only appear within an abstract class.
    abstract foo(): void;
}