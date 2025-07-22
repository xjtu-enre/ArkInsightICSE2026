let a = 1;
export default a++;
/**
 * In the self update case, the variable `a` is exported first,
 * then be incremented, so the exported value would be 1,
 * and in following places in this file, `a` becomes 2.
 */