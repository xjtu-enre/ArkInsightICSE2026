class C {
    func() {
        /* Empty */
    }
}

class B {
    c:C
    constructor(c:C) {
        this.c = c;
    }

    func() {
        this.c.func();
    }
}

class A {
    c:C
    constructor() {
        this.c = new C();
    }

    func() {
        const b = new B(this.c);
        b.func();
    }
}

const a = new A();
a.func();