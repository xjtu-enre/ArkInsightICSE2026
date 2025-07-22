function func(a:() => void): void {
    a()
}

function func2(): ()=>void {
    return func3
}

function func3(): void {
    /* Empty */
}

func(func2());