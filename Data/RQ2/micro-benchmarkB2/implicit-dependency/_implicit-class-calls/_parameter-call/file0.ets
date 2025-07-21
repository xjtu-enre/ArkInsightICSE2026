class MyClass {
    func3() {
        /* Empty */
    }

    func2(a:()=>void) :void{
        a();
    }

    func1(a:(s:()=>void)=>void, b:()=>void) {
        a(b);
    }
}

const a = new MyClass();
a.func1(a.func2, a.func3);