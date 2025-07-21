class OBJ{
    a:()=>void=()=>{}
}

function func2() {
    /* Empty */
}

function func1() {
    return func2;
}

const d :OBJ = {
    a: func1(),
};

d.a();