class OBJ{
    a:()=>void=()=>{}
}

function func2() {
    /* Empty */
}

function func1() :OBJ{
    const d :OBJ= {a: func2}
    return d;
}

const b = func1();
b.a();