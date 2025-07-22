let a: Set<number> = new Set([1, 2, 3])
let numbers = Array.from(a.values())
for (let n of numbers) {
    console.log(n)
}