import {
  XTHUDToastOptions,
  XTHUDLoadingOptions,
  XTHUDProgressOptions
} from './XTHUDInterface'
import _HUDManager from './_XTHUDManager'

/// XTHUD管理类
/**
 * @deprecated since 12
 * @useinstead XTPromptHUD
 */
export class XTHUDManager {
  /**
   * Toast，默认不屏蔽用户交互
   * 常规纯文本toast，自定义图标需要实现options.iconSrc
   *
   * @param { ResourceStr } text 显示文本，必填，为空串不显示
   * @param { XTHUDToastOptions? } options 可选自定义样式
   * @deprecated since 12
   * @useinstead XTPromptHUD.showToast(text, options)
   */
  static showToast(text: ResourceStr, options?: XTHUDToastOptions): void {
    if (!text || text === '') {
      return
    }
    _HUDManager.showToast(text, options)
  }
  /**
   * Toast，默认不屏蔽用户交互
   * 带info图标的文本toast
   *
   * @param { ResourceStr } text 显示文本，必填，为空串不显示
   * @param { XTHUDToastOptions? } options 可选自定义样式
   * @deprecated since 12
   * @useinstead XTPromptHUD.showInfo(text, options)
   */
  static showInfo(text: ResourceStr, options?: XTHUDToastOptions): void {
    if (!text || text === '') {
      return
    }
    _HUDManager.showInfo(text, options)
  }
  /**
   * Toast，默认不屏蔽用户交互
   * 带warning图标的文本toast
   *
   * @param { ResourceStr } text 显示文本，必填，为空串不显示
   * @param { XTHUDToastOptions? } options 可选自定义样式
   * @deprecated since 12
   * @useinstead XTPromptHUD.showWarning(text, options)
   */
  static showWarning(text: ResourceStr, options?: XTHUDToastOptions): void {
    if (!text || text === '') {
      return
    }
    _HUDManager.showWarning(text, options)
  }
  /**
   * Toast，默认不屏蔽用户交互
   * 带success图标的文本toast
   *
   * @param { ResourceStr } text 显示文本，必填，为空串不显示
   * @param { XTHUDToastOptions? } options 可选自定义样式
   * @deprecated since 12
   * @useinstead XTPromptHUD.showSuccess(text, options)
   */
  static showSuccess(text: ResourceStr, options?: XTHUDToastOptions): void {
    if (!text || text === '') {
      return
    }
    _HUDManager.showSuccess(text, options)
  }
  /**
   * Toast，默认不屏蔽用户交互
   * 带error图标的文本toast
   *
   * @param { ResourceStr } text 显示文本，必填，为空串不显示
   * @param { XTHUDToastOptions? } options 可选自定义样式
   * @deprecated since 12
   * @useinstead XTPromptHUD.showError(text, options)
   */
  static showError(text: ResourceStr, options?: XTHUDToastOptions): void {
    if (!text || text === '') {
      return
    }
    _HUDManager.showError(text, options)
  }
  /**
   * 隐藏一个toast，toast默认自动隐藏，如有需求可用hide方法提前关闭
   * @deprecated since 12
   * @useinstead XTPromptHUD.hideToast()
   */
  static hideToast(): void {
    _HUDManager.hideToast()
  }
  /**
   * 隐藏全部toast，如果同时触发多个toast，可用这个全部关闭
   * @deprecated since 12
   * @useinstead XTPromptHUD.hideAllToast()
   */
  static hideAllToast(): void {
    _HUDManager.hideAllToast()
  }

  /**
   * Loading，默认屏蔽用户交互
   * 默认样式loading，使用了鸿蒙默认的loading样式，也就是原生LoadingProgress组件
   *
   * @param { ResourceStr? } text 显示文本，可选
   * @param { XTHUDLoadingOptions? } options 可选自定义样式
   * @deprecated since 12
   * @useinstead XTPromptHUD.showLoading(text, options)
   */
  static showLoading(text?: ResourceStr, options?: XTHUDLoadingOptions): void {
    _HUDManager.showLoading(text, options)
  }
  /**
   * Loading，默认屏蔽用户交互
   * 圆环样式loading，使用了鸿蒙原生Progress组件的LOADING样式
   *
   * @param { ResourceStr? } text 显示文本，可选
   * @param { XTHUDLoadingOptions? } options 可选自定义样式
   * @deprecated since 12
   * @useinstead XTPromptHUD.showRingLoading(text, options)
   */
  static showRingLoading(text?: ResourceStr, options?: XTHUDLoadingOptions): void {
    _HUDManager.showRingLoading(text, options)
  }
  /**
   * Loading，默认屏蔽用户交互
   * 自定义样式loading，建议使用svg动效图标资源，具体参考Demo
   *
   * @param { PixelMap | ResourceStr | DrawableDescriptor } iconSrc 图标资源，建议使用svg动效图标资源
   * @param { ResourceStr? } text 显示文本，可选
   * @param { XTHUDLoadingOptions? } options 可选自定义样式
   * @deprecated since 12
   * @useinstead XTPromptHUD.showCustomLoading(iconSrc, text, options)
   */
  static showCustomLoading(iconSrc: PixelMap | ResourceStr | DrawableDescriptor, text?: ResourceStr, options?: XTHUDLoadingOptions): void {
    _HUDManager.showCustomLoading(iconSrc, text, options)
  }
  /**
   * 隐藏一次loading，在并发请求中，如果需要loading去屏蔽用户交互，可能会有多次触发loading的情况
   * 内部维护了一个计数器，所以重复执行show方法并不会重复创建loading组件，可以避免资源消耗和loading显示冲突问题
   * @deprecated since 12
   * @useinstead XTPromptHUD.hideLoading()
   */
  static hideLoading(): void {
    _HUDManager.hideLoading()
  }
  /**
   * 隐藏全部loading，可以在并发请求结束后，一次执行关闭所有的loading（计数器清零）
   * @deprecated since 12
   * @useinstead XTPromptHUD.hideAllLoading()
   */
  static hideAllLoading(): void {
    _HUDManager.hideAllLoading()
  }

  /**
   * Progress，默认屏蔽用户交互
   * 圆环进度组件，使用了鸿蒙原生Progress组件的PROGRESSING样式
   * 更新进度重复调用该方法即可，不会重复创建 HUD 实例
   *
   * @param { number } progress 进度数值，百分数，20%就是写20
   * @param { ResourceStr? } text 显示文本，可选
   * @param { XTHUDProgressOptions? } options 可选自定义样式
   * @deprecated since 12
   * @useinstead XTPromptHUD.showProgress(progress, text, options)
   */
  static showProgress(progress: number, text?: ResourceStr, options?: XTHUDProgressOptions): void {
    _HUDManager.showProgress(progress, text, options)
  }
  /**
   * Progress，默认屏蔽用户交互
   * Linear进度组件，使用了鸿蒙原生Progress组件的Linear样式
   * 更新进度重复调用该方法即可，不会重复创建 HUD 实例
   *
   * @param { number } progress 进度数值，百分数，20%就是写20
   * @param { ResourceStr? } text 显示文本，可选，如果设置将和 progress 同行拼接显示
   * @param { XTHUDProgressOptions? } options 可选自定义样式
   * @deprecated since 12
   * @useinstead XTPromptHUD.showBarProgress(progress, text, options)
   */
  static showBarProgress(progress: number, text?: ResourceStr, options?: XTHUDProgressOptions): void {
    _HUDManager.showBarProgress(progress, text, options)
  }
  /**
   * 隐藏全部progress，progress不会同时创建多个
   * @deprecated since 12
   * @useinstead XTPromptHUD.hideProgress()
   */
  static hideProgress(): void {
    _HUDManager.hideProgress()
  }
}