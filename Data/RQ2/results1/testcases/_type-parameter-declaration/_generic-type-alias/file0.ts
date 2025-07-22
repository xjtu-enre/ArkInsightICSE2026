interface Foo<T> {
    prop0: T
}

type bar<T> = Foo<T> | undefined;