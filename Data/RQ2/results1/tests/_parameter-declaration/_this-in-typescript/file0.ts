function foo(this: object) {
    this.a = 1
}

// Usage
const obj = new foo();
console.log(obj.a);