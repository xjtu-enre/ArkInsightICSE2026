class obj{
    b:()=>void=()=>{}
}
class OBJ{
    a:obj={
        b:()=>{}
    }
}
function func1() {
    /* Empty */
}

function func2() {
    /* Empty */
}

const d :OBJ= {
    a: {
        b: func1,
    },
};

d.a.b = func2;
d.a.b();