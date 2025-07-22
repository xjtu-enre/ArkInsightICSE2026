function func3(a:()=>void) {
  a()
}

function func2(a:()=>void, b:()=>void) {
  a();
  func3(b);
}

function func1(a:()=>void, b:()=>void, c:()=>void) {
  a();
  func2(b, c);
}

func1(()=> {}, () => {}, () => {});