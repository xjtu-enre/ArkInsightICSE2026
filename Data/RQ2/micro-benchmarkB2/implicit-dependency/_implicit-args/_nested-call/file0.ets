function nestedFunc(): void {
    /* Empty */
}

function paramFunc(a: () => void): void {
    a()
}

function func(a: (p:()=>void) => void): void {
    a(nestedFunc)
}

const b = paramFunc;
const c = func;
c(b);