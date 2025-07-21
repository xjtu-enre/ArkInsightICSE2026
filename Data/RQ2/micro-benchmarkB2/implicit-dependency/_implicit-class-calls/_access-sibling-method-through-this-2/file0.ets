class MyClass {
    func1() {
        /* Empty */
    }

    func2() {
        const a = this;
        a.func1();
    }
}

const a = new MyClass();
const b = a.func2;
b();                    // ArkRuntime Error: Cannot read property func1 of undefined (evaluating 'a.func1')