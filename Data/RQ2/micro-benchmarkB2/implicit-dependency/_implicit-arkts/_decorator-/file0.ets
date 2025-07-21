@Component
struct MyComponent1 {
    @State myText: string = “World”;
    build() {
        Column() {
            Text(‘Hello ${this.myText}’)
            .fontSize(50)
            Divider()
            Button().onClick(() => {
                This.myText = ‘ArkUI’
            })
        }
    } 
}