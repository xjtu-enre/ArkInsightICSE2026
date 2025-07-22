class CBad<U> {
    /**
     * In this case, the extended `U` still refers to `foo.U` rather than `CBad.U`.
     * Hence this forms a circlic reference which is a syntax error.
     */
    foo<U extends U>(arg: U) { /* Empty */ }
}