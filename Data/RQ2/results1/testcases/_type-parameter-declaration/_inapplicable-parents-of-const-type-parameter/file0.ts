interface Foo<const T> {
    // 'const' modifier can only appear on a type parameter of a function, method or class(1277)
}

type bar<const U> = number;