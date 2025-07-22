function func2() {
    /* Empty */
}

class A {
    constructor() {
        this.func = this.func1;     // `this` is used, thus refer to A.func1
        this.func();               

        this.func3 = func2;         // Refers to <File file0.ets>.func2
        this.func3();
    }
    func:()=>void;
    func3:()=>void;
    func1() {
        /* Empty */
    }

    func2() {
        /* Empty */
    }
}

new A();