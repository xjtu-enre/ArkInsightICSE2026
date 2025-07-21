class MoveStatus {
    public speed : number
    constructor() {
        this.speed = 0
    }
}
interface Mover {
    getMoveStatus(): MoveStatus
}

class ShakeStatus {
    public frequency : number
    constructor() {
        this.frequency = 0
    }
}
interface Shaker {
    getShakeStatus(): ShakeStatus
}

class MoveAndShakeStatus {
    public speed : number
    public frequency : number
    constructor() {
        this.speed = 0
        this.frequency = 0
    }
}

class C implements Mover, Shaker {
    private move_status : MoveStatus
    private shake_status : ShakeStatus

    constructor() {
        this.move_status = new MoveStatus()
        this.shake_status = new ShakeStatus()
    }

    public getMoveStatus() : MoveStatus {
        return this.move_status
    }

    public getShakeStatus() : ShakeStatus {
        return this.shake_status
    }

    public getStatus(): MoveAndShakeStatus {
        return {
            speed: this.move_status.speed,
            frequency: this.shake_status.frequency
        }
    }
}