const {d: a = 1, b = 2, c} = {a: 11, c: 13, d: 14};
// `a`, `b`, `c` equals to 14, 2, 13 respectively
// Note that the default value of `a` is overrode

// If no default value is set, `undefined` will be returned
const {foo, bar = 1} = {bar: 11};
// `foo` equals to `undefined`

const [x = 1] = [];