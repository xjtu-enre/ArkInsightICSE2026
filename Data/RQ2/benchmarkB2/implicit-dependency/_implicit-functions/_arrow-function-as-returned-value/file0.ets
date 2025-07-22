function func() :(x:number)=>void{
  return x => x + 1;
}

const y = func();
y(5);