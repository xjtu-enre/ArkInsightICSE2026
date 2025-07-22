class C {
    p: number = 0
    m() {
        console.log(this.p)
    }
    q(r: number) {
        return this.p == r
    }
}