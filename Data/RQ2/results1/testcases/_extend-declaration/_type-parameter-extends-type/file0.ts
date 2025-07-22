type bar = number | undefined;

interface Foo<T extends bar> {
    prop0: T
}