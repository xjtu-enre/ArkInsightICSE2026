import {
  XTPromptHUD,
  XTHUDToastOptions,
  XTHUDLoadingOptions,
  XTHUDProgressOptions,
  XTHUDReactiveBaseOptions
} from '../Index'
import { router } from '@kit.ArkUI'


interface MyHUDParam2 {
  text: string
}
@Builder
function myHUDViewBuilder2(param: MyHUDParam2) {
  Column() {
    Text('全局悬浮 HUD')
      .fontSize(14)
      .fontColor(Color.White)
      .textAlign(TextAlign.Center)
    Button(param.text)
      .type(ButtonType.Circle)
      .buttonStyle(ButtonStyleMode.EMPHASIZED)
      .margin({top: 10})
      .width(50)
      .onClick(() => {
        console.log('自定义事件触发')
        XTPromptHUD.hideCustomHUD()
      })
  }
  .justifyContent(FlexAlign.Center)
  .alignItems(HorizontalAlign.Center)
  .width(100)
  .height(100)
  .backgroundColor('#33000000')
  .borderRadius(20)
}

@Entry
@Component
struct XTPromptDemo {

  private progress: number = 0
  private interval: number | null = null

  onBackPress () {
    router.back()
    return true
  }

  aboutToAppear () {
    // XTPromptHUD.globalConfigToast(this.getUIContext(), (options: XTHUDToastOptions) => {
    //   options.isQueueMode = true
    //   options.isModal = false
    // })

    /// 重置全局配置
    XTPromptHUD.globalDestroyCustomHUD()
    XTPromptHUD.globalConfigCustomHUD(this.getUIContext(), (options: XTHUDReactiveBaseOptions) => {
      options.isModal = false
      options.maskColor = Color.Transparent
      options.closeOnPressBack = false
      options.closeOnClickOutside = false
      options.alignment = DialogAlignment.BottomEnd
      options.offset = { dx: 0, dy: -100 }
      options.onPressBack = () => {
        console.log('悬浮按钮回调系统返回事件')
        router.back()
      }
    })

    /// 正常不建议重复执行showCustomHUD
    let param: MyHUDParam2 = {
      text: '关'
    }
    XTPromptHUD.showCustomHUD(
      wrapBuilder(myHUDViewBuilder2), param, {
        onCompletion: () => {
          console.log('悬浮按钮关闭')
        }
      }
    )
  }

  build() {
    Column({ space: 2 }) {
      Button('show prompt toast')
        .onClick(() => {
          XTPromptHUD.showToast('toast')
        })

      Button('show toast with callback and transition')
        .onClick(() => {
          XTPromptHUD.showToast('toast', {
            isModal: false,
            transition: TransitionEffect.asymmetric(
              TransitionEffect.OPACITY.animation({ duration: 500 }).combine(
                TransitionEffect.rotate({ z: 1, angle: 180 }).animation({ delay: 0, duration: 500 })),
              TransitionEffect.OPACITY.animation({ delay: 0, duration: 300 }).combine(
                TransitionEffect.rotate({ z: 1, angle: 180 }).animation({ duration: 300 }))
              // TransitionEffect.scale({ x: 10, y: 10 }),
              // TransitionEffect.IDENTITY
            ),
            onCompletion: () => {
              console.log('正常结束')
            },
            onCancel: () => {
              console.log('提前结束')
            }
          })
        })

      Button('show toast queue')
        .onClick(() => {
          XTPromptHUD.showToast('toast')
          XTPromptHUD.showInfo('信息弹窗info', {
            fontSize: 22,
            textColor: Color.Yellow,
            onCompletion: () => {
              console.log('信息弹窗info 正常关闭')
            },
            onCancel: () => {
              console.log('信息弹窗info 被cancel关闭')
            },
            onPressBack: () => {
              console.log('信息弹窗info 点击返回')
            }
          })
          XTPromptHUD.showWarning('警告弹窗warning警告弹窗warning', {
            tintColor: Color.Orange,
            iconMargin: 0,
            textPadding: {
              left: 0,
              right: 0,
              bottom: 0,
              top: 0,
            },
            hidingDelay: 1500,
            onCompletion: () => {
              console.log('警告弹窗warning 正常关闭')
            },
            onCancel: () => {
              console.log('警告弹窗warning 被cancel关闭')
            },
            onPressBack: () => {
              console.log('警告弹窗warning 点击返回')
            }
          })
          XTPromptHUD.showSuccess('成功弹窗\nsuccess', {
            tintColor: Color.Green,
            iconMargin: 40,
            textPadding: {
              left: 40,
              right: 40,
              bottom: 40,
              top: 40,
            },
            hidingDelay: 2000,
            onCompletion: () => {
              console.log('成功弹窗 正常关闭')
            },
            onCancel: () => {
              console.log('成功弹窗 被cancel关闭')
            },
            onPressBack: () => {
              console.log('成功弹窗 点击返回')
            }
          })
          XTPromptHUD.showError('错误弹窗 错误弹窗 错误弹窗 错误弹窗', {
            tintColor: Color.Red,
            iconMargin: 10,
            textPadding: {
              left: 10,
              right: 10,
              bottom: 10,
              top: 10,
            },
            maxWidth: '100%',
            iconSize: { width: 150, height: 100 },
            onCompletion: () => {
              console.log('错误弹窗 正常关闭')
            },
            onCancel: () => {
              console.log('错误弹窗 被cancel关闭')
            },
            onPressBack: () => {
              console.log('错误弹窗 点击返回')
            }
          })
        })

      Divider()
        .vertical(false)
        .width('100%')
        .color(Color.Black)
        .strokeWidth(0.5)
        .margin(5)

      Button('show loading')
        .onClick(() => {
          XTPromptHUD.showLoading('加载中...', {
            closeOnPressBack: true,
            closeOnClickOutside: true,
            onCancel: () => {
              console.log('加载中... cancelled')
            },
            onCompletion: () => {
              console.log('加载中... end')
            }
          })
          setTimeout(() => {
            XTPromptHUD.hideLoading()
          }, 3000)
        })
      Button('show ring loading')
        .onClick(() => {
          XTPromptHUD.showRingLoading('加载中...', {
            iconMargin: 40,
            textPadding: {
              left: 10,right: 10,top: -10,bottom: 40
            },
            minWidth: 200,
            onCompletion: () => {
              console.log('Ring loading complete')
            },
            onCancel: () => {
              console.log('Ring loading canceled')
            }
          })
          setTimeout(() => {
            XTPromptHUD.hideAllLoading()
          }, 3000)
        })
      Button('multi loading conflict flicker')
        .onClick(() => {
          XTPromptHUD.showLoading('加载中1...')
          setTimeout(() => {
            XTPromptHUD.hideLoading()
            XTPromptHUD.showLoading('加载中22...')
            setTimeout(() => {
              XTPromptHUD.hideLoading()
              XTPromptHUD.showLoading('加载中333...')
              setTimeout(() => {
                XTPromptHUD.hideLoading()
              }, 2000)
            }, 2000)
          }, 1000)
        })
      Button('multi loading smooth')
        .onClick(() => {
          XTPromptHUD.showLoading('加载中1...', {
            onCompletion: () => {
              console.log('加载中1... end')
            }
          })
          setTimeout(() => {
            XTPromptHUD.showLoading('加载中22...', {
              fontSize: 20,
              iconSize: { width: 60, height: 60 },
              tintColor: Color.Red,
              textColor: Color.Red,
              onCompletion: () => {
                console.log('加载中22... end')
              }
            })
            setTimeout(() => {
              XTPromptHUD.showLoading('加载中333...', {
                fontSize: 24,
                iconSize: { width: 100, height: 100 },
                tintColor: Color.Yellow,
                textColor: Color.Yellow,
                onCompletion: () => {
                  console.log('加载中333... end')
                }
              })
              setTimeout(() => {
                XTPromptHUD.hideAllLoading()
              }, 1000)
            }, 1000)
          }, 1000)
        })
      Button('show loading without text')
        .onClick(() => {
          XTPromptHUD.showRingLoading()
          setTimeout(() => {
            XTPromptHUD.hideLoading()
          }, 3000)
        })
      Button('show loading without background')
        .onClick(() => {
          XTPromptHUD.showLoading('', {
            backgroundColor: Color.Transparent,
            tintColor: Color.Orange,
            iconSize: { width:100, height:100 }
          })
          setTimeout(() => {
            XTPromptHUD.hideLoading()
          }, 3000)
        })

      Divider()
        .vertical(false)
        .width('100%')
        .color(Color.Black)
        .strokeWidth(0.5)
        .margin(5)

      Button('show progress')
        .onClick(() => {
          this.progress = 0
          this.interval = setInterval(() => {
            this.progress ++
            XTPromptHUD.showProgress(this.progress)
            if (this.progress >= 100) {
              clearInterval(this.interval)
              this.interval = null
            }
          }, 100)
        })
      Button('show progress with text')
        .onClick(() => {
          this.progress = 0
          this.interval = setInterval(() => {
            this.progress ++
            XTPromptHUD.showProgress(this.progress, `大量资源下载中: ${this.progress}%`, {
              strokeWidth: 8,
              tintColor: Color.Orange,
              iconMargin: 40,
              closeOnPressBack: false,
              closeOnClickOutside: true,
              textPadding: {
                left: 10,right: 10,top: 0,bottom: 40
              },
              minWidth: 250,
              onCompletion: () => {
                console.log('结束', this.progress)
              },
              onCancel: () => {
                console.log('取消一次', this.progress)
              }
            })
            if (this.progress >= 100) {
              clearInterval(this.interval)
              this.interval = null
            }
          }, 200)
        })
      Button('show progress bar')
        .onClick(() => {
          this.progress = 0
          this.interval = setInterval(() => {
            this.progress ++
            XTPromptHUD.showBarProgress(this.progress, '大量资源下载中: ', {
              strokeWidth: 8,
              tintColor: Color.Orange
            })
            if (this.progress >= 100) {
              clearInterval(this.interval)
              this.interval = null
            }
          }, 100)
        })
      Button('show progress bar 2')
        .onClick(() => {
          this.progress = 0
          this.interval = setInterval(() => {
            this.progress ++
            XTPromptHUD.showBarProgress(this.progress, '', {
              strokeWidth: 8,
              tintColor: Color.Orange
            })
            if (this.progress >= 100) {
              clearInterval(this.interval)
              this.interval = null
            }
          }, 100)
        })
    }
    .width('100%')
    .height('100%')
  }
}