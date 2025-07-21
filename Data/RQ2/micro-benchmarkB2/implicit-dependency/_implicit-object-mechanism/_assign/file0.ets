class OBJ{
    a:()=>void=()=>{}
}
function func1() {
    /* Empty */
}

function func2() {
    /* Empty */
}

const d :OBJ= {
    a: func1,
};

d.a();

d.a = func2;

d.a();
