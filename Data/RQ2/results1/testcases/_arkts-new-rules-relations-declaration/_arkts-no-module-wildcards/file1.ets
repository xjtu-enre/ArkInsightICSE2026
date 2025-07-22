// 声明
declare namespace N {
    function foo(x: number): number
}

import * as m from "./file0"
console.log("N.foo called: ", N.foo(42))