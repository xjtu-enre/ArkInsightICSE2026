class OBJ{
    a:()=>void=()=>{}
}

function func2() {
    /* Empty */
}

function func(d:OBJ) {
    d.a = func2;
}

const d :OBJ= {
    a:()=>{},
};

func(d);
d.a();