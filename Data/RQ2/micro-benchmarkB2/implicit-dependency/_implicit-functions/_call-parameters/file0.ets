function func1() {
  /* Empty */
}

const x = (x:()=>void) => x();

x(func1);

function func2(a:(p:number)=>number) {
  a(5);
}

const y = (x:number) => x + 1;

func2(y);
func2((x:number) => x + 1);