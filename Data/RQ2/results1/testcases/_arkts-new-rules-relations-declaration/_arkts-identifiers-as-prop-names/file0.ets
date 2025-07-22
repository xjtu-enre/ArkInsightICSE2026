class X {
    public name: number = 0
}
let x: X = {name: 1}
console.log(x.name)

let y = [1, 2, 3]
console.log(y[2])

// 在需要通过非标识符（即不同类型的key）获取数据的场景中，使用Map<Object, some_type>:
let z = new Map<Object, number>()
z.set("name", 1)
z.set(2, 2)
console.log(z.get("name"))
console.log(z.get(2))