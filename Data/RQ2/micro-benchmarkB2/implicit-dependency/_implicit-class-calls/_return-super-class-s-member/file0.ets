class A {
    func1() {
        /* Empty */
    }
}

class B extends A {
    func2() {
        return this.func1;
    }
}

const b = new B();
const fn = b.func2();
fn();