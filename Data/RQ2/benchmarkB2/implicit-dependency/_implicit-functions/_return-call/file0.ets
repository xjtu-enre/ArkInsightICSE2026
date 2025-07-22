function returnFunc() {
    const nestedReturnFunc = ()=>{
        /* Empty */
    }

    return nestedReturnFunc;
}

function func() {
    return returnFunc;
}

func()()();