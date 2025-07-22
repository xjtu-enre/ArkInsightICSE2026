function drawText(text: String, location: number[], bold: boolean) {
    let x = location[0]
    let y = location[1]
    console.log(text)
    console.log(x)
    console.log(y)
    console.log(bold)
}

function main() {
    drawText("Hello, world!", [100, 50], true)
}