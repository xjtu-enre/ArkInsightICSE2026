import {
  XTEasyHUD,
  XTHUDToastOptions,
  XTHUDLoadingOptions,
  XTHUDProgressOptions
} from '../Index'

@Entry
@Component
struct XTEasyDemo {

  private progress: number = 0
  private interval: number | null = null

  aboutToAppear(): void {
    XTEasyHUD.globalConfigToast((options: XTHUDToastOptions) => {
      options.isQueueMode = true // 开启toast队列模式
      options.hidingDelay = 1000
      options.isModal = true
      // options.alignment = DialogAlignment.Bottom
      options.offset = { dx: 0, dy: -20}
      options.openAnimation = {
        duration: 20,
        tempo: 0 // 关闭开启动画
      }
      options.closeAnimation = {
        duration: 10,
        tempo: 0
      }
      options.closeOnClickOutside = true
      options.closeOnPressBack = true
    })
    XTEasyHUD.globalConfigLoading((options: XTHUDLoadingOptions) => {
      options.maskColor = '#33000000' // 设置蒙层颜色
      options.closeOnClickOutside = false
      options.closeOnPressBack = false
    })
    XTEasyHUD.globalConfigProgress((options: XTHUDProgressOptions) => {
      options.strokeWidth = 8
      options.closeOnClickOutside = false
      options.closeOnPressBack = false
    })
  }

  build() {
    Column({ space: 2 }) {
      Button('show toast')
        .onClick(() => {
          XTEasyHUD.showToast('toast')
        })

      Button('show toast with callback')
        .onClick(() => {
          XTEasyHUD.showToast('toast', {
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
          XTEasyHUD.showToast('toast')
          XTEasyHUD.showInfo('信息弹窗info', {
            fontSize: 22,
            textColor: Color.Yellow,
            onCompletion: () => {
              console.log('信息弹窗info 正常关闭')
            },
            onCancel: () => {
              console.log('信息弹窗info 被返回关闭')
            }
          })
          XTEasyHUD.showWarning('警告弹窗warning警告弹窗warning', {
            tintColor: Color.Orange,
            hidingDelay: 1500,
            onCompletion: () => {
              console.log('警告弹窗warning 正常关闭')
            },
            onCancel: () => {
              console.log('警告弹窗warning 被返回关闭')
            }
          })
          XTEasyHUD.showSuccess('成功弹窗\nsuccess', {
            tintColor: Color.Green,
            hidingDelay: 2000,
            onCompletion: () => {
              console.log('成功弹窗 正常关闭')
            },
            onCancel: () => {
              console.log('成功弹窗 被返回关闭')
            }
          })
          XTEasyHUD.showError('错误弹窗 错误弹窗 错误弹窗 错误弹窗', {
            tintColor: Color.Red,
            iconSize: { width: 150, height: 100 },
            onCompletion: () => {
              console.log('错误弹窗 正常关闭')
            },
            onCancel: () => {
              console.log('错误弹窗 被返回关闭')
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
          XTEasyHUD.showLoading('加载中...')
          setTimeout(() => {
            XTEasyHUD.hideLoading()
          }, 3000)
        })
      Button('show ring loading')
        .onClick(() => {
          XTEasyHUD.showRingLoading('加载中...', {
            onCompletion: () => {
              console.log('Ring loading complete')
            },
            onCancel: () => {
              console.log('Ring loading canceled')
            }
          })
          setTimeout(() => {
            XTEasyHUD.hideAllLoading()
          }, 3000)
        })
      Button('multi loading conflict flicker')
        .onClick(() => {
          XTEasyHUD.showLoading('加载中1...')
          setTimeout(() => {
            XTEasyHUD.hideLoading()
            XTEasyHUD.showLoading('加载中22...')
            setTimeout(() => {
              XTEasyHUD.hideLoading()
              XTEasyHUD.showLoading('加载中333...')
              setTimeout(() => {
                XTEasyHUD.hideLoading()
              }, 2000)
            }, 2000)
          }, 1000)
        })
      Button('multi loading smooth')
        .onClick(() => {
          XTEasyHUD.showLoading('加载中1...')
          setTimeout(() => {
            XTEasyHUD.showLoading('加载中22...', {
              fontSize: 20,
              iconSize: { width: 60, height: 60 },
              tintColor: Color.Red,
              textColor: Color.Red
            })
            setTimeout(() => {
              XTEasyHUD.showLoading('加载中333...', {
                fontSize: 24,
                iconSize: { width: 100, height: 100 },
                tintColor: Color.Yellow,
                textColor: Color.Yellow
              })
              setTimeout(() => {
                XTEasyHUD.hideAllLoading()
              }, 1000)
            }, 1000)
          }, 1000)
        })
      Button('show loading without text')
        .onClick(() => {
          XTEasyHUD.showRingLoading()
          setTimeout(() => {
            XTEasyHUD.hideLoading()
          }, 3000)
        })
      Button('show loading without background')
        .onClick(() => {
          XTEasyHUD.showLoading('', {
            backgroundColor: Color.Transparent,
            tintColor: Color.Orange,
            iconSize: { width:100, height:100 }
          })
          setTimeout(() => {
            XTEasyHUD.hideLoading()
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
            XTEasyHUD.showProgress(this.progress)
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
            XTEasyHUD.showProgress(this.progress, `大量资源下载中: ${this.progress}%`, {
              strokeWidth: 8,
              tintColor: Color.Orange,
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
            XTEasyHUD.showBarProgress(this.progress, '大量资源下载中: ', {
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
            XTEasyHUD.showBarProgress(this.progress, '', {
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