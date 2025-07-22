function func1() {
  /* Empty */
}

function func2() {
  /* Empty */
}

function foo(key:number) {
  arr[key]();
}

const arr = [func1, func2];

foo(1);