import _HUDManager from './_XTHUDManager'

import {
  XTHUDCallback,
  XTHUDToastOptions,
  XTHUDLoadingOptions,
  XTHUDProgressOptions,
  XTHUDToastDefaultOptions,
  XTHUDLoadingDefaultOptions,
  XTHUDProgressDefaultOptions,
  XTToastQueueCached,
  XTLoadingType,
  XTProgressType
} from './XTHUDInterface'

/// Toast默认样式
const defaultToastOptions = new XTHUDToastDefaultOptions()
/// loading默认样式
const defaultLoadingOptions = new XTHUDLoadingDefaultOptions()
/// progress默认样式
const defaultProgressOptions = new XTHUDProgressDefaultOptions()

/// Toast
/// ----------------------------------------------------------------
/// ----------------------------------------------------------------
/// ----------------------------------------------------------------
/// ----------------------------------------------------------------
/// ----------------------------------------------------------------
// https://docs.openharmony.cn/pages/v4.1/zh-cn/application-dev/ui/arkts-common-components-custom-dialog.md
// @CustomDialog装饰器用于装饰自定义弹框，此装饰器内进行自定义内容（也就是弹框内容）
@CustomDialog
struct XTToastCustomDialogView {
  // 这里可以不用初始化，但是必须声明
  // @CustomDialog component should have a property of the CustomDialogController type.
  controller: CustomDialogController
  // 显示文本，可动态响应更新
  @Prop text: ResourceStr = ''
  // 动态响应配置
  @Prop options: XTHUDToastOptions = defaultToastOptions

  build() {
    Column () {
      if (this.options?.iconSrc) {
        Image(this.options?.iconSrc)
          .objectFit(ImageFit.Contain)
          .size(this.options?.iconSize ?? defaultToastOptions.iconSize)
          .fillColor(this.options?.tintColor ?? defaultToastOptions.tintColor)
          .margin(this.options?.iconMargin ?? defaultToastOptions.iconMargin)
      }
      Text(this.text)
        .fontSize(this.options?.fontSize ?? defaultToastOptions.fontSize)
        .font(this.options?.font ?? defaultToastOptions.font)
        .lineHeight(this.options?.lineHeight ?? defaultToastOptions.lineHeight)
        .fontColor(this.options?.textColor ?? defaultToastOptions.textColor)
        .padding({
          top: this.options?.iconSrc ? 0 : this.options?.textPadding?.top ?? defaultToastOptions.textPadding.top,
          left: this.options?.textPadding?.left ?? defaultToastOptions.textPadding.left,
          right: this.options?.textPadding?.right ?? defaultToastOptions.textPadding.right,
          bottom: this.options?.textPadding?.bottom ?? defaultToastOptions.textPadding.bottom
        })
        .textAlign(TextAlign.Center)
    }
    .backgroundColor(this.options?.backgroundColor ?? defaultToastOptions.backgroundColor)
    .borderRadius(this.options?.borderRadius ?? defaultToastOptions.borderRadius)
    // .shadow(ShadowStyle.OUTER_DEFAULT_SM)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .constraintSize({
      minWidth: this.options?.minWidth ?? defaultToastOptions.minWidth,
      maxWidth: this.options?.maxWidth ?? defaultToastOptions.maxWidth
    })
  }
}

/**
 * @deprecated since 12
 * @useinstead XTPromptHUD
 */
@Component
export struct XTHUDToast {
  // 自定义全局配置项回调函数
  globalOptions?: ((options: XTHUDToastOptions) => void) | null = null

  // 当前文本，可动态更新
  @State private _currentText: ResourceStr = ''
  // 当前配置，响应式支持看options层级
  @State private _currentOptions: XTHUDToastOptions = defaultToastOptions
  /// toast缓存队列
  private _toastQueueCached: XTToastQueueCached[] = []
  /// toast显示中
  private _isToastOnShow: boolean = false
  /// 被取消
  private _isCancelled: boolean = false
  /// HUD计数器
  private _toastCount: number = 0
  /// 弹窗控制器
  private _dialogController: CustomDialogController | null = null
  /// toast视图构造器
  @Builder private toastCustomDialogView() {
    XTToastCustomDialogView({
      text: this._currentText,
      options: this._currentOptions,
    })
  }

  private showToast(
    text: ResourceStr,
    options?: XTHUDToastOptions
  ): void {
    this._showToast(text, options)
  }
  private showInfo(
    text: ResourceStr,
    options?: XTHUDToastOptions
  ): void {
    this.showIconToast(text, $r('app.media.hud_info'), options)
  }
  private showWarning(
    text: ResourceStr,
    options?: XTHUDToastOptions
  ): void {
    this.showIconToast(text, $r('app.media.hud_warning'), options)
  }
  private showSuccess(
    text: ResourceStr,
    options?: XTHUDToastOptions
  ): void {
    this.showIconToast(text, $r('app.media.hud_success'), options)
  }
  private showError(
    text: ResourceStr,
    options?: XTHUDToastOptions
  ): void {
    this.showIconToast(text, $r('app.media.hud_error'), options)
  }
  private showIconToast(
    text: ResourceStr,
    iconSrc: PixelMap | ResourceStr | DrawableDescriptor,
    options?: XTHUDToastOptions
  ): void {
    let op = options
    if (!op) {
      op = {}
    }
    // 仅设置已知的，其他值后续使用时读取默认值
    op.iconSrc = iconSrc
    this._showToast(text, op)
  }
  private _showToast(
    text: ResourceStr,
    options?: XTHUDToastOptions
  ): void {
    // 不能在此处更新text和options，要考虑队列模式的延迟更新问题
    let queueMode: boolean = options?.isQueueMode ?? this._currentOptions?.isQueueMode ?? defaultToastOptions.isQueueMode
    let delay: number = options?.hidingDelay ?? this._currentOptions?.hidingDelay ?? defaultToastOptions.hidingDelay
    // 队列模式
    if (queueMode) {
      // 正在显示，仅作队列维护
      if (this._isToastOnShow) {
        // 添加一项
        this._toastQueueCached.push({
          text,
          options
        })
        // console.log('this._toastQueueCached', JSON.stringify(this._toastQueueCached))
        return
      }

      // 显示，count+1，第二个不再创建
      this._showToastDialog(text, options)
      // 等待结束
      setTimeout(() => {
        // 结束，count-1
        this.hide()
        // 如果还有缓存
        if (this._toastQueueCached.length > 0) {
          // 弹出第一项
          let firstCached = this._toastQueueCached.shift()
          // console.log('this._toastQueueCached2', JSON.stringify(this._toastQueueCached))
          // console.log('firstCached', JSON.stringify(firstCached))
          if (firstCached) {
            // 递归显示
            this._showToast(
              firstCached.text,
              firstCached.options
            )
          }
        }
      }, delay)
    } else {
      // console.log('toast not queue mode')
      // toast模式，仅可显示最后一个
      this._showToastDialog(text, options)
      setTimeout(() => {
        this.hide()
      }, delay)
    }
  }
  private _showToastDialog(
    text: ResourceStr,
    options?: XTHUDToastOptions
  ): void {
    // 标记显示
    this._isToastOnShow = true
    this._isCancelled = false
    // 更新文本
    this._currentText = text
    // 更新设置
    this._currentOptions = options ?? defaultToastOptions

    // hud计数器
    this._toastCount ++
    // console.log('this._toastCount++', this._toastCount)
    // 避免重复创建
    if (this._toastCount > 1) {
      return
    }
    // 打开
    this._dialogController?.open()
  }

  private hide(): void {
    // 标记显示结束
    this._isToastOnShow = false
    // 多次展示，仅作计数变更
    if (this._toastCount > 1) {
      this._toastCount --
      // console.log('this._toastCount--', this._toastCount)
      // 没被取消，才执行结束
      if (!this._isCancelled && this._currentOptions?.onCompletion) {
        this._currentOptions?.onCompletion()
      }
      return
    }
    if (this._toastCount === 1) {
      this._toastCount = 0
      // console.log('this._toastCount-0-', this._toastCount)
      this._dialogController?.close()
      // 没被取消，才执行结束
      if (!this._isCancelled && this._currentOptions?.onCompletion) {
        this._currentOptions?.onCompletion()
      }
    }
  }
  private hideAll(): void {
    this._toastCount = 1
    this.hide()
  }

  // 组件挂载
  aboutToAppear() {
    // 更新默认值设置
    if (this.globalOptions) {
      this.globalOptions(defaultToastOptions)
    }

    // 后初始化，避免options更新无效
    this._dialogController = new CustomDialogController({
      builder: () => {
        this.toastCustomDialogView()
      },
      alignment: this._currentOptions?.alignment ?? defaultToastOptions.alignment,
      // 是否可以点击背景关闭
      autoCancel: this._currentOptions?.closeOnClickOutside ?? defaultToastOptions.closeOnClickOutside,
      // 偏移量
      offset: this._currentOptions?.offset ?? defaultToastOptions.offset,
      // 自定义样式，默认就是白色圆角弹窗背景
      customStyle: true,
      maskColor: this._currentOptions?.maskColor ?? defaultToastOptions.maskColor,
      showInSubWindow: this._currentOptions?.showInSubWindow ?? defaultToastOptions.showInSubWindow,
      keyboardAvoidMode: this._currentOptions?.keyboardAvoidMode ?? defaultToastOptions.keyboardAvoidMode,
      openAnimation: this._currentOptions?.openAnimation ?? defaultToastOptions.openAnimation,
      closeAnimation: this._currentOptions?.closeAnimation ?? defaultToastOptions.closeAnimation,
      // 默认true，是否全屏展示，false只有弹窗区域UI
      isModal: this._currentOptions?.isModal ?? defaultToastOptions.isModal,
      // 物理返回出发的关闭回调，无法屏蔽
      cancel: () => {
        // console.log('返回触发关闭toast')
        this._isCancelled = true
        this._toastCount = 0
        // toast正在显示，才需要取消回调
        if (this._isToastOnShow && this._currentOptions?.onCancel) {
          this._currentOptions?.onCancel()
        }
      },
      // 将要关闭
      onWillDismiss: (dismissDialogAction: DismissDialogAction) => {
        // console.info("reason=" + JSON.stringify(dismissDialogAction.reason))
        // console.log("dialog onWillDismiss")
        let closeOnPressBack = this._currentOptions?.closeOnPressBack ?? defaultToastOptions.closeOnPressBack
        // console.log("onWillDismiss closeOnPressBack", closeOnPressBack)
        let closeOnClickOutside = this._currentOptions?.closeOnClickOutside ?? defaultToastOptions.closeOnClickOutside
        // console.log("onWillDismiss closeOnClickOutside", closeOnClickOutside)
        if (dismissDialogAction.reason === DismissReason.PRESS_BACK && closeOnPressBack) {
          dismissDialogAction.dismiss()
        } else if (dismissDialogAction.reason === DismissReason.TOUCH_OUTSIDE && closeOnClickOutside) {
          dismissDialogAction.dismiss()
        }
      }
    })

    // manager方法代理
    _HUDManager.showToast = (text: ResourceStr, options?: XTHUDToastOptions) => {
      this.showToast(text, options)
    }
    _HUDManager.showInfo = (text: ResourceStr, options?: XTHUDToastOptions) => {
      this.showInfo(text, options)
    }
    _HUDManager.showWarning = (text: ResourceStr, options?: XTHUDToastOptions) => {
      this.showWarning(text, options)
    }
    _HUDManager.showSuccess = (text: ResourceStr, options?: XTHUDToastOptions) => {
      this.showSuccess(text, options)
    }
    _HUDManager.showError = (text: ResourceStr, options?: XTHUDToastOptions) => {
      this.showError(text, options)
    }

    _HUDManager.hideToast = () => {
      this.hide()
    }
    _HUDManager.hideAllToast = () => {
      this.hideAll()
    }
  }

  build() {
  }
}





/// Loading
/// ----------------------------------------------------------------
/// ----------------------------------------------------------------
/// ----------------------------------------------------------------
/// ----------------------------------------------------------------
/// ----------------------------------------------------------------
@CustomDialog
struct XTLoadingCustomDialogView {
  // 这里可以不用初始化，但是必须声明
  // @CustomDialog component should have a property of the CustomDialogController type.
  controller: CustomDialogController
  // 显示文本，可动态响应更新
  @Prop text: ResourceStr = ''
  // 样式
  @Prop type: XTLoadingType = XTLoadingType.normal
  // 动态响应配置
  @Prop options: XTHUDLoadingOptions = defaultLoadingOptions

  build() {
    Column () {
      // 自定义
      if (this.type === XTLoadingType.custom &&
        this.options?.iconSrc) {
        Image(this.options?.iconSrc)
          .objectFit(ImageFit.Contain)
          .size(this.options?.iconSize ?? defaultLoadingOptions.iconSize)
          .fillColor(this.options?.tintColor ?? defaultLoadingOptions.tintColor)
          .margin(this.options?.iconMargin ?? defaultLoadingOptions.iconMargin)
      }
      // circle
      else if (this.type === XTLoadingType.ring) {
        Progress({
          value: 50,
          total: 100,
          type: ProgressType.Ring
        })
          .size(this.options?.iconSize ?? defaultLoadingOptions.iconSize)
          .color(this.options?.tintColor ?? defaultLoadingOptions.tintColor)
          .style({
            status: ProgressStatus.LOADING,
            strokeWidth: this.options?.strokeWidth ?? defaultLoadingOptions.strokeWidth
          })
          .margin(this.options?.iconMargin ?? defaultLoadingOptions.iconMargin)
      }
      else {
        LoadingProgress()
          .color(this.options?.tintColor ?? defaultLoadingOptions.tintColor)
          .size(this.options?.iconSize ?? defaultLoadingOptions.iconSize)
          .margin(this.options?.iconMargin ?? defaultLoadingOptions.iconMargin)
      }
      if (this.text && this.text !== '') {
        Text(this.text)
          .fontSize(this.options?.fontSize ?? defaultLoadingOptions.fontSize)
          .font(this.options?.font ?? defaultLoadingOptions.font)
          .lineHeight(this.options?.lineHeight ?? defaultLoadingOptions.lineHeight)
          .fontColor(this.options?.textColor ?? defaultLoadingOptions.textColor)
          .padding(this.options?.textPadding ?? defaultLoadingOptions.textPadding)
          .textAlign(TextAlign.Center)
      }
    }
    .backgroundColor(this.options?.backgroundColor ?? defaultLoadingOptions.backgroundColor)
    .borderRadius(this.options?.borderRadius ?? defaultLoadingOptions.borderRadius)
    // .shadow(ShadowStyle.OUTER_DEFAULT_SM)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .constraintSize({
      minWidth: this.options?.minWidth ?? (this.text && this.text !== '' ? defaultLoadingOptions.minWidthBig : defaultLoadingOptions.minWidth),
      maxWidth: this.options?.maxWidth ?? defaultLoadingOptions.maxWidth
    })
  }
}

/**
 * @deprecated since 12
 * @useinstead XTPromptHUD
 */
@Component
export struct XTHUDLoading {
  // 自定义全局配置项回调函数
  globalOptions?: ((options: XTHUDLoadingOptions) => void) | null = null

  // 当前文本，可动态更新
  @State private _currentText: ResourceStr = ''
  // 当前配置，响应式支持看options层级
  @State private _currentOptions: XTHUDLoadingOptions = defaultLoadingOptions
  // 当前样式
  @State private _currentType: XTLoadingType = XTLoadingType.normal
  /// loading显示中
  private _isLoadingOnShow: boolean = false
  /// 被取消
  private _isCancelled: boolean = false
  /// HUD计数器
  private _loadingCount: number = 0
  /// 弹窗控制器
  private _dialogController: CustomDialogController | null = null
  /// loading视图构造器
  @Builder private loadingCustomDialogView() {
    XTLoadingCustomDialogView({
      text: this._currentText,
      type: this._currentType,
      options: this._currentOptions,
    })
  }

  private showLoading(
    text?: ResourceStr,
    options?: XTHUDLoadingOptions
  ): void {
    this._showLoading(XTLoadingType.normal, text, options)
  }
  private showRingLoading(
    text?: ResourceStr,
    options?: XTHUDLoadingOptions
  ): void {
    this._showLoading(XTLoadingType.ring, text, options)
  }
  private showCustomLoading(
    iconSrc: PixelMap | ResourceStr | DrawableDescriptor,
    text?: ResourceStr,
    options?: XTHUDLoadingOptions
  ): void {
    let op = options
    if (!op) {
      op = {}
    }
    // 仅设置已知的，其他值后续使用时读取默认值
    op.iconSrc = iconSrc
    this._showLoading(XTLoadingType.custom, text, op)
  }
  private _showLoading(
    type: XTLoadingType,
    text?: ResourceStr,
    options?: XTHUDLoadingOptions
  ): void {
    // 标记显示
    this._isLoadingOnShow = true
    this._isCancelled = false
    // 更新文本
    this._currentText = text ?? ''
    // 更新设置
    this._currentOptions = options ?? defaultLoadingOptions
    this._currentType = type

    // hud计数器
    this._loadingCount ++
    // console.log('this._loadingCount++', this._loadingCount)
    // 避免重复创建
    if (this._loadingCount > 1) {
      return
    }
    // 打开
    this._dialogController?.open()
  }

  private hide(): void {
    // 标记显示结束
    this._isLoadingOnShow = false
    // 多次展示，仅作计数变更
    if (this._loadingCount > 1) {
      this._loadingCount --
      // console.log('this._loadingCount--', this._loadingCount)
      // 没被取消，才执行结束
      if (!this._isCancelled && this._currentOptions?.onCompletion) {
        this._currentOptions?.onCompletion()
      }
      return
    }
    if (this._loadingCount === 1) {
      this._loadingCount = 0
      // console.log('this._loadingCount-0-', this._loadingCount)
      this._dialogController?.close()
      // 没被取消，才执行结束
      if (!this._isCancelled && this._currentOptions?.onCompletion) {
        this._currentOptions?.onCompletion()
      }
    }
  }
  private hideAll(): void {
    this._loadingCount = 1
    this.hide()
  }

  // 组件挂载
  aboutToAppear() {
    // 更新默认值设置
    if (this.globalOptions) {
      this.globalOptions(defaultLoadingOptions)
    }

    // 后初始化，避免options更新无效
    this._dialogController = new CustomDialogController({
      builder: () => {
        this.loadingCustomDialogView()
      },
      alignment: this._currentOptions?.alignment ?? defaultLoadingOptions.alignment,
      // 是否可以点击背景关闭
      autoCancel: this._currentOptions?.closeOnClickOutside ?? defaultLoadingOptions.closeOnClickOutside,
      // 偏移量
      offset: this._currentOptions?.offset ?? defaultLoadingOptions.offset,
      // 自定义样式，默认就是白色圆角弹窗背景
      customStyle: true,
      maskColor: this._currentOptions?.maskColor ?? defaultLoadingOptions.maskColor,
      showInSubWindow: this._currentOptions?.showInSubWindow ?? defaultLoadingOptions.showInSubWindow,
      keyboardAvoidMode: this._currentOptions?.keyboardAvoidMode ?? defaultLoadingOptions.keyboardAvoidMode,
      openAnimation: this._currentOptions?.openAnimation ?? defaultLoadingOptions.openAnimation,
      closeAnimation: this._currentOptions?.closeAnimation ?? defaultLoadingOptions.closeAnimation,
      // 默认true，是否全屏展示，false只有弹窗区域UI
      isModal: this._currentOptions?.isModal ?? defaultLoadingOptions.isModal,
      // 物理返回出发的关闭回调，无法屏蔽
      cancel: () => {
        // console.log('返回触发关闭loading')
        this._isCancelled = true
        this._loadingCount = 0
        // loading正在显示，才需要取消回调
        if (this._isLoadingOnShow && this._currentOptions?.onCancel) {
          this._currentOptions?.onCancel()
        }
      },
      // 将要关闭
      onWillDismiss: (dismissDialogAction: DismissDialogAction) => {
        // console.info("reason=" + JSON.stringify(dismissDialogAction.reason))
        // console.log("dialog onWillDismiss")
        let closeOnPressBack = this._currentOptions?.closeOnPressBack ?? defaultLoadingOptions.closeOnPressBack
        // console.log("onWillDismiss closeOnPressBack", closeOnPressBack)
        let closeOnClickOutside = this._currentOptions?.closeOnClickOutside ?? defaultLoadingOptions.closeOnClickOutside
        // console.log("onWillDismiss closeOnClickOutside", closeOnClickOutside)
        if (dismissDialogAction.reason === DismissReason.PRESS_BACK && closeOnPressBack) {
          dismissDialogAction.dismiss()
        } else if (dismissDialogAction.reason === DismissReason.TOUCH_OUTSIDE && closeOnClickOutside) {
          dismissDialogAction.dismiss()
        }
      }
    })

    // manager方法代理
    _HUDManager.showLoading = (text?: ResourceStr, options?: XTHUDLoadingOptions) => {
      this.showLoading(text, options)
    }
    _HUDManager.showRingLoading = (text?: ResourceStr, options?: XTHUDLoadingOptions) => {
      this.showRingLoading(text, options)
    }
    _HUDManager.showCustomLoading = (iconSrc: PixelMap | ResourceStr | DrawableDescriptor, text?: ResourceStr, options?: XTHUDLoadingOptions) => {
      this.showCustomLoading(iconSrc, text, options)
    }
    _HUDManager.hideLoading = () => {
      this.hide()
    }
    _HUDManager.hideAllLoading = () => {
      this.hideAll()
    }
  }

  build() {
  }
}





/// Progress
/// ----------------------------------------------------------------
/// ----------------------------------------------------------------
/// ----------------------------------------------------------------
/// ----------------------------------------------------------------
/// ----------------------------------------------------------------
@CustomDialog
struct XTProgressCustomDialogView {
  // 这里可以不用初始化，但是必须声明
  // @CustomDialog component should have a property of the CustomDialogController type.
  controller: CustomDialogController
  // 样式
  @Prop type: XTProgressType = XTProgressType.linear
  // 进度百分数
  @Prop progress: number = 0
  // 显示文本，可动态响应更新
  @Prop text: ResourceStr = ''
  // 动态响应配置
  @Prop options: XTHUDProgressOptions = defaultProgressOptions

  build() {
    Column () {
      // 条形
      if (this.type === XTProgressType.linear) {
        Progress({
          value: this.progress,
          total: 100,
          type: ProgressType.Linear
        })
          .width(this.options?.iconSize?.width ?? defaultProgressOptions.iconSize.width)
          .height(this.options?.strokeWidth ?? defaultProgressOptions.strokeWidth)
          .color(this.options?.tintColor ?? defaultProgressOptions.tintColor)
          .style({
            strokeWidth: this.options?.strokeWidth ?? defaultProgressOptions.strokeWidth,
            enableScanEffect: this.options?.enableScanEffect ?? defaultProgressOptions.enableScanEffect
          })
          .margin(this.options?.iconMargin ?? defaultProgressOptions.iconMargin)
        Row() {
          if (this.text && this.text !== '') {
            Text(this.text)
              .fontSize(this.options?.fontSize ?? defaultProgressOptions.fontSize)
              .font(this.options?.font ?? defaultProgressOptions.font)
              .lineHeight(this.options?.lineHeight ?? defaultProgressOptions.lineHeight)
              .fontColor(this.options?.textColor ?? defaultProgressOptions.textColor)
              .textAlign(TextAlign.Center)
          }
          Text(`${this.progress}%`)
            .fontSize(this.options?.progressFontSize ?? defaultProgressOptions.progressFontSize)
            .font(this.options?.progressFont ?? defaultProgressOptions.progressFont)
            .fontColor(this.options?.progressTextColor ?? defaultProgressOptions.progressTextColor)
            .textAlign(TextAlign.Center)
        }
        .alignItems(VerticalAlign.Center)
        .padding(this.options?.textPadding ?? defaultProgressOptions.textPadding)
      }
      // 其他形状
      else {
        Stack({
          alignContent: Alignment.Center
        }) {
          Progress({
            value: this.progress,
            total: 100,
            type: ProgressType.Ring
          })
            .width('100%')
            .height('100%')
            .color(this.options?.tintColor ?? defaultProgressOptions.tintColor)
            .style({
              status: ProgressStatus.PROGRESSING,
              strokeWidth: this.options?.strokeWidth ?? defaultProgressOptions.strokeWidth,
              enableScanEffect: this.options?.enableScanEffect ?? defaultProgressOptions.enableScanEffect
            })
          Text(`${this.progress}%`)
            .width('100%')
            .height('100%')
            .fontSize(this.options?.progressFontSize ?? defaultProgressOptions.progressFontSize)
            .font(this.options?.progressFont ?? defaultProgressOptions.progressFont)
            .fontColor(this.options?.progressTextColor ?? defaultProgressOptions.progressTextColor)
            .textAlign(TextAlign.Center)
        }
        .size(this.options?.iconSize ?? defaultProgressOptions.iconSize)
        .margin(this.options?.iconMargin ?? defaultProgressOptions.iconMargin)
        if (this.text && this.text !== '') {
          Text(this.text)
            .fontSize(this.options?.fontSize ?? defaultProgressOptions.fontSize)
            .font(this.options?.font ?? defaultProgressOptions.font)
            .lineHeight(this.options?.lineHeight ?? defaultProgressOptions.lineHeight)
            .fontColor(this.options?.textColor ?? defaultProgressOptions.textColor)
            .padding(this.options?.textPadding ?? defaultProgressOptions.textPadding)
            .textAlign(TextAlign.Center)
        }
      }
    }
    .backgroundColor(this.options?.backgroundColor ?? defaultProgressOptions.backgroundColor)
    .borderRadius(this.options?.borderRadius ?? defaultProgressOptions.borderRadius)
    // .shadow(ShadowStyle.OUTER_DEFAULT_SM)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .constraintSize({
      minWidth: this.options?.minWidth ?? (this.text && this.text !== '' ? defaultProgressOptions.minWidthBig : defaultProgressOptions.minWidth),
      maxWidth: this.options?.maxWidth ?? defaultProgressOptions.maxWidth
    })
  }
}

/**
 * @deprecated since 12
 * @useinstead XTPromptHUD
 */
@Component
export struct XTHUDProgress {
  // 自定义全局配置项回调函数
  globalOptions?: ((options: XTHUDProgressOptions) => void) | null = null

  // 当前文本，可动态更新
  @State private _currentText: ResourceStr = ''
  // 当前配置，响应式支持看options层级
  @State private _currentOptions: XTHUDProgressOptions = defaultProgressOptions
  // 当前样式
  @State private _currentType: XTProgressType = XTProgressType.ring
  // 进度百分数
  @State private _progress: number = 0
  /// progress显示中
  private _isProgressOnShow: boolean = false
  /// 被取消
  private _isCancelled: boolean = false
  /// HUD计数器
  private _progressCount: number = 0
  /// 弹窗控制器
  private _dialogController: CustomDialogController | null = null
  /// progress视图构造器
  @Builder private progressCustomDialogView() {
    XTProgressCustomDialogView({
      text: this._currentText,
      type: this._currentType,
      progress: this._progress,
      options: this._currentOptions,
    })
  }

  private showProgress(
    progress: number,
    text?: ResourceStr,
    options?: XTHUDProgressOptions
  ): void {
    this._showProgress(progress, XTProgressType.ring, text, options)
  }
  private showBarProgress(
    progress: number,
    text?: ResourceStr,
    options?: XTHUDProgressOptions
  ): void {
    this._showProgress(progress, XTProgressType.linear, text, options)
  }
  private _showProgress(
    progress: number,
    type: XTProgressType,
    text?: ResourceStr,
    options?: XTHUDProgressOptions
  ): void {
    // 标记显示
    this._isProgressOnShow = true
    this._isCancelled = false
    // 更新
    this._currentText = text ?? ''
    this._progress = progress
    this._currentOptions = options ?? defaultProgressOptions
    this._currentType = type
    // 结束自动关闭
    if (this._progress >= 100 && (options?.autoHideWhenProgressCompletion ?? defaultProgressOptions.autoHideWhenProgressCompletion)) {
      this.hide()
      return
    }
    // hud计数器
    this._progressCount ++
    // console.log('this._progressCount++', this._progressCount)
    // 避免重复创建
    if (this._progressCount > 1) {
      return
    }
    // 打开
    this._dialogController?.open()
  }

  private hide(): void {
    // 标记显示结束
    this._isProgressOnShow = false
    this._progressCount = 0
    // console.log('this._progressCount-0-', this._progressCount)
    this._dialogController?.close()
    // 没被取消，才执行结束
    if (!this._isCancelled && this._currentOptions?.onCompletion) {
      this._currentOptions?.onCompletion()
    }
  }

  // 组件挂载
  aboutToAppear() {
    // 更新默认值设置
    if (this.globalOptions) {
      this.globalOptions(defaultProgressOptions)
    }

    // 后初始化，避免options更新无效
    this._dialogController = new CustomDialogController({
      builder: () => {
        this.progressCustomDialogView()
      },
      alignment: this._currentOptions?.alignment ?? defaultProgressOptions.alignment,
      // 是否可以点击背景关闭
      autoCancel: this._currentOptions?.closeOnClickOutside ?? defaultProgressOptions.closeOnClickOutside,
      // 偏移量
      offset: this._currentOptions?.offset ?? defaultProgressOptions.offset,
      // 自定义样式，默认就是白色圆角弹窗背景
      customStyle: true,
      maskColor: this._currentOptions?.maskColor ?? defaultProgressOptions.maskColor,
      showInSubWindow: this._currentOptions?.showInSubWindow ?? defaultProgressOptions.showInSubWindow,
      keyboardAvoidMode: this._currentOptions?.keyboardAvoidMode ?? defaultProgressOptions.keyboardAvoidMode,
      openAnimation: this._currentOptions?.openAnimation ?? defaultProgressOptions.openAnimation,
      closeAnimation: this._currentOptions?.closeAnimation ?? defaultProgressOptions.closeAnimation,
      // 默认true，是否全屏展示，false只有弹窗区域UI
      isModal: this._currentOptions?.isModal ?? defaultProgressOptions.isModal,
      // 物理返回出发的关闭回调，无法屏蔽
      cancel: () => {
        // console.log('返回触发关闭progress')
        this._isCancelled = true
        this._progressCount = 0
        // progress正在显示，才需要取消回调
        if (this._isProgressOnShow && this._currentOptions?.onCancel) {
          this._currentOptions?.onCancel()
        }
      },
      // 将要关闭
      onWillDismiss: (dismissDialogAction: DismissDialogAction) => {
        // console.info("reason=" + JSON.stringify(dismissDialogAction.reason))
        // console.log("dialog onWillDismiss")
        let closeOnPressBack = this._currentOptions?.closeOnPressBack ?? defaultProgressOptions.closeOnPressBack
        // console.log("onWillDismiss closeOnPressBack", closeOnPressBack)
        let closeOnClickOutside = this._currentOptions?.closeOnClickOutside ?? defaultProgressOptions.closeOnClickOutside
        // console.log("onWillDismiss closeOnClickOutside", closeOnClickOutside)
        if (dismissDialogAction.reason === DismissReason.PRESS_BACK && closeOnPressBack) {
          dismissDialogAction.dismiss()
        } else if (dismissDialogAction.reason === DismissReason.TOUCH_OUTSIDE && closeOnClickOutside) {
          dismissDialogAction.dismiss()
        }
      }
    })

    // manager方法代理
    _HUDManager.showProgress = (progress: number, text?: ResourceStr,  options?: XTHUDProgressOptions) => {
      this.showProgress(progress, text, options)
    }
    _HUDManager.showBarProgress = (progress: number, text?: ResourceStr,  options?: XTHUDProgressOptions) => {
      this.showBarProgress(progress, text, options)
    }
    _HUDManager.hideProgress = () => {
      this.hide()
    }
  }

  build() {
  }
}
