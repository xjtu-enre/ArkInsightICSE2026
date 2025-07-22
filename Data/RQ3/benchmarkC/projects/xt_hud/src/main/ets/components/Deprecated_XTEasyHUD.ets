import {
  XTHUDToastOptions,
  XTHUDLoadingOptions,
  XTHUDProgressOptions
} from './XTHUDInterface'
import _EasyHUDManager from './_XTEasyHUDManager'

/// XTEasyHUD管理类
/**
 * @deprecated since 12
 * @useinstead XTPromptHUD
 */
export class XTEasyHUD {
  /**
   * Toast全局配置
   * 在执行Toast任意操作前执行，可选操作，不执行就是默认样式
   *
   * @param { globalOptions } 样式配置回调函数，XTHUDBaseOptions部分可在此设置，后续无法动态更新，其他样式可动态配置
   * @deprecated since 12
   * @useinstead XTPromptHUD.globalConfigToast()
   */
  static globalConfigToast(globalOptions?: ((options: XTHUDToastOptions) => void) | null): void {
    _EasyHUDManager.safeInitXTEasyHUDToast(globalOptions)
  }
  /**
   * Loading全局配置
   * 在执行Loading任意操作前执行，可选操作，不执行就是默认样式
   *
   * @param { globalOptions } 样式配置回调函数，XTHUDBaseOptions部分可在此设置，后续无法动态更新，其他样式可动态配置
   * @deprecated since 12
   * @useinstead XTPromptHUD.globalConfigLoading()
   */
  static globalConfigLoading(globalOptions?: ((options: XTHUDLoadingOptions) => void) | null): void {
    _EasyHUDManager.safeInitXTEasyHUDLoading(globalOptions)
  }
  /**
   * Progress全局配置
   * 在执行Progress任意操作前执行，可选操作，不执行就是默认样式
   *
   * @param { globalOptions } 样式配置回调函数，XTHUDBaseOptions部分可在此设置，后续无法动态更新，其他样式可动态配置
   * @deprecated since 12
   * @useinstead XTPromptHUD.globalConfigProgress()
   */
  static globalConfigProgress(globalOptions?: ((options: XTHUDProgressOptions) => void) | null): void {
    _EasyHUDManager.safeInitXTEasyHUDProgress(globalOptions)
  }

  /**
   * Toast，默认不屏蔽用户交互
   * 常规纯文本toast，自定义图标需要实现options.iconSrc
   *
   * @param { ResourceStr } text 显示文本，必填，为空串不显示
   * @param { XTHUDToastOptions? } options 可选自定义样式
   * @deprecated since 12
   * @useinstead XTPromptHUD.showToast()
   */
  static showToast(text: ResourceStr, options?: XTHUDToastOptions): void {
    if (!text || text === '') {
      return
    }
    // 挂载一次，避免没有挂载
    _EasyHUDManager.safeInitXTEasyHUDToast(null, (safe: boolean) => {
      if (safe) {
        _EasyHUDManager.showToast(text, options)
      }
    })
  }
  /**
   * Toast，默认不屏蔽用户交互
   * 带info图标的文本toast
   *
   * @param { ResourceStr } text 显示文本，必填，为空串不显示
   * @param { XTHUDToastOptions? } options 可选自定义样式
   * @deprecated since 12
   * @useinstead XTPromptHUD.showInfo()
   */
  static showInfo(text: ResourceStr, options?: XTHUDToastOptions): void {
    if (!text || text === '') {
      return
    }
    // 挂载一次，避免没有挂载
    _EasyHUDManager.safeInitXTEasyHUDToast(null, (safe: boolean) => {
      if (safe) {
        _EasyHUDManager.showInfo(text, options)
      }
    })
  }
  /**
   * Toast，默认不屏蔽用户交互
   * 带warning图标的文本toast
   *
   * @param { ResourceStr } text 显示文本，必填，为空串不显示
   * @param { XTHUDToastOptions? } options 可选自定义样式
   * @deprecated since 12
   * @useinstead XTPromptHUD.showWarning()
   */
  static showWarning(text: ResourceStr, options?: XTHUDToastOptions): void {
    if (!text || text === '') {
      return
    }
    // 挂载一次，避免没有挂载
    _EasyHUDManager.safeInitXTEasyHUDToast(null, (safe: boolean) => {
      if (safe) {
        _EasyHUDManager.showWarning(text, options)
      }
    })
  }
  /**
   * Toast，默认不屏蔽用户交互
   * 带success图标的文本toast
   *
   * @param { ResourceStr } text 显示文本，必填，为空串不显示
   * @param { XTHUDToastOptions? } options 可选自定义样式
   * @deprecated since 12
   * @useinstead XTPromptHUD.showSuccess()
   */
  static showSuccess(text: ResourceStr, options?: XTHUDToastOptions): void {
    if (!text || text === '') {
      return
    }
    // 挂载一次，避免没有挂载
    _EasyHUDManager.safeInitXTEasyHUDToast(null, (safe: boolean) => {
      if (safe) {
        _EasyHUDManager.showSuccess(text, options)
      }
    })
  }
  /**
   * Toast，默认不屏蔽用户交互
   * 带error图标的文本toast
   *
   * @param { ResourceStr } text 显示文本，必填，为空串不显示
   * @param { XTHUDToastOptions? } options 可选自定义样式
   * @deprecated since 12
   * @useinstead XTPromptHUD.showError()
   */
  static showError(text: ResourceStr, options?: XTHUDToastOptions): void {
    if (!text || text === '') {
      return
    }
    // 挂载一次，避免没有挂载
    _EasyHUDManager.safeInitXTEasyHUDToast(null, (safe: boolean) => {
      if (safe) {
        _EasyHUDManager.showError(text, options)
      }
    })
  }
  /**
   * 隐藏一个toast，toast默认自动隐藏，如有需求可用hide方法提前关闭
   * @deprecated since 12
   * @useinstead XTPromptHUD.hideToast()
   */
  static hideToast(): void {
    // 挂载一次，避免没有挂载
    _EasyHUDManager.safeInitXTEasyHUDToast(null, (safe: boolean) => {
      if (safe) {
        _EasyHUDManager.hideToast()
      }
    })
  }
  /**
   * 隐藏全部toast，如果同时触发多个toast，可用这个全部关闭
   * @deprecated since 12
   * @useinstead XTPromptHUD.hideAllToast()
   */
  static hideAllToast(): void {
    // 挂载一次，避免没有挂载
    _EasyHUDManager.safeInitXTEasyHUDToast(null, (safe: boolean) => {
      if (safe) {
        _EasyHUDManager.hideAllToast()
      }
    })
  }

  /**
   * Loading，默认屏蔽用户交互
   * 默认样式loading，使用了鸿蒙默认的loading样式，也就是原生LoadingProgress组件
   *
   * @param { ResourceStr? } text 显示文本，可选
   * @param { XTHUDLoadingOptions? } options 可选自定义样式
   * @deprecated since 12
   * @useinstead XTPromptHUD.showLoading()
   */
  static showLoading(text?: ResourceStr, options?: XTHUDLoadingOptions): void {
    _EasyHUDManager.safeInitXTEasyHUDLoading(null, (safe: boolean) => {
      if (safe) {
        _EasyHUDManager.showLoading(text, options)
      }
    })
  }
  /**
   * Loading，默认屏蔽用户交互
   * 圆环样式loading，使用了鸿蒙原生Progress组件的LOADING样式
   *
   * @param { ResourceStr? } text 显示文本，可选
   * @param { XTHUDLoadingOptions? } options 可选自定义样式
   * @deprecated since 12
   * @useinstead XTPromptHUD.showRingLoading()
   */
  static showRingLoading(text?: ResourceStr, options?: XTHUDLoadingOptions): void {
    _EasyHUDManager.safeInitXTEasyHUDLoading(null, (safe: boolean) => {
      if (safe) {
        _EasyHUDManager.showRingLoading(text, options)
      }
    })
  }
  /**
   * Loading，默认屏蔽用户交互
   * 自定义样式loading，建议使用svg动效图标资源，具体参考Demo
   *
   * @param { PixelMap | ResourceStr | DrawableDescriptor } iconSrc 图标资源，建议使用svg动效图标资源
   * @param { ResourceStr? } text 显示文本，可选
   * @param { XTHUDLoadingOptions? } options 可选自定义样式
   * @deprecated since 12
   * @useinstead XTPromptHUD.showCustomLoading()
   */
  static showCustomLoading(iconSrc: PixelMap | ResourceStr | DrawableDescriptor, text?: ResourceStr, options?: XTHUDLoadingOptions): void {
    _EasyHUDManager.safeInitXTEasyHUDLoading(null, (safe: boolean) => {
      if (safe) {
        _EasyHUDManager.showCustomLoading(iconSrc, text, options)
      }
    })
  }
  /**
   * 隐藏一次loading，在并发请求中，如果需要loading去屏蔽用户交互，可能会有多次触发loading的情况
   * 内部维护了一个计数器，所以重复执行show方法并不会重复创建loading组件，可以避免资源消耗和loading显示冲突问题
   * @deprecated since 12
   * @useinstead XTPromptHUD.hideLoading()
   */
  static hideLoading(): void {
    _EasyHUDManager.safeInitXTEasyHUDLoading(null, (safe: boolean) => {
      if (safe) {
        _EasyHUDManager.hideLoading()
      }
    })
  }
  /**
   * 隐藏全部loading，可以在并发请求结束后，一次执行关闭所有的loading（计数器清零）
   * @deprecated since 12
   * @useinstead XTPromptHUD.hideAllLoading()
   */
  static hideAllLoading(): void {
    _EasyHUDManager.safeInitXTEasyHUDLoading(null, (safe: boolean) => {
      if (safe) {
        _EasyHUDManager.hideAllLoading()
      }
    })
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
   * @useinstead XTPromptHUD.showProgress()
   */
  static showProgress(progress: number, text?: ResourceStr, options?: XTHUDProgressOptions): void {
    _EasyHUDManager.safeInitXTEasyHUDProgress(null, (safe: boolean) => {
      if (safe) {
        _EasyHUDManager.showProgress(progress, text, options)
      }
    })
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
   * @useinstead XTPromptHUD.showBarProgress()
   */
  static showBarProgress(progress: number, text?: ResourceStr, options?: XTHUDProgressOptions): void {
    _EasyHUDManager.safeInitXTEasyHUDProgress(null, (safe: boolean) => {
      if (safe) {
        _EasyHUDManager.showBarProgress(progress, text, options)
      }
    })
  }
  /**
   * 隐藏全部progress，progress不会同时创建多个
   * @deprecated since 12
   * @useinstead XTPromptHUD.hideProgress()
   */
  static hideProgress(): void {
    _EasyHUDManager.safeInitXTEasyHUDProgress(null, (safe: boolean) => {
      if (safe) {
        _EasyHUDManager.hideProgress()
      }
    })
  }
}