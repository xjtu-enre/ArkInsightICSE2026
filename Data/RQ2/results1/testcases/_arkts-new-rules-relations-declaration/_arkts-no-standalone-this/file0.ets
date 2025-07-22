class A {
    count: number = 1
    m(i: number): void {
        this.count = i
    }
}

function main(): void {
    let a = new A()
    console.log(a.count)  // 打印"1"
    a.m(2)
    console.log(a.count)  // 打印"2"
}