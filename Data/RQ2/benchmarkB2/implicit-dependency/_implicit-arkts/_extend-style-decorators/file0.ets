@Extend(Text) function foo(){
  .width(100)    
}
@Styles function globalFancy() {
  .width(150)
}

@Entry
@Component
struct FancyUse {
  @Styles fancy() {
    .width(200)
  }

  build() {
    Column({ space: 10 }) {
      Text('FancyA')
        .globalFancy()
      Text('FancyB')
        .fancy()
      Text('FancyC')
        .foo()
    }
  }
}