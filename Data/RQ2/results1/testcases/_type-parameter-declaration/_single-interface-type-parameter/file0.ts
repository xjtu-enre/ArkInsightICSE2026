interface Foo<T> {
    bar: T,         // The type parameter is used as type annotation
    T: string,      // `T` is a property, and just with the same identifier as the type parameter
}