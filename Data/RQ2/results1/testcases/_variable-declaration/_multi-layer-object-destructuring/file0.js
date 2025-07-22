let {a, b, c: {d}} = {a: 1, b: 2, c: {d: 3}};
// `a`, `b`, `d` equals to 1, 2, 3 respectively
// Note that `c` will be neither declared nor assigned