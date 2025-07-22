function func3() {
    /* Empty */
}

function func2(a = func3): void {
    a()
}

function func1(a:(p:()=>void)=>void, b = func2): void {
    a(b)
}

const a = func2, b = func3;

func1(a, b)