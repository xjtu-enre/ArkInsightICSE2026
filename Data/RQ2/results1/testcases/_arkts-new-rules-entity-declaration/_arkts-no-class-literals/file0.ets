const Rectangle_false = class {
    constructor(height: number, width: number) {
        this.height = height
        this.width = width
    }

    height
    width
}

const rectangle_false = new Rectangle_false(0.0, 0.0)

class Rectangle {
    constructor(height: number, width: number) {
        this.height = height
        this.width = width
    }

    height: number
    width: number
}

const rectangle = new Rectangle(0.0, 0.0)