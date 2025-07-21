abstract class Foo {
    abstract asyncMethod(): Promise<void>;

    abstract generatorMethod(): IterableIterator<void>;

    abstract asyncGeneratorMethod(): AsyncIterableIterator<void>;

    // Invalid
    // TSError: 'async' modifier cannot be used with 'abstract' modifier.
    abstract async invalidAsyncMethod(): void;

    // TSError: An overload signature cannot be declared as a generator.
    abstract* invalidGeneratorMethod(): void;

    // TSError: 'async' modifier cannot be used with 'abstract' modifier.
    abstract async* invalidAsyncGeneratorMethod(): void;
}