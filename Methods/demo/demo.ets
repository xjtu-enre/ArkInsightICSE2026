@Extend(Text)
function loadingTxt(fontSize: string | number) {
  .fontSize(fontSize)
  .fontColor("#fff")
}

@Entry({ routeName: 'rcpLoading', storage: LocalStorage.getShared() })
@Component
struct rcpLoading {
  @State rotateAngle: number = 0;

  @Builder
  lottieImg() {
    Canvas(efRcpConfig.loading.lottieRenderingCtx)
      .width('50%')
      .height(60)
      .backgroundColor(Color.Transparent)
      .onReady(() => {
        efRcpConfig.loading.lottieRenderingCtx.imageSmoothingEnabled = true;
        efRcpConfig.loading.lottieRenderingCtx.imageSmoothingQuality = 'medium'
      })
  }

  @Builder
  imgBuilder() {
    Image($r("app.media.rcpLoading"))
      .width('30')
      .animation({
        duration: 50,
        curve: Curve.Linear,
        iterations: 1,
        tempo: 100,
        playMode: PlayMode.Normal,
        onFinish: () => {
          this.rotateAngle = this.rotateAngle + 15
        }
      })
      .rotate({ angle: this.rotateAngle })
      .onAppear(() => {
        this.rotateAngle = 15
      })
  }

  @LocalStorageProp('rcpLoadingOptions') options: rcpLoadingOptions = new rcpLoadingOptions();

  build() {
    Stack() {

      if (efRcpConfig.loading.loadingBuilder) {
        efRcpConfig.loading.loadingBuilder.builder();
      } else {
        Column() {
          if (this.options.imgLayout != undefined && this.options.imgLayout === RcpImgLayout.TOP) {
            Column() {
              if (efRcpConfig.loading.enableLottie) {
                this.lottieImg()
              } else if (efRcpConfig.loading.imgBuilder) {
                efRcpConfig.loading.imgBuilder.builder();
              } else {
                this.imgBuilder();
              }
              Text(this.options.content)
                .margin({ top: UiConst.NUMBER_20 })
                .loadingTxt(this.options.fontSize ? this.options.fontSize : UiConst.FONT_16)
            }
            .width(this.options.layoutShape != undefined && this.options.layoutShape === RcpLoadingShape.RECTANGLE ?
              '100%' :
              '50%')
          }
          if (this.options.imgLayout != undefined && this.options.imgLayout === RcpImgLayout.BOTTOM) {
            Column() {
              Text(this.options.content)
                .loadingTxt(this.options.fontSize ? this.options.fontSize : UiConst.FONT_16)
                .margin({ bottom: UiConst.NUMBER_20 })
              if (efRcpConfig.loading.enableLottie) {
                this.lottieImg()
              } else if (efRcpConfig.loading.imgBuilder) {
                efRcpConfig.loading.imgBuilder.builder();
              } else {
                this.imgBuilder();
              }
            }
            .width(this.options.layoutShape != undefined && this.options.layoutShape === RcpLoadingShape.RECTANGLE ?
              '100%' :
              '50%')
          }
          if (this.options.imgLayout != undefined && this.options.imgLayout === RcpImgLayout.RIGHT) {
            Row() {
              Text(this.options.content)
                .loadingTxt(this.options.fontSize ? this.options.fontSize : UiConst.FONT_16)
              if (efRcpConfig.loading.enableLottie) {
                this.lottieImg()
              } else if (efRcpConfig.loading.imgBuilder) {
                efRcpConfig.loading.imgBuilder.builder();
              } else {
                this.imgBuilder();
              }
            }
            .width(this.options.layoutShape != undefined && this.options.layoutShape === RcpLoadingShape.RECTANGLE ?
              '100%' :
              '50%')
            .alignItems(VerticalAlign.Center)
            .justifyContent(FlexAlign.SpaceBetween)
          }
          if (this.options.imgLayout != undefined && this.options.imgLayout === RcpImgLayout.LEFT) {
            Row() {
              if (efRcpConfig.loading.enableLottie) {
                this.lottieImg()
              } else if (efRcpConfig.loading.imgBuilder) {
                efRcpConfig.loading.imgBuilder.builder();
              } else {
                this.imgBuilder();
              }
              Text(this.options.content)
                .loadingTxt(this.options.fontSize ? this.options.fontSize : UiConst.FONT_16)
                .margin({ left: UiConst.NUMBER_20 })
            }
            .width(this.options.layoutShape != undefined && this.options.layoutShape === RcpLoadingShape.RECTANGLE ?
              '100%' :
              '50%')
            .alignItems(VerticalAlign.Center)
            .justifyContent(FlexAlign.Start)
          }
        }
        .backgroundColor(this.options.winBgColor)
        .borderRadius(UiConst.NUMBER_10)
        .margin({
          top: this.options.position === Alignment.Top ? UiConst.NUMBER_40 : UiConst.NUMBER_20,
          bottom: this.options.position === Alignment.Bottom ? UiConst.NUMBER_40 : UiConst.NUMBER_20,
          left: UiConst.NUMBER_20,
          right: UiConst.NUMBER_20
        })
        .padding({
          top: UiConst.NUMBER_20,
          bottom: UiConst.NUMBER_20,
          left: UiConst.NUMBER_20,
          right: UiConst.NUMBER_20
        })
      }
    }
    .alignContent(this.options.position ? this.options.position : Alignment.Center)
    .width('100%')
    .height('100%')
  }
}

@Observed
class rcpLoadingOptions {
  @Track content: string = '';
  @Track fontSize?: string | number;
  @Track position?: Alignment;

  @Track imgLayout?: RcpImgLayout;

  @Track layoutShape?: RcpLoadingShape;

  @Track winBgColor?: string;

  constructor() {
    this.content = 'loading...';
  }
}



enum RcpLoadingShape {

  SQUARE,
  RECTANGLE
}


enum RcpImgLayout {

  TOP,

  BOTTOM,

  LEFT,

  RIGHT
}