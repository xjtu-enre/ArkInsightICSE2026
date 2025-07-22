for (let i = 0, j = 0; i < 10; ++i, j += 2) {
    console.log(i)
    console.log(j)
}

// 通过语句表示执行顺序，而非逗号运算符
let x = 0
++x
x = x++