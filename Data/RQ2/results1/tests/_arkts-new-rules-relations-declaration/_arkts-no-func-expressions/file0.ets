function generic_func<T extends String>(x: T): T {
    return x
}

generic_func<String>("string")