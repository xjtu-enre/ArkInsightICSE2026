interface Foo<T extends string> {
    prop0: T
}

type UseStringLiteral = Foo<'Bar'>;