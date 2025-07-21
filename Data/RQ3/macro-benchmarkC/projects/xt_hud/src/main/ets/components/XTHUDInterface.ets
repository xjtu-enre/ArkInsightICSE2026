/// HUD关闭结束回调
export type XTHUDCallback = (() => void) | null

/// HUD默认配置，不支持动态响应，仅支持在组件初始化阶段设置
export interface XTHUDBaseOptions {
  /// HUD竖直方向上的显示位置，默认值DialogAlignment.Center
  alignment?: DialogAlignment
  /// HUD相对alignment所在位置的偏移量，默认值{ dx: 0, dy: 0 }
  offset?: Offset
  /// 遮罩颜色，默认值 Color.Transparent，仅isModal==true时有效
  maskColor?: ResourceColor
  /// 是否显示在子窗口，默认值 false
  showInSubWindow?: boolean
  /// 键盘避让模式，默认值 KeyboardAvoidMode.DEFAULT，beta1新增，注意 showInSubWindow=true 时，KeyboardAvoidMode.DEFAULT失效，这应该是系统特性
  keyboardAvoidMode?: KeyboardAvoidMode
  /// 开启动画，默认值为空，不设置，针对 XTPromptHUD 无效
  openAnimation?: AnimateParam
  /// 关闭动画，默认值为空，不设置，针对 XTPromptHUD 无效
  closeAnimation?: AnimateParam
  /// 过渡动画，仅针对 XTPromptHUD 生效，默认为系统默认效果，可设置 asymmetric 区分开启关闭过渡动效
  transition?: TransitionEffect | null
  /// 是否为全屏，屏蔽交互，根据HUD类型区分，toast默认false，其他默认true
  isModal?: boolean
}
/// HUD响应配置，支持后续动态更新
export interface XTHUDReactiveBaseOptions extends XTHUDBaseOptions {
  /// HUD所在UIContext，默认值根据全局配置 UIContext
  uiContext?: UIContext
  /// HUD结束回调
  onCompletion?: XTHUDCallback
  /// HUD取消回调，点击物理返回键，会触发提前关闭，该回调与onCompletion互斥，注意处理
  /// closeOnPressBack 设置为 true 才会触发回调
  onCancel?: XTHUDCallback
  /// HUD显示后，点击系统返回的回调，仅在 closeOnPressBack 为 false 时生效，为 true 会执行 onCancel
  /// !!! 注意处理这个事件，否则 closeOnPressBack 为 false 时点击系统返回无响应
  /// !!! 如果使用 XTPromptHUD.showCustomHUD 显示了全局自定义悬浮 HUD，该事件将代理全局的系统返回事件，注意影响
  onPressBack?: XTHUDCallback
  /// 是否点击系统返回键时关闭 HUD，默认 false，开启后触发返回关闭会执行 onCancel
  /// 注意处理 onPressBack 这个事件，否则 closeOnPressBack 为 false 时点击系统返回无响应
  closeOnPressBack?: boolean
  /// 是否点击 HUD 背景时关闭（isModal时生效），默认 false，开启后触发点击背景关闭会执行 onCancel
  closeOnClickOutside?: boolean
}
export interface XTHUDReactiveOptions extends XTHUDReactiveBaseOptions {
  /// 文本字体
  fontSize?: number | string | Resource
  /// 自定义字体样式
  font?: Font
  /// 自定义行高
  lineHeight?: number | string | Resource
  /// 文本颜色，默认white
  textColor?: ResourceColor
  /// 主题颜色（toast/loading图标等前景色），默认white
  tintColor?: ResourceColor
  /// HUD背景色，默认值 #CC000000
  backgroundColor?: ResourceColor
  /// HUD圆角，默认值10
  borderRadius?: Length | BorderRadiuses
  /// HUD 最小宽度约束，默认值配合 margin 和 padding 的默认值
  minWidth?: Length
  /// HUD 最大宽度约束，默认值 '60%'，一般不建议修改
  maxWidth?: Length
}
/// Toast配置
export interface XTHUDToastOptions extends XTHUDReactiveOptions {
  /// 自定义图标
  iconSrc?: PixelMap | ResourceStr | DrawableDescriptor | null
  /// 图标尺寸，默认值宽高 48vp
  iconSize?: SizeOptions
  /// 图标 margin，默认值 20vp，注意 HUD 宽度受 minWidth 约束
  iconMargin?: Margin | Length | LocalizedMargin
  /// 文本 padding，纯文本样式 top 生效，带图标样式，top 设置无效。以 iconMargin.bottom 为准
  /// 默认值 20vp，注意 HUD 宽度受 minWidth 约束
  textPadding?: Padding
  /// toast自动关闭时间间隔，默认值 2000ms
  hidingDelay?: number
  /// toast队列显示模式，一个个显示，直到结束，默认false，同时只显示一个
  /// 注意队列模式的toast不支持和其他非队列模式的toast混合使用，会被覆盖
  isQueueMode?: boolean
}

/// Loading配置
export interface XTHUDLoadingOptions extends XTHUDReactiveOptions {
  /// 自定义loading图标，建议使用svg动效
  iconSrc?: PixelMap | ResourceStr | DrawableDescriptor | null
  /// loading图标尺寸
  iconSize?: SizeOptions
  /// 图标 margin，默认值 20vp，注意 HUD 宽度受 minWidth 约束
  iconMargin?: Margin | Length | LocalizedMargin
  /// 文本 padding，top===0
  /// 默认值 20vp，注意 HUD 宽度受 minWidth 约束
  textPadding?: Padding
  /// 环形loading的环宽度，其他样式设置无效
  strokeWidth?: Length
  /// 环形loading的环背景色，其他样式设置无效，默认透明，前景色使用 tintColor 设置
  strokeBackgroundColor?: ResourceColor
}

/// Progress配置
export interface XTHUDProgressOptions extends XTHUDReactiveOptions {
  /// 进度字体
  progressFontSize?: number | string | Resource
  /// 自定义进度字体样式
  progressFont?: Font
  /// 进度文本颜色，默认white
  progressTextColor?: ResourceColor
  /// progress图标尺寸
  iconSize?: SizeOptions
  /// 图标 margin，默认值 20vp，注意 HUD 宽度受 minWidth 约束
  iconMargin?: Margin | Length | LocalizedMargin
  /// 文本 padding，top===0
  /// 默认值 20vp，注意 HUD 宽度受 minWidth 约束
  textPadding?: Padding
  /// bar和ring宽度
  strokeWidth?: Length
  /// 进度条和环的背景色，其他样式设置无效，默认透明，前景色使用 tintColor 设置
  strokeBackgroundColor?: ResourceColor
  /// 扫描动画效果
  enableScanEffect?: boolean
  /// 进度结束后自动隐藏，默认 true
  autoHideWhenProgressCompletion?: boolean
}

/// Custom配置
export interface XTHUDCustomOptions extends XTHUDReactiveBaseOptions {
  /// 是否支持多层，默认 false，支持多层时，可以同时显示多层自定义弹窗
  supportMultilayer?: boolean
}



/// toast默认值
export class XTHUDToastDefaultOptions implements XTHUDToastOptions {
  alignment: DialogAlignment = DialogAlignment.Center
  offset: Offset = { dx: 0, dy: 0 }
  maskColor: ResourceColor = $r('app.color.mask_color')
  showInSubWindow: boolean = false
  keyboardAvoidMode: KeyboardAvoidMode = KeyboardAvoidMode.DEFAULT
  openAnimation: AnimateParam = {}
  closeAnimation: AnimateParam = {}
  transition: TransitionEffect | null = null
  isModal: boolean = false

  uiContext: UIContext | undefined = undefined
  closeOnPressBack: boolean = false
  closeOnClickOutside: boolean = false
  onCompletion: XTHUDCallback = null
  onCancel: XTHUDCallback = null
  onPressBack: XTHUDCallback = null

  fontSize: number | string | Resource = $r('app.float.font_size')
  font: Font = {
    size: $r('app.float.font_size')
  }
  lineHeight: string | number | Resource = 0
  textColor: ResourceColor = $r('app.color.text_color')
  tintColor: ResourceColor = $r('app.color.tint_color')
  backgroundColor: ResourceColor = $r('app.color.background_color')
  borderRadius: Length | BorderRadiuses = $r('app.float.border_radius')
  minWidth: Length = $r('app.float.toast_min_width')
  maxWidth: Length = $r('app.string.max_width')

  iconSrc: PixelMap | ResourceStr | DrawableDescriptor | null = null
  iconSize: SizeOptions = { width: $r('app.float.icon_width'), height: $r('app.float.icon_height') }
  iconMargin: Margin | Length | LocalizedMargin = $r('app.float.gap')
  textPadding: Padding = {
    left: $r('app.float.gap'),
    right: $r('app.float.gap'),
    top: $r('app.float.gap'),
    bottom: $r('app.float.gap')
  }
  hidingDelay: number = 2500
  isQueueMode: boolean = false
}

/// loading默认值
export class XTHUDLoadingDefaultOptions implements XTHUDLoadingOptions {
  alignment: DialogAlignment = DialogAlignment.Center
  offset: Offset = { dx: 0, dy: 0 }
  maskColor: ResourceColor = $r('app.color.mask_color')
  showInSubWindow: boolean = false
  keyboardAvoidMode: KeyboardAvoidMode = KeyboardAvoidMode.DEFAULT
  openAnimation: AnimateParam = {}
  closeAnimation: AnimateParam = {}
  transition: TransitionEffect | null = null
  isModal: boolean = true

  uiContext: UIContext | undefined = undefined
  closeOnPressBack: boolean = false
  closeOnClickOutside: boolean = false
  onCompletion: XTHUDCallback = null
  onCancel: XTHUDCallback = null
  onPressBack: XTHUDCallback = null

  fontSize: number | string | Resource = $r('app.float.font_size')
  font: Font = {
    size: $r('app.float.font_size')
  }
  lineHeight: string | number | Resource = 0
  textColor: ResourceColor = $r('app.color.text_color')
  tintColor: ResourceColor = $r('app.color.tint_color')
  backgroundColor: ResourceColor = $r('app.color.background_color')
  borderRadius: Length | BorderRadiuses = $r('app.float.border_radius')
  minWidthBig: Length = $r('app.float.loading_min_width_big')
  minWidth: Length = $r('app.float.loading_min_width')
  maxWidth: Length = $r('app.string.max_width')

  iconSrc: PixelMap | ResourceStr | DrawableDescriptor | null = null
  iconSize: SizeOptions = { width: $r('app.float.icon_width_big'), height: $r('app.float.icon_height_big') }
  iconMargin: Margin | Length | LocalizedMargin = $r('app.float.gap')
  textPadding: Padding = {
    top: 0,
    left: $r('app.float.gap'),
    right: $r('app.float.gap'),
    bottom: $r('app.float.gap')
  }
  strokeWidth: Length = 5
  strokeBackgroundColor: ResourceColor = Color.Transparent
}

/// progress默认值
export class XTHUDProgressDefaultOptions implements XTHUDProgressOptions {
  alignment: DialogAlignment = DialogAlignment.Center
  offset: Offset = { dx: 0, dy: 0 }
  maskColor: ResourceColor = $r('app.color.mask_color')
  showInSubWindow: boolean = false
  keyboardAvoidMode: KeyboardAvoidMode = KeyboardAvoidMode.DEFAULT
  openAnimation: AnimateParam = {}
  closeAnimation: AnimateParam = {}
  transition: TransitionEffect | null = null
  isModal: boolean = true

  uiContext: UIContext | undefined = undefined
  closeOnPressBack: boolean = false
  closeOnClickOutside: boolean = false
  onCompletion: XTHUDCallback = null
  onCancel: XTHUDCallback = null
  onPressBack: XTHUDCallback = null

  fontSize: number | string | Resource = $r('app.float.font_size')
  font: Font = {
    size: $r('app.float.font_size')
  }
  lineHeight: string | number | Resource = 0
  textColor: ResourceColor = $r('app.color.text_color')
  tintColor: ResourceColor = $r('app.color.tint_color')
  backgroundColor: ResourceColor = $r('app.color.background_color')
  borderRadius: Length | BorderRadiuses = $r('app.float.border_radius')
  minWidthBig: Length = $r('app.float.loading_min_width_big')
  minWidth: Length = $r('app.float.loading_min_width')
  maxWidth: Length = $r('app.string.max_width')

  progressFontSize: number | string | Resource = $r('app.float.font_size_small')
  progressFont: Font = {
    size: $r('app.float.font_size_small')
  }
  progressTextColor: ResourceColor = $r('app.color.text_color')
  iconSize: SizeOptions = { width: $r('app.float.icon_width_big'), height: $r('app.float.icon_height_big') }
  iconMargin: Margin | Length | LocalizedMargin = $r('app.float.gap')
  textPadding: Padding = {
    top: 0,
    left: $r('app.float.gap'),
    right: $r('app.float.gap'),
    bottom: $r('app.float.gap')
  }
  strokeWidth: Length = 5
  strokeBackgroundColor: ResourceColor = Color.Transparent
  enableScanEffect: boolean = true
  autoHideWhenProgressCompletion: boolean = true
}



/// toast队列模式缓存
export interface XTToastQueueCached {
  text: ResourceStr
  options?: XTHUDToastOptions
}

/// Loading样式
export enum XTLoadingType {
  normal, // harmony loading
  ring, // 环形
  custom // 自定义
}

/// Progress样式
export enum XTProgressType {
  ring,
  linear
}