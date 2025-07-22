async function complexNumberProcessing(n : number) : Promise<number> {
    //一些代码逻辑
    return n
}

async function foo() {
    for (let i = 1; i <= 5; i++) {
        console.log(await complexNumberProcessing(i))
    }
}

foo()