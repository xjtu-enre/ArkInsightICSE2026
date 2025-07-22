function paramFunc(): void {
    /* Empty */
}

function func(a: () => void): void {
    a();
}

const b = paramFunc;
func(b);