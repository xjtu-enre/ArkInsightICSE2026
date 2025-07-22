function addNum(a: number, b: number): void {
    // 使用lambda函数代替声明函数：
    let logToConsole: (message: string) => void = (message: string): void => {
        console.log(message)
    }

    let result = a + b

    logToConsole("result is " + result)
}