class A {
    foo(): void {}
    bar(): void {}
}

function getSomeObject(): A {
    return new A()
}

function main(): void {
    let tmp: Object = getSomeObject()
    let obj: A = tmp as A
    obj.foo()       // OK
    obj.bar()       // OK
//    obj.some_foo()  // 编译时错误：方法some_foo不存在于此类型上
}