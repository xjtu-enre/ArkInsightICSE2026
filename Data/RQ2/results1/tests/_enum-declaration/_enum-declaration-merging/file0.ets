enum NumberWord {
    zero,
    one,
}

enum NumberWord {
    six = 6,        // This initializer is necessary

    /**
     * Since multiple declarations will be merged,
     * it is natural for an initializer to refer
     * to an enum member defined not in current body
     */
    seven = six + one,
}

enum NumberWord {
    two = 2,        // This initializer is necessary
    three,          // = 3, automatic numbering is working normally
}