@Entry
@ComponentV2
struct Index {
  @Local value: number = 0;

  build() {
     Star({ value: this.value!! })
  }
}

@ComponentV2
struct Star {
  @Param value: number = 0;
  @Event $value: (val: number) => void = (val: number) => {};

  build() {
     Column()
  }
}