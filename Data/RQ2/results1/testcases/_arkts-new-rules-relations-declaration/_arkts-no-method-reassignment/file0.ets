class C {
    foo() {
        console.log("foo")
    }
}

class Derived extends C {
    foo() {
        console.log("Extra")
        super.foo()
    }
}

function bar() {
    console.log("bar")
}

let c1 = new C()
let c2 = new C()
c1.foo() // foo
c2.foo() // foo

let c3 = new Derived()
c3.foo() // Extra foo