let arr: number[] = [1, 2]
let one = arr[0]
let two = arr[1]

let tmp = one
one = two
two = tmp

let data: Number[] = [1, 2, 3, 4]
let head = data[0]
let tail: Number[] = []
for (let i = 1; i < data.length; ++i) {
    tail.push(data[i])
}