class CustomError extends Error {
    constructor(message?: string) {
        // 调用父类构造函数，继承链是静态的，且不能在运行时被改变
        super(message)
        console.log(this instanceof Error) // true
    }
}
let ce = new CustomError()