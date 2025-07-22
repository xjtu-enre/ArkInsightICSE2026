function paramFunc(): void {
    /* Empty */
}

function func(a: () => void): void {
    a();
}

func(paramFunc);