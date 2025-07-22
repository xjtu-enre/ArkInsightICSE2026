interface Document {
    createElement(tagName: number): HTMLDivElement
    createElement(tagName: boolean): HTMLSpanElement
    createElement(tagName: string, value: number): HTMLCanvasElement
    createElement(tagName: string): HTMLElement
    createElement(tagName: Object): Element
}