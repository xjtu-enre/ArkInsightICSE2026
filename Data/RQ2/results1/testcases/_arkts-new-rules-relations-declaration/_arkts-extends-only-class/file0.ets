interface Control {
    state: number
}

interface SelectableControl extends Control {
    select(): void
}