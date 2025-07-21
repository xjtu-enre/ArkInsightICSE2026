class C {
    static s: string

    static {
        C.s = "aa"
        C.s = C.s + "bb"
    }
}