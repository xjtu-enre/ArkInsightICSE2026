class MyClass {
    func(): void {
        /* Empty */
    }
}

const a = new MyClass();
a.func();

const b = a.func;
b();