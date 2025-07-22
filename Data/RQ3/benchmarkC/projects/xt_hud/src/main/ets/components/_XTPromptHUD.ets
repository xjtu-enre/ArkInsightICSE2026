import {
  XTHUDCallback,
  XTHUDToastOptions,
  XTHUDLoadingOptions,
  XTHUDProgressOptions,
  XTHUDCustomOptions,
  XTHUDToastDefaultOptions,
  XTHUDLoadingDefaultOptions,
  XTHUDProgressDefaultOptions,
  XTToastQueueCached,
  XTLoadingType,
  XTProgressType
} from './XTHUDInterface'

import { ComponentContent } from "@ohos.arkui.node"
import { PromptAction, promptAction } from "@kit.ArkUI"

/// Toast默认样式
const defaultToastOptions = new XTHUDToastDefaultOptions()
/// loading默认样式
const defaultLoadingOptions = new XTHUDLoadingDefaultOptions()
/// progress默认样式
const defaultProgressOptions = new XTHUDProgressDefaultOptions()

/// 组件控制基类
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/js-apis-arkui-componentcontent-V5
class XTPromptHUDBaseClass {
  /// toast显示中
  protected _isOnShow: boolean = false
  /// 被取消
  private _isCancelled: boolean = false
  /// HUD计数器
  private _HUDCount: number = 0
  /// UIContext
  // private _uiContext: UIContext
  /// 弹窗控制器
  private _dialogNode: ComponentContent<Object> | null = null
  /// PromptAction
  private _promptAction: PromptAction | null = null
  // 容器
  private dialogNodeList: Array<ComponentContent<Object>> = []
  private promptActionList: Array<PromptAction> = []

  // protected constructor(uiContext: UIContext) {
  //   this._uiContext = uiContext
  // }

  // 显示 dialog
  protected _showDialogNode<T extends Object>(
    nodeBuilder: WrappedBuilder<[
      T
    ]>,
    nodeArgs: T,
    defaultOptions: XTHUDCustomDefaultOptions | XTHUDToastDefaultOptions | XTHUDLoadingDefaultOptions | XTHUDProgressDefaultOptions,
    currentOptions?: XTHUDCustomOptions | XTHUDToastOptions | XTHUDLoadingOptions | XTHUDProgressOptions
  ): void {
    // 标记显示
    this._isOnShow = true
    this._isCancelled = false
    // hud计数器
    this._HUDCount ++

    // 是否支持多层，支持就不能 update，需要重复创建
    let supportMultilayer = typeof (defaultOptions as XTHUDCustomDefaultOptions).supportMultilayer === 'boolean' && (defaultOptions as XTHUDCustomDefaultOptions).supportMultilayer === true
    if (typeof (currentOptions as XTHUDCustomOptions).supportMultilayer === 'boolean') {
      supportMultilayer = (currentOptions as XTHUDCustomOptions).supportMultilayer === true
    }
    // 避免重复创建
    if (this._HUDCount > 1 && !supportMultilayer) {
      // 更新
      // this._promptAction?.updateCustomDialog()
      // 更新 node 参数
      this._dialogNode?.update(nodeArgs)
      return
    }
    // 补丁：解决第一次未设置 supportMultilayer 的场景，二次做了设置，此时需要添加第一层数据
    if (supportMultilayer) {
      if (this._dialogNode && this.dialogNodeList.length < this._HUDCount - 1) {
        this.dialogNodeList.push(this._dialogNode)
      }
      if (this._promptAction && this.promptActionList.length < this._HUDCount - 1) {
        this.promptActionList.push(this._promptAction)
      }
    }
    const _uiContext = currentOptions?.uiContext ?? defaultOptions.uiContext
    if (!_uiContext) {
      throw new Error("[XTPromptHUD] UIContext is undefined")
    }
    // 单次显示时，执行上下文相关配置信息，不重复更新，避免出问题
    this._promptAction = _uiContext.getPromptAction()
    this._dialogNode = new ComponentContent(
      _uiContext,
      nodeBuilder,
      nodeArgs
    )
    // 存储栈
    if (supportMultilayer) {
      this.dialogNodeList.push(this._dialogNode)
      this.promptActionList.push(this._promptAction)
    }
    // node构造参数
    const dialogOptions: promptAction.BaseDialogOptions = {
      alignment: currentOptions?.alignment ?? defaultOptions.alignment,
      // 偏移量
      offset: currentOptions?.offset ?? defaultOptions.offset,
      // 默认true，是否全屏展示，false只有弹窗区域UI
      isModal: currentOptions?.isModal ?? defaultOptions.isModal,
      // 是否可以点击背景关闭
      autoCancel: currentOptions?.closeOnClickOutside ?? defaultOptions.closeOnClickOutside,
      maskColor: currentOptions?.maskColor ?? defaultOptions.maskColor,
      showInSubWindow: currentOptions?.showInSubWindow ?? defaultOptions.showInSubWindow,
      keyboardAvoidMode: currentOptions?.keyboardAvoidMode ?? defaultOptions.keyboardAvoidMode,
      // 将要关闭
      onWillDismiss: (dismissDialogAction: DismissDialogAction) => {
        // console.info("onWillDismiss reason=" + JSON.stringify(dismissDialogAction.reason))
        let closeOnPressBack = currentOptions?.closeOnPressBack ?? defaultOptions.closeOnPressBack
        // console.log("onWillDismiss closeOnPressBack", closeOnPressBack)
        let closeOnClickOutside = currentOptions?.closeOnClickOutside ?? defaultOptions.closeOnClickOutside
        // console.log("onWillDismiss closeOnClickOutside", closeOnClickOutside)
        if (dismissDialogAction.reason === DismissReason.PRESS_BACK) {
          if (closeOnPressBack) {
            dismissDialogAction.dismiss()
            this._isCancelled = true
            this._HUDCount = 0
            // 正在显示，才需要取消回调
            let onCancel = currentOptions?.onCancel ?? defaultOptions.onCancel
            // console.log('onCancel', onCancel)
            if (this._isOnShow && onCancel) {
              onCancel()
            }
          } else {
            // 回调返回事件给用户处理
            let onPressBack = currentOptions?.onPressBack ?? defaultOptions.onPressBack
            // console.log('onPressBack', onPressBack)
            if (this._isOnShow && onPressBack) {
              onPressBack()
            }
          }
        } else if (dismissDialogAction.reason === DismissReason.TOUCH_OUTSIDE && closeOnClickOutside) {
          dismissDialogAction.dismiss()
          this._isCancelled = true
          this._HUDCount = 0
          // 正在显示，才需要取消回调
          let onCancel = currentOptions?.onCancel ?? defaultOptions.onCancel
          // console.log('onCancel2', onCancel)
          if (this._isOnShow && onCancel) {
            onCancel()
          }
        }
      }
    }
    // 自定义过渡动效
    let transition = currentOptions?.transition ?? defaultOptions.transition
    if (transition) {
      dialogOptions.transition = transition
    }
    // dialog 默认属性不做动态 update 支持，避免性能问题
    // this._promptAction?.updateCustomDialog()
    // 打开
    this._promptAction?.openCustomDialog(this._dialogNode, dialogOptions)
  }
  protected _updateDialogNode<T extends Object>(
    nodeArgs: T
  ): void {
    // 标记显示
    this._isOnShow = true
    this._isCancelled = false
    // hud计数器
    this._HUDCount ++

    if (this.dialogNodeList.length > 0) {
      const dialog = this.dialogNodeList[this.dialogNodeList.length - 1]
      dialog.update(nodeArgs)
    } else {
      // 更新 node 参数
      this._dialogNode?.update(nodeArgs)
    }
  }

  protected _hide(
    onCompletion?: XTHUDCallback
  ): void {
    // 标记显示结束
    this._isOnShow = false
    // 多次展示，仅作计数变更
    if (this._HUDCount > 1) {
      this._HUDCount --
      // console.log('this._HUDCount--', this._HUDCount)
      // 没被取消，才执行结束
      if (!this._isCancelled && onCompletion) {
        onCompletion()
      }
      return
    }
    if (this._HUDCount === 1) {
      this._HUDCount = 0
      // console.log('this._HUDCount-0-', this._HUDCount)
      // console.log('this._dialogNode', this._dialogNode)
      if (this.dialogNodeList.length > 0 && this.promptActionList.length > 0) {
        const dialog = this.dialogNodeList.pop()
        const prompt = this.promptActionList.pop()
        prompt?.closeCustomDialog(dialog)
      } else {
        this._promptAction?.closeCustomDialog(this._dialogNode)
      }
      // 没被取消，才执行结束
      if (!this._isCancelled && onCompletion) {
        onCompletion()
      }
    }
  }
  protected _hideAll(
    onCompletion?: XTHUDCallback
  ): void {
    this._HUDCount = 1
    this._hide(onCompletion)
  }
}



/// Toast
/// ----------------------------------------------------------------
/// ----------------------------------------------------------------
/// ----------------------------------------------------------------
/// ----------------------------------------------------------------
/// ----------------------------------------------------------------
/// toast Builder参数
interface XTToastBuilderParam {
  text: ResourceStr
  options: XTHUDToastOptions
}
/// toast视图构造器
@Builder
function toastViewBuilder(param: XTToastBuilderParam) {
  Column () {
    if (param.options?.iconSrc) {
      Image(param.options?.iconSrc)
        .objectFit(ImageFit.Contain)
        .size(param.options?.iconSize ?? defaultToastOptions.iconSize)
        .fillColor(param.options?.tintColor ?? defaultToastOptions.tintColor)
        .margin(param.options?.iconMargin ?? defaultToastOptions.iconMargin)
    }
    Text(param.text)
      .fontSize(param.options?.fontSize ?? defaultToastOptions.fontSize)
      .font(param.options?.font ?? defaultToastOptions.font)
      .lineHeight(param.options?.lineHeight ?? defaultToastOptions.lineHeight)
      .fontColor(param.options?.textColor ?? defaultToastOptions.textColor)
      .padding({
        top: param.options?.iconSrc ? 0 : param.options?.textPadding?.top ?? defaultToastOptions.textPadding.top,
        left: param.options?.textPadding?.left ?? defaultToastOptions.textPadding.left,
        right: param.options?.textPadding?.right ?? defaultToastOptions.textPadding.right,
        bottom: param.options?.textPadding?.bottom ?? defaultToastOptions.textPadding.bottom
      })
      .textAlign(TextAlign.Center)
  }
  .backgroundColor(param.options?.backgroundColor ?? defaultToastOptions.backgroundColor)
  .borderRadius(param.options?.borderRadius ?? defaultToastOptions.borderRadius)
  .justifyContent(FlexAlign.Center)
  .alignItems(HorizontalAlign.Center)
  .constraintSize({
    minWidth: param.options?.minWidth ?? defaultToastOptions.minWidth,
    maxWidth: param.options?.maxWidth ?? defaultToastOptions.maxWidth
  })
}

/// toast组件控制类
export class XTPromptHUDToastClass extends XTPromptHUDBaseClass {
  constructor(
    uiContext: UIContext,
    globalOptions?: ((options: XTHUDToastOptions) => void)
  ) {
    super()
    // 更新默认值设置
    if (globalOptions) {
      globalOptions(defaultToastOptions)
    }
    defaultToastOptions.uiContext = uiContext
  }

  // 当前配置，响应式支持看options层级
  private _currentOptions: XTHUDToastOptions = defaultToastOptions
  /// toast缓存队列
  private _toastQueueCached: XTToastQueueCached[] = []

  showToast(
    text: ResourceStr,
    options?: XTHUDToastOptions
  ): void {
    this._showToast(text, options)
  }
  showInfo(
    text: ResourceStr,
    options?: XTHUDToastOptions
  ): void {
    this.showIconToast(text, $r('app.media.hud_info'), options)
  }
  showWarning(
    text: ResourceStr,
    options?: XTHUDToastOptions
  ): void {
    this.showIconToast(text, $r('app.media.hud_warning'), options)
  }
  showSuccess(
    text: ResourceStr,
    options?: XTHUDToastOptions
  ): void {
    this.showIconToast(text, $r('app.media.hud_success'), options)
  }
  showError(
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
    let queueMode: boolean = options?.isQueueMode ?? defaultToastOptions.isQueueMode
    let delay: number = options?.hidingDelay ?? defaultToastOptions.hidingDelay
    // 队列模式
    if (queueMode) {
      // 正在显示，仅作队列维护
      if (this._isOnShow) {
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
    // 更新设置
    this._currentOptions = options ?? defaultToastOptions

    // 组件构造参数
    const param: XTToastBuilderParam = {
      text: text,
      options: this._currentOptions
    }
    // 调用基类
    this._showDialogNode(
      wrapBuilder(toastViewBuilder),
      param,
      defaultToastOptions,
      this._currentOptions
    )
  }

  hide(): void {
    let onCompletion = this._currentOptions?.onCompletion ?? defaultToastOptions.onCompletion
    // 基类
    this._hide(onCompletion)
  }
  hideAll(): void {
    let onCompletion = this._currentOptions?.onCompletion ?? defaultToastOptions.onCompletion
    this._hideAll(onCompletion)
  }
}





/// Loading
/// ----------------------------------------------------------------
/// ----------------------------------------------------------------
/// ----------------------------------------------------------------
/// ----------------------------------------------------------------
/// ----------------------------------------------------------------
/// loading Builder参数
interface XTLoadingBuilderParam {
  text?: ResourceStr
  options: XTHUDLoadingOptions
  type: XTLoadingType
}
/// loading视图构造器
@Builder
function loadingViewBuilder(param: XTLoadingBuilderParam) {
  Column () {
    // 自定义
    if (param.type === XTLoadingType.custom &&
      param.options?.iconSrc) {
      Image(param.options?.iconSrc)
        .objectFit(ImageFit.Contain)
        .size(param.options?.iconSize ?? defaultLoadingOptions.iconSize)
        .fillColor(param.options?.tintColor ?? defaultLoadingOptions.tintColor)
        .margin(param.options?.iconMargin ?? defaultLoadingOptions.iconMargin)
    }
    // circle
    else if (param.type === XTLoadingType.ring) {
      Progress({
        value: 50,
        total: 100,
        type: ProgressType.Ring
      })
        .size(param.options?.iconSize ?? defaultLoadingOptions.iconSize)
        .color(param.options?.tintColor ?? defaultLoadingOptions.tintColor)
        // 该组件重写了通用属性backgroundColor，直接添加在Progress组件上，生效进度条的底色
        .backgroundColor(param.options?.strokeBackgroundColor ?? defaultLoadingOptions.strokeBackgroundColor)
        .style({
          status: ProgressStatus.LOADING,
          strokeWidth: param.options?.strokeWidth ?? defaultLoadingOptions.strokeWidth
        })
        .margin(param.options?.iconMargin ?? defaultLoadingOptions.iconMargin)
    }
    else {
      LoadingProgress()
        .color(param.options?.tintColor ?? defaultLoadingOptions.tintColor)
        .size(param.options?.iconSize ?? defaultLoadingOptions.iconSize)
        .margin(param.options?.iconMargin ?? defaultLoadingOptions.iconMargin)
    }
    if (param.text && param.text !== '') {
      Text(param.text)
        .fontSize(param.options?.fontSize ?? defaultLoadingOptions.fontSize)
        .font(param.options?.font ?? defaultLoadingOptions.font)
        .lineHeight(param.options?.lineHeight ?? defaultLoadingOptions.lineHeight)
        .fontColor(param.options?.textColor ?? defaultLoadingOptions.textColor)
        .padding(param.options?.textPadding ?? defaultLoadingOptions.textPadding)
        .textAlign(TextAlign.Center)
    }
  }
  .backgroundColor(param.options?.backgroundColor ?? defaultLoadingOptions.backgroundColor)
  .borderRadius(param.options?.borderRadius ?? defaultLoadingOptions.borderRadius)
  .justifyContent(FlexAlign.Center)
  .alignItems(HorizontalAlign.Center)
  .constraintSize({
    minWidth: param.options?.minWidth ?? (param.text && param.text !== '' ? defaultLoadingOptions.minWidthBig : defaultLoadingOptions.minWidth),
    maxWidth: param.options?.maxWidth ?? defaultLoadingOptions.maxWidth
  })
}

/// loading组件控制类
export class XTPromptHUDLoadingClass extends XTPromptHUDBaseClass {
  constructor(
    uiContext: UIContext,
    globalOptions?: ((options: XTHUDLoadingOptions) => void)
  ) {
    super()
    // 更新默认值设置
    if (globalOptions) {
      globalOptions(defaultLoadingOptions)
    }
    defaultLoadingOptions.uiContext = uiContext
  }

  // 当前配置，响应式支持看options层级
  private _currentOptions: XTHUDLoadingOptions = defaultLoadingOptions

  showLoading(
    text?: ResourceStr,
    options?: XTHUDLoadingOptions
  ): void {
    this._showLoading(XTLoadingType.normal, text, options)
  }
  showRingLoading(
    text?: ResourceStr,
    options?: XTHUDLoadingOptions
  ): void {
    this._showLoading(XTLoadingType.ring, text, options)
  }
  showCustomLoading(
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
    // 更新设置
    this._currentOptions = options ?? defaultLoadingOptions

    // 组件构造参数
    const param: XTLoadingBuilderParam = {
      text: text,
      options: this._currentOptions,
      type: type
    }
    // 调用基类
    this._showDialogNode(
      wrapBuilder(loadingViewBuilder),
      param,
      defaultLoadingOptions,
      this._currentOptions
    )
  }

  hide(): void {
    let onCompletion = this._currentOptions?.onCompletion ?? defaultLoadingOptions.onCompletion
    // 基类
    this._hide(onCompletion)
  }
  hideAll(): void {
    let onCompletion = this._currentOptions?.onCompletion ?? defaultLoadingOptions.onCompletion
    this._hideAll(onCompletion)
  }
}





/// Progress
/// ----------------------------------------------------------------
/// ----------------------------------------------------------------
/// ----------------------------------------------------------------
/// ----------------------------------------------------------------
/// ----------------------------------------------------------------
/// loading Builder参数
interface XTProgressBuilderParam {
  text?: ResourceStr
  options: XTHUDProgressOptions
  type: XTProgressType
  // 进度百分数
  progress: number
}
/// loading视图构造器
@Builder
function progressViewBuilder(param: XTProgressBuilderParam) {
  Column () {
    // 条形
    if (param.type === XTProgressType.linear) {
      Progress({
        value: param.progress,
        total: 100,
        type: ProgressType.Linear
      })
        .width(param.options?.iconSize?.width ?? defaultProgressOptions.iconSize.width)
        .height(param.options?.strokeWidth ?? defaultProgressOptions.strokeWidth)
        .color(param.options?.tintColor ?? defaultProgressOptions.tintColor)
        // 该组件重写了通用属性backgroundColor，直接添加在Progress组件上，生效进度条的底色
        .backgroundColor(param.options?.strokeBackgroundColor ?? defaultProgressOptions.strokeBackgroundColor)
        .style({
          strokeWidth: param.options?.strokeWidth ?? defaultProgressOptions.strokeWidth,
          enableScanEffect: param.options?.enableScanEffect ?? defaultProgressOptions.enableScanEffect
        })
        .margin(param.options?.iconMargin ?? defaultProgressOptions.iconMargin)
      Row() {
        if (param.text && param.text !== '') {
          Text(param.text)
            .fontSize(param.options?.fontSize ?? defaultProgressOptions.fontSize)
            .font(param.options?.font ?? defaultProgressOptions.font)
            .lineHeight(param.options?.lineHeight ?? defaultProgressOptions.lineHeight)
            .fontColor(param.options?.textColor ?? defaultProgressOptions.textColor)
            .textAlign(TextAlign.Center)
        }
        Text(`${param.progress}%`)
          .fontSize(param.options?.progressFontSize ?? defaultProgressOptions.progressFontSize)
          .font(param.options?.progressFont ?? defaultProgressOptions.progressFont)
          .fontColor(param.options?.progressTextColor ?? defaultProgressOptions.progressTextColor)
          .textAlign(TextAlign.Center)
      }
      .alignItems(VerticalAlign.Center)
      .padding(param.options?.textPadding ?? defaultProgressOptions.textPadding)
    }
    // 其他形状
    else {
      Stack({
        alignContent: Alignment.Center
      }) {
        Progress({
          value: param.progress,
          total: 100,
          type: ProgressType.Ring
        })
          .width('100%')
          .height('100%')
          .color(param.options?.tintColor ?? defaultProgressOptions.tintColor)
          // 该组件重写了通用属性backgroundColor，直接添加在Progress组件上，生效进度条的底色
          .backgroundColor(param.options?.strokeBackgroundColor ?? defaultProgressOptions.strokeBackgroundColor)
          .style({
            status: ProgressStatus.PROGRESSING,
            strokeWidth: param.options?.strokeWidth ?? defaultProgressOptions.strokeWidth,
            enableScanEffect: param.options?.enableScanEffect ?? defaultProgressOptions.enableScanEffect
          })
        Text(`${param.progress}%`)
          .width('100%')
          .height('100%')
          .fontSize(param.options?.progressFontSize ?? defaultProgressOptions.progressFontSize)
          .font(param.options?.progressFont ?? defaultProgressOptions.progressFont)
          .fontColor(param.options?.progressTextColor ?? defaultProgressOptions.progressTextColor)
          .textAlign(TextAlign.Center)
      }
      .size(param.options?.iconSize ?? defaultProgressOptions.iconSize)
      .margin(param.options?.iconMargin ?? defaultProgressOptions.iconMargin)
      if (param.text && param.text !== '') {
        Text(param.text)
          .fontSize(param.options?.fontSize ?? defaultProgressOptions.fontSize)
          .font(param.options?.font ?? defaultProgressOptions.font)
          .lineHeight(param.options?.lineHeight ?? defaultProgressOptions.lineHeight)
          .fontColor(param.options?.textColor ?? defaultProgressOptions.textColor)
          .padding(param.options?.textPadding ?? defaultProgressOptions.textPadding)
          .textAlign(TextAlign.Center)
      }
    }
  }
  .backgroundColor(param.options?.backgroundColor ?? defaultProgressOptions.backgroundColor)
  .borderRadius(param.options?.borderRadius ?? defaultProgressOptions.borderRadius)
  .justifyContent(FlexAlign.Center)
  .alignItems(HorizontalAlign.Center)
  .constraintSize({
    minWidth: param.options?.minWidth ?? (param.text && param.text !== '' ? defaultProgressOptions.minWidthBig : defaultProgressOptions.minWidth),
    maxWidth: param.options?.maxWidth ?? defaultProgressOptions.maxWidth
  })
}

/// progress组件控制类
export class XTPromptHUDProgressClass extends XTPromptHUDBaseClass {
  constructor(
    uiContext: UIContext,
    globalOptions?: ((options: XTHUDProgressOptions) => void)
  ) {
    super()
    // 更新默认值设置
    if (globalOptions) {
      globalOptions(defaultProgressOptions)
    }
    defaultProgressOptions.uiContext = uiContext
  }

  // 当前配置，响应式支持看options层级
  private _currentOptions: XTHUDProgressOptions = defaultProgressOptions

  showProgress(
    progress: number,
    text?: ResourceStr,
    options?: XTHUDProgressOptions
  ): void {
    this._showProgress(progress, XTProgressType.ring, text, options)
  }
  showBarProgress(
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
    // 更新
    this._currentOptions = options ?? defaultProgressOptions
    // 结束自动关闭
    if (progress >= 100 && (options?.autoHideWhenProgressCompletion ?? defaultProgressOptions.autoHideWhenProgressCompletion)) {
      this.hide()
      return
    }

    // 组件构造参数
    const param: XTProgressBuilderParam = {
      text: text,
      options: this._currentOptions,
      type: type,
      progress: progress
    }
    // 调用基类
    this._showDialogNode(
      wrapBuilder(progressViewBuilder),
      param,
      defaultProgressOptions,
      this._currentOptions
    )
  }

  hide(): void {
    let onCompletion = this._currentOptions?.onCompletion ?? defaultProgressOptions.onCompletion
    this._hideAll(onCompletion)
  }
}





/// Any
/// ----------------------------------------------------------------
/// ----------------------------------------------------------------
/// ----------------------------------------------------------------
/// ----------------------------------------------------------------
/// ----------------------------------------------------------------
class XTHUDCustomDefaultOptions implements XTHUDCustomOptions {
  alignment: DialogAlignment = DialogAlignment.Center
  offset: Offset = { dx: 0, dy: 0 }
  maskColor: ResourceColor = $r('app.color.mask_color')
  showInSubWindow: boolean = false
  keyboardAvoidMode: KeyboardAvoidMode = KeyboardAvoidMode.DEFAULT
  transition: TransitionEffect | null = null
  isModal: boolean = true

  uiContext: UIContext | undefined = undefined
  closeOnPressBack: boolean = false
  closeOnClickOutside: boolean = false
  onCompletion: XTHUDCallback = null
  onCancel: XTHUDCallback = null
  onPressBack: XTHUDCallback = null

  supportMultilayer: boolean = false
}
const defaultCustomOptions = new XTHUDCustomDefaultOptions()

/// toast组件控制类
export class XTPromptHUDCustomClass extends XTPromptHUDBaseClass {
  constructor(
    uiContext: UIContext,
    globalOptions?: ((options: XTHUDCustomOptions) => void)
  ) {
    super()
    // 更新默认值设置
    if (globalOptions) {
      globalOptions(defaultCustomOptions)
    }
    defaultCustomOptions.uiContext = uiContext
  }
  // 当前配置，响应式支持看options层级
  private _currentOptions: XTHUDCustomOptions = defaultCustomOptions

  show<T extends Object>(
    hudNodeBuilder: WrappedBuilder<[
      T
    ]>,
    hudNodeArgs: T,
    options?: XTHUDCustomOptions
  ): void {
    // 更新设置
    this._currentOptions = options ?? defaultCustomOptions

    // 调用基类
    this._showDialogNode(
      hudNodeBuilder,
      hudNodeArgs,
      defaultCustomOptions,
      this._currentOptions
    )
  }
  update<T extends Object>(
    hudNodeArgs: T
  ): void {
    this._updateDialogNode(hudNodeArgs)
  }

  hide(): void {
    let onCompletion = this._currentOptions?.onCompletion ?? defaultCustomOptions.onCompletion
    // 基类
    this._hideAll(onCompletion)
  }
}