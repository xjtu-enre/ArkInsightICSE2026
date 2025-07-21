import {
  XTPromptHUDToastClass,
  XTPromptHUDLoadingClass,
  XTPromptHUDProgressClass,
  XTPromptHUDCustomClass
} from './_XTPromptHUD'
import {
  XTHUDToastOptions,
  XTHUDLoadingOptions,
  XTHUDProgressOptions,
  XTHUDCustomOptions
} from './XTHUDInterface'
import { UIContext, window } from '@kit.ArkUI'

/// XTPromptHUD管理类
export class XTPromptHUD {
  // HUD 组件类
  private static _toast: XTPromptHUDToastClass | null
  private static _loading: XTPromptHUDLoadingClass | null
  private static _progress: XTPromptHUDProgressClass | null
  private static _custom: XTPromptHUDCustomClass | null

  /// toast 单例
  private static initToastInstance(
    uiContext: UIContext,
    globalOptions?: ((options: XTHUDToastOptions) => void)
  ): XTPromptHUDToastClass {
    if (!XTPromptHUD._toast) {
      XTPromptHUD._toast = new XTPromptHUDToastClass(
        uiContext,
        globalOptions
      )
    }
    return XTPromptHUD._toast
  }
  /// loading 单例
  private static initLoadingInstance(
    uiContext: UIContext,
    globalOptions?: ((options: XTHUDLoadingOptions) => void)
  ): XTPromptHUDLoadingClass {
    if (!XTPromptHUD._loading) {
      XTPromptHUD._loading = new XTPromptHUDLoadingClass(
        uiContext,
        globalOptions
      )
    }
    return XTPromptHUD._loading
  }
  /// progress 单例
  private static initProgressInstance(
    uiContext: UIContext,
    globalOptions?: ((options: XTHUDProgressOptions) => void)
  ): XTPromptHUDProgressClass {
    if (!XTPromptHUD._progress) {
      XTPromptHUD._progress = new XTPromptHUDProgressClass(
        uiContext,
        globalOptions
      )
    }
    return XTPromptHUD._progress
  }
  /// custom 单例
  private static initCustomInstance(
    uiContext: UIContext,
    globalOptions?: ((options: XTHUDCustomOptions) => void)
  ): XTPromptHUDCustomClass {
    if (!XTPromptHUD._custom) {
      XTPromptHUD._custom = new XTPromptHUDCustomClass(
        uiContext,
        globalOptions
      )
    }
    return XTPromptHUD._custom
  }

  /**
   * 异步获取 lastWindow UIContext
   * @param callback
   */
  public static asyncGetLastWindowUIContext(callback: (uiContext: UIContext | null) => void) {
    let context = getContext()
    if (context) {
      window.getLastWindow(context).then((windowClass: window.Window) => {
        let uiContext = windowClass.getUIContext()
        if (callback) {
          callback(uiContext)
        }
      }).catch(() => {
        if (callback) {
          callback(null)
        }
      })
    } else {
      if (callback) {
        callback(null)
      }
    }
  }


  /**
   * Toast 全局配置，必须在 windowStage.loadContent 后执行 UIContext 赋值
   * 其他全局样式配置为可选操作，不配置就是默认样式
   * !!! 建议使用 toast 前执行，如果不执行，将会使用默认上下文的 context 的 getLastWindow 的 UIContext
   * !!! 如果对应场景下 window 还未创建，toast 将无法显示，如果对应 UI 上下文对应的 window 不是你想要的 window，HUD 将加载在错误的位置
   * !!! 注意设置全局配置后，必须通过指定 show 事件中的 options 才可以刷新样式配置，但不会覆盖全局配置
   * !!! UIContext 也可以在后续的 show 事件中动态指定，但并不会覆盖全局配置的 UIContext
   * !!! 想要重置全局配置，需要手动执行 globalDestroyToast 后重新执行 globalConfigToast
   *
   * @param { uiContext } UIContext，必传，例如 windowStage.getMainWindowSync().getUIContext() 或者 组件内的 this.getUIContext()
   * 注意：uiContext 直接决定了 HUD 的显示位置，尤其是多 window 或者嵌套 subwindow 的复杂应用场景，注意 uiContext 更新
   * @param { globalOptions } 样式配置回调函数，XTHUDBaseOptions部分可在此设置，后续无法动态更新，其他样式可动态配置，如果 globalOptions 中再次设置 UIContext 不会生效
   */
  static globalConfigToast(
    uiContext: UIContext,
    globalOptions?: ((options: XTHUDToastOptions) => void)
  ): void {
    // 预初始化
    XTPromptHUD.initToastInstance(uiContext, globalOptions)
  }
  /**
   * 销毁全局 toast 单例，后续必须重新执行 globalConfigToast 才可以继续使用 toast
   * !!! 注意销毁执行后，对应 HUD 会全部关闭
   */
  static globalDestroyToast(): void {
    if (XTPromptHUD._toast) {
      XTPromptHUD.hideAllToast()
      XTPromptHUD._toast = null
    }
  }

  /**
   * Loading 全局配置，必须在 windowStage.loadContent 后执行 UIContext 赋值
   * 其他全局样式配置为可选操作，不配置就是默认样式
   * !!! 建议使用 loading 前执行，如果不执行，将会使用默认上下文的 context 的 getLastWindow 的 UIContext
   * !!! 如果对应场景下 window 还未创建，toast 将无法显示，如果对应 UI 上下文对应的 window 不是你想要的 window，HUD 将加载在错误的位置
   * !!! 注意设置全局配置后，必须通过指定 show 事件中的 options 才可以刷新样式配置，但不会覆盖全局配置
   * !!! UIContext 也可以在后续的 show 事件中动态指定，但并不会覆盖全局配置的 UIContext
   * !!! 想要重置全局配置，需要手动执行 globalDestroyLoading 后重新执行 globalConfigLoading
   *
   * @param { uiContext } UIContext，必传，例如 windowStage.getMainWindowSync().getUIContext() 或者 组件内的 this.getUIContext()
   * 注意：uiContext 直接决定了 HUD 的显示位置，尤其是多 window 或者嵌套 subwindow 的复杂应用场景，注意 uiContext 更新
   * @param { globalOptions } 样式配置回调函数，XTHUDBaseOptions部分可在此设置，后续无法动态更新，其他样式可动态配置，如果 globalOptions 中再次设置 UIContext 不会生效
   */
  static globalConfigLoading(
    uiContext: UIContext,
    globalOptions?: ((options: XTHUDLoadingOptions) => void)
  ): void {
    // 预初始化
    XTPromptHUD.initLoadingInstance(uiContext, globalOptions)
  }
  /**
   * 销毁全局 loading 单例，后续必须重新执行 globalConfigLoading 才可以继续使用 loading
   * !!! 注意销毁执行后，对应 HUD 会全部关闭
   */
  static globalDestroyLoading(): void {
    if (XTPromptHUD._loading) {
      XTPromptHUD.hideAllLoading()
      XTPromptHUD._loading = null
    }
  }

  /**
   * Progress 全局配置，必须在 windowStage.loadContent 后执行 UIContext 赋值
   * 其他全局样式配置为可选操作，不配置就是默认样式
   * !!! 建议使用 progress 前执行，如果不执行，将会使用默认上下文的 context 的 getLastWindow 的 UIContext
   * !!! 如果对应场景下 window 还未创建，toast 将无法显示，如果对应 UI 上下文对应的 window 不是你想要的 window，HUD 将加载在错误的位置
   * !!! 注意设置全局配置后，必须通过指定 show 事件中的 options 才可以刷新样式配置，但不会覆盖全局配置
   * !!! UIContext 也可以在后续的 show 事件中动态指定，但并不会覆盖全局配置的 UIContext
   * !!! 想要重置全局配置，需要手动执行 globalDestroyProgress 后重新执行 globalConfigProgress
   *
   * @param { uiContext } UIContext，必传，例如 windowStage.getMainWindowSync().getUIContext() 或者 组件内的 this.getUIContext()
   * 注意：uiContext 直接决定了 HUD 的显示位置，尤其是多 window 或者嵌套 subwindow 的复杂应用场景，注意 uiContext 更新
   * @param { globalOptions } 样式配置回调函数，XTHUDBaseOptions部分可在此设置，后续无法动态更新，其他样式可动态配置，如果 globalOptions 中再次设置 UIContext 不会生效
   */
  static globalConfigProgress(
    uiContext: UIContext,
    globalOptions?: ((options: XTHUDProgressOptions) => void)
  ): void {
    // 预初始化
    XTPromptHUD.initProgressInstance(uiContext, globalOptions)
  }
  /**
   * 销毁全局 progress 单例，后续必须重新执行 globalConfigProgress 才可以继续使用 progress
   * !!! 注意销毁执行后，对应 HUD 会全部关闭
   */
  static globalDestroyProgress(): void {
    if (XTPromptHUD._progress) {
      XTPromptHUD.hideProgress()
      XTPromptHUD._progress = null
    }
  }

  /**
   * 自定义 HUD 全局配置，必须在 windowStage.loadContent 后执行 UIContext 赋值
   * 其他全局样式配置为可选操作，不配置就是默认样式
   * !!! 建议使用自定义 HUD 前执行，如果不执行，将会使用默认上下文的 context 的 getLastWindow 的 UIContext
   * !!! 如果对应场景下 window 还未创建，toast 将无法显示，如果对应 UI 上下文对应的 window 不是你想要的 window，HUD 将加载在错误的位置
   * !!! 注意设置全局配置后，必须通过指定 show 事件中的 options 才可以刷新样式配置，但不会覆盖全局配置
   * !!! UIContext 也可以在后续的 show 事件中动态指定，但并不会覆盖全局配置的 UIContext
   * !!! 想要重置全局配置，需要手动执行 globalDestroyCustomHUD 后重新执行 globalConfigCustomHUD
   *
   * @param { uiContext } UIContext，必传，例如 windowStage.getMainWindowSync().getUIContext() 或者 组件内的 this.getUIContext()
   * 注意：uiContext 直接决定了 HUD 的显示位置，尤其是多 window 或者嵌套 subwindow 的复杂应用场景，注意 uiContext 更新
   * @param { globalOptions } 样式配置回调函数，XTHUDBaseOptions部分可在此设置，后续无法动态更新，其他样式可动态配置，如果 globalOptions 中再次设置 UIContext 不会生效
   */
  static globalConfigCustomHUD(
    uiContext: UIContext,
    globalOptions?: ((options: XTHUDCustomOptions) => void)
  ): void {
    // 预初始化
    XTPromptHUD.initCustomInstance(uiContext, globalOptions)
  }
  /**
   * 销毁全局 customHUD 单例，后续必须重新执行 globalConfigCustomHUD 才可以继续使用
   * !!! 注意销毁执行后，对应 HUD 会全部关闭
   */
  static globalDestroyCustomHUD(): void {
    if (XTPromptHUD._custom) {
      XTPromptHUD.hideCustomHUD()
      XTPromptHUD._custom = null
    }
  }


  /**
   * Toast，默认不屏蔽用户交互
   * 常规纯文本toast，自定义图标需要实现options.iconSrc
   *
   * @param { ResourceStr } text 显示文本，必填，为空串不显示
   * @param { XTHUDToastOptions? } options 可选自定义样式
   */
  static showToast(text: ResourceStr, options?: XTHUDToastOptions): void {
    if (!text || text === '') {
      return
    }
    if (XTPromptHUD._toast) {
      XTPromptHUD._toast.showToast(text, options)
    } else {
      if (options?.uiContext) {
        console.warn('[XTPromptHUD.showToast] warning: globalConfigToast is not executed, the current options.uiContext is set to global uiContext!')
        let toastHUD = XTPromptHUD.initToastInstance(options.uiContext)
        toastHUD.showToast(text, options)
      } else {
        console.error('[XTPromptHUD.showToast] error: globalConfigToast or options.uiContext must be executed first!')
        throw new Error('[XTPromptHUD.showToast] error: globalConfigToast or options.uiContext must be executed first!')
      }
      // XTPromptHUD.asyncConfigToast((toast: XTPromptHUDToastClass | null) => {
      //   if (toast) {
      //     console.warn('[XTPromptHUD.showToast] warning: globalConfigToast is not executed, the default context is used!')
      //     toast.showToast(text, options)
      //   } else {
      //     console.error('[XTPromptHUD.showToast] error: globalConfigToast must be executed first!')
      //     // throw new Error('globalConfigToast must be executed first!')
      //   }
      // })
    }
  }
  /**
   * Toast，默认不屏蔽用户交互
   * 带info图标的文本toast
   *
   * @param { ResourceStr } text 显示文本，必填，为空串不显示
   * @param { XTHUDToastOptions? } options 可选自定义样式
   */
  static showInfo(text: ResourceStr, options?: XTHUDToastOptions): void {
    if (!text || text === '') {
      return
    }
    if (XTPromptHUD._toast) {
      XTPromptHUD._toast.showInfo(text, options)
    } else {
      if (options?.uiContext) {
        console.warn('[XTPromptHUD.showInfo] warning: globalConfigToast is not executed, the current options.uiContext is set to global uiContext!')
        let toastHUD = XTPromptHUD.initToastInstance(options.uiContext)
        toastHUD.showInfo(text, options)
      } else {
        console.error('[XTPromptHUD.showInfo] error: globalConfigToast or options.uiContext must be executed first!')
        throw new Error('[XTPromptHUD.showInfo] error: globalConfigToast or options.uiContext must be executed first!')
      }
      // XTPromptHUD.asyncConfigToast((toast: XTPromptHUDToastClass | null) => {
      //   if (toast) {
      //     console.warn('[XTPromptHUD.showInfo] warning: globalConfigToast is not executed, the default context is used!')
      //     toast.showInfo(text, options)
      //   } else {
      //     console.error('[XTPromptHUD.showInfo] error: globalConfigToast must be executed first!')
      //     // throw new Error('globalConfigToast must be executed first!')
      //   }
      // })
    }
  }
  /**
   * Toast，默认不屏蔽用户交互
   * 带warning图标的文本toast
   *
   * @param { ResourceStr } text 显示文本，必填，为空串不显示
   * @param { XTHUDToastOptions? } options 可选自定义样式
   */
  static showWarning(text: ResourceStr, options?: XTHUDToastOptions): void {
    if (!text || text === '') {
      return
    }
    if (XTPromptHUD._toast) {
      XTPromptHUD._toast.showWarning(text, options)
    } else {
      if (options?.uiContext) {
        console.warn('[XTPromptHUD.showWarning] warning: globalConfigToast is not executed, the current options.uiContext is set to global uiContext!')
        let toastHUD = XTPromptHUD.initToastInstance(options.uiContext)
        toastHUD.showWarning(text, options)
      } else {
        console.error('[XTPromptHUD.showWarning] error: globalConfigToast or options.uiContext must be executed first!')
        throw new Error('[XTPromptHUD.showWarning] error: globalConfigToast or options.uiContext must be executed first!')
      }
      // XTPromptHUD.asyncConfigToast((toast: XTPromptHUDToastClass | null) => {
      //   if (toast) {
      //     console.warn('[XTPromptHUD.showWarning] warning: globalConfigToast is not executed, the default context is used!')
      //     toast.showWarning(text, options)
      //   } else {
      //     console.error('[XTPromptHUD.showWarning] error: globalConfigToast must be executed first!')
      //     // throw new Error('globalConfigToast must be executed first!')
      //   }
      // })
    }
  }
  /**
   * Toast，默认不屏蔽用户交互
   * 带success图标的文本toast
   *
   * @param { ResourceStr } text 显示文本，必填，为空串不显示
   * @param { XTHUDToastOptions? } options 可选自定义样式
   */
  static showSuccess(text: ResourceStr, options?: XTHUDToastOptions): void {
    if (!text || text === '') {
      return
    }
    if (XTPromptHUD._toast) {
      XTPromptHUD._toast.showSuccess(text, options)
    } else {
      if (options?.uiContext) {
        console.warn('[XTPromptHUD.showSuccess] warning: globalConfigToast is not executed, the current options.uiContext is set to global uiContext!')
        let toastHUD = XTPromptHUD.initToastInstance(options.uiContext)
        toastHUD.showSuccess(text, options)
      } else {
        console.error('[XTPromptHUD.showSuccess] error: globalConfigToast or options.uiContext must be executed first!')
        throw new Error('[XTPromptHUD.showSuccess] error: globalConfigToast or options.uiContext must be executed first!')
      }
      // XTPromptHUD.asyncConfigToast((toast: XTPromptHUDToastClass | null) => {
      //   if (toast) {
      //     console.warn('[XTPromptHUD.showSuccess] warning: globalConfigToast is not executed, the default context is used!')
      //     toast.showSuccess(text, options)
      //   } else {
      //     console.error('[XTPromptHUD.showSuccess] error: globalConfigToast must be executed first!')
      //     // throw new Error('globalConfigToast must be executed first!')
      //   }
      // })
    }
  }
  /**
   * Toast，默认不屏蔽用户交互
   * 带error图标的文本toast
   *
   * @param { ResourceStr } text 显示文本，必填，为空串不显示
   * @param { XTHUDToastOptions? } options 可选自定义样式
   */
  static showError(text: ResourceStr, options?: XTHUDToastOptions): void {
    if (!text || text === '') {
      return
    }
    if (XTPromptHUD._toast) {
      XTPromptHUD._toast.showError(text, options)
    } else {
      if (options?.uiContext) {
        console.warn('[XTPromptHUD.showError] warning: globalConfigToast is not executed, the current options.uiContext is set to global uiContext!')
        let toastHUD = XTPromptHUD.initToastInstance(options.uiContext)
        toastHUD.showError(text, options)
      } else {
        console.error('[XTPromptHUD.showError] error: globalConfigToast or options.uiContext must be executed first!')
        throw new Error('[XTPromptHUD.showError] error: globalConfigToast or options.uiContext must be executed first!')
      }
      // XTPromptHUD.asyncConfigToast((toast: XTPromptHUDToastClass | null) => {
      //   if (toast) {
      //     console.warn('[XTPromptHUD.showError] warning: globalConfigToast is not executed, the default context is used!')
      //     toast.showError(text, options)
      //   } else {
      //     console.error('[XTPromptHUD.showError] error: globalConfigToast must be executed first!')
      //     // throw new Error('globalConfigToast must be executed first!')
      //   }
      // })
    }
  }
  /**
   * 隐藏一个toast，toast默认自动隐藏，如有需求可用hide方法提前关闭
   */
  static hideToast(): void {
    if (XTPromptHUD._toast) {
      XTPromptHUD._toast.hide()
    } else {
      console.error('[XTPromptHUD.hideAllToast] error: show toast must be executed first!')
    }
  }
  /**
   * 隐藏全部toast，如果同时触发多个toast，可用这个全部关闭
   */
  static hideAllToast(): void {
    if (XTPromptHUD._toast) {
      XTPromptHUD._toast.hideAll()
    } else {
      console.error('[XTPromptHUD.hideAllToast] error: show toast must be executed first!')
    }
  }


  /**
   * Loading，默认屏蔽用户交互
   * 默认样式loading，使用了鸿蒙默认的loading样式，也就是原生LoadingProgress组件
   *
   * @param { ResourceStr? } text 显示文本，可选
   * @param { XTHUDLoadingOptions? } options 可选自定义样式
   */
  static showLoading(text?: ResourceStr, options?: XTHUDLoadingOptions): void {
    if (XTPromptHUD._loading) {
      XTPromptHUD._loading.showLoading(text, options)
    } else {
      if (options?.uiContext) {
        console.warn('[XTPromptHUD.showLoading] warning: globalConfigLoading is not executed, the current options.uiContext is set to global uiContext!')
        let loadingHUD = XTPromptHUD.initLoadingInstance(options.uiContext)
        loadingHUD.showLoading(text, options)
      } else {
        console.error('[XTPromptHUD.showLoading] error: globalConfigLoading or options.uiContext must be executed first!')
        throw new Error('[XTPromptHUD.showLoading] error: globalConfigLoading or options.uiContext must be executed first!')
      }
      // XTPromptHUD.asyncConfigLoading((loading: XTPromptHUDLoadingClass | null) => {
      //   if (loading) {
      //     console.warn('[XTPromptHUD.showLoading] warning: globalConfigLoading is not executed, the default context is used!')
      //     loading.showLoading(text, options)
      //   } else {
      //     console.error('[XTPromptHUD.showLoading] error: globalConfigLoading must be executed first!')
      //     // throw new Error('globalConfigLoading must be executed first!')
      //   }
      // })
    }
  }
  /**
   * Loading，默认屏蔽用户交互
   * 圆环样式loading，使用了鸿蒙原生Progress组件的LOADING样式
   *
   * @param { ResourceStr? } text 显示文本，可选
   * @param { XTHUDLoadingOptions? } options 可选自定义样式
   */
  static showRingLoading(text?: ResourceStr, options?: XTHUDLoadingOptions): void {
    if (XTPromptHUD._loading) {
      XTPromptHUD._loading.showRingLoading(text, options)
    } else {
      if (options?.uiContext) {
        console.warn('[XTPromptHUD.showRingLoading] warning: globalConfigLoading is not executed, the current options.uiContext is set to global uiContext!')
        let loadingHUD = XTPromptHUD.initLoadingInstance(options.uiContext)
        loadingHUD.showRingLoading(text, options)
      } else {
        console.error('[XTPromptHUD.showRingLoading] error: globalConfigLoading or options.uiContext must be executed first!')
        throw new Error('[XTPromptHUD.showRingLoading] error: globalConfigLoading or options.uiContext must be executed first!')
      }
      // XTPromptHUD.asyncConfigLoading((loading: XTPromptHUDLoadingClass | null) => {
      //   if (loading) {
      //     console.warn('[XTPromptHUD.showRingLoading] warning: globalConfigLoading is not executed, the default context is used!')
      //     loading.showRingLoading(text, options)
      //   } else {
      //     console.error('[XTPromptHUD.showRingLoading] error: globalConfigLoading must be executed first!')
      //     // throw new Error('globalConfigLoading must be executed first!')
      //   }
      // })
    }
  }
  /**
   * Loading，默认屏蔽用户交互
   * 自定义样式loading，建议使用svg动效图标资源，具体参考Demo
   *
   * @param { PixelMap | ResourceStr | DrawableDescriptor } iconSrc 图标资源，建议使用svg动效图标资源
   * @param { ResourceStr? } ResourceStr 显示文本，可选
   * @param { XTHUDLoadingOptions? } options 可选自定义样式
   */
  static showCustomLoading(iconSrc: PixelMap | ResourceStr | DrawableDescriptor, text?: ResourceStr, options?: XTHUDLoadingOptions): void {
    if (XTPromptHUD._loading) {
      XTPromptHUD._loading.showCustomLoading(iconSrc, text, options)
    } else {
      if (options?.uiContext) {
        console.warn('[XTPromptHUD.showCustomLoading] warning: globalConfigLoading is not executed, the current options.uiContext is set to global uiContext!')
        let loadingHUD = XTPromptHUD.initLoadingInstance(options.uiContext)
        loadingHUD.showCustomLoading(iconSrc, text, options)
      } else {
        console.error('[XTPromptHUD.showCustomLoading] error: globalConfigLoading or options.uiContext must be executed first!')
        throw new Error('[XTPromptHUD.showCustomLoading] error: globalConfigLoading or options.uiContext must be executed first!')
      }
      // XTPromptHUD.asyncConfigLoading((loading: XTPromptHUDLoadingClass | null) => {
      //   if (loading) {
      //     console.warn('[XTPromptHUD.showCustomLoading] warning: globalConfigLoading is not executed, the default context is used!')
      //     loading.showCustomLoading(iconSrc, text, options)
      //   } else {
      //     console.error('[XTPromptHUD.showCustomLoading] error: globalConfigLoading must be executed first!')
      //     // throw new Error('globalConfigLoading must be executed first!')
      //   }
      // })
    }
  }
  /**
   * 隐藏一次loading，在并发请求中，如果需要loading去屏蔽用户交互，可能会有多次触发loading的情况
   * 内部维护了一个计数器，所以重复执行show方法并不会重复创建loading组件，可以避免资源消耗和loading显示冲突问题
   */
  static hideLoading(): void {
    if (XTPromptHUD._loading) {
      XTPromptHUD._loading.hide()
    } else {
      console.error('[XTPromptHUD.hideAllLoading] error: show loading must be executed first!')
    }
  }
  /**
   * 隐藏全部loading，可以在并发请求结束后，一次执行关闭所有的loading（计数器清零）
   */
  static hideAllLoading(): void {
    if (XTPromptHUD._loading) {
      XTPromptHUD._loading.hideAll()
    } else {
      console.error('[XTPromptHUD.hideAllLoading] error: show loading must be executed first!')
    }
  }


  /**
   * Progress，默认屏蔽用户交互
   * 圆环进度组件，使用了鸿蒙原生Progress组件的PROGRESSING样式
   * 更新进度重复调用该方法即可，不会重复创建 HUD 实例
   *
   * @param { number } progress 进度数值，百分数，20%就是写20
   * @param { ResourceStr? } ResourceStr 显示文本，可选
   * @param { XTHUDProgressOptions? } options 可选自定义样式
   */
  static showProgress(progress: number, text?: ResourceStr, options?: XTHUDProgressOptions): void {
    if (XTPromptHUD._progress) {
      XTPromptHUD._progress.showProgress(progress, text, options)
    } else {
      if (options?.uiContext) {
        console.warn('[XTPromptHUD.showProgress] warning: globalConfigProgress is not executed, the current options.uiContext is set to global uiContext!')
        let progressHUD = XTPromptHUD.initProgressInstance(options.uiContext)
        progressHUD.showProgress(progress, text, options)
      } else {
        console.error('[XTPromptHUD.showProgress] error: globalConfigProgress or options.uiContext must be executed first!')
        throw new Error('[XTPromptHUD.showProgress] error: globalConfigProgress or options.uiContext must be executed first!')
      }
      // XTPromptHUD.asyncConfigProgress((progressHUD: XTPromptHUDProgressClass | null) => {
      //   if (progressHUD) {
      //     console.warn('[XTPromptHUD.showProgress] warning: globalConfigProgress is not executed, the default context is used!')
      //     progressHUD.showProgress(progress, text, options)
      //   } else {
      //     console.error('[XTPromptHUD.showProgress] error: globalConfigProgress must be executed first!')
      //     // throw new Error('globalConfigProgress must be executed first!')
      //   }
      // })
    }
  }
  /**
   * Progress，默认屏蔽用户交互
   * Linear进度组件，使用了鸿蒙原生Progress组件的Linear样式
   * 更新进度重复调用该方法即可，不会重复创建 HUD 实例
   *
   * @param { number } progress 进度数值，百分数，20%就是写20
   * @param { ResourceStr? } text 显示文本，可选，如果设置将和 progress 同行拼接显示
   * @param { XTHUDProgressOptions? } options 可选自定义样式
   */
  static showBarProgress(progress: number, text?: ResourceStr, options?: XTHUDProgressOptions): void {
    if (XTPromptHUD._progress) {
      XTPromptHUD._progress.showBarProgress(progress, text, options)
    } else {
      if (options?.uiContext) {
        console.warn('[XTPromptHUD.showBarProgress] warning: globalConfigProgress is not executed, the current options.uiContext is set to global uiContext!')
        let progressHUD = XTPromptHUD.initProgressInstance(options.uiContext)
        progressHUD.showBarProgress(progress, text, options)
      } else {
        console.error('[XTPromptHUD.showBarProgress] error: globalConfigProgress or options.uiContext must be executed first!')
        throw new Error('[XTPromptHUD.showBarProgress] error: globalConfigProgress or options.uiContext must be executed first!')
      }
      // XTPromptHUD.asyncConfigProgress((progressHUD: XTPromptHUDProgressClass | null) => {
      //   if (progressHUD) {
      //     console.warn('[XTPromptHUD.showBarProgress] warning: globalConfigProgress is not executed, the default context is used!')
      //     progressHUD.showBarProgress(progress, text, options)
      //   } else {
      //     console.error('[XTPromptHUD.showBarProgress] error: globalConfigProgress must be executed first!')
      //     // throw new Error('globalConfigProgress must be executed first!')
      //   }
      // })
    }
  }
  /**
   * 隐藏全部progress，progress不会同时创建多个
   */
  static hideProgress(): void {
    if (XTPromptHUD._progress) {
      XTPromptHUD._progress.hide()
    } else {
      console.error('[XTPromptHUD.hideProgress] error: show progress must be executed first!')
    }
  }


  /**
   * 自定义 HUD 显示，例如开屏广告或者自定义弹出层
   * 更新请使用 updateCustomHUD，当前 HUD 不做 hide 操作，重复执行 showCustomHUD 仅更新内容，即不可同时显示多个弹出层 HUD
   *
   * @param { WrappedBuilder<[T]> } hudNodeBuilder 使用 wrapBuilder 函数包裹的 @Builder 构造函数
   * @param { <T extends Object> } hudNodeArgs wrapBuilder 参数，即 @Builder 构造函数入参，需要封装为对象形式
   * @param { XTHUDCustomOptions? } options 可选自定义控制
   */
  static showCustomHUD<T extends Object>(
    hudNodeBuilder: WrappedBuilder<[
      T
    ]>,
    hudNodeArgs: T,
    options?: XTHUDCustomOptions
  ): void {
    if (XTPromptHUD._custom) {
      XTPromptHUD._custom.show(hudNodeBuilder, hudNodeArgs, options)
    } else {
      if (options?.uiContext) {
        console.warn('[XTPromptHUD.showCustomHUD] warning: globalConfigCustomHUD is not executed, the current options.uiContext is set to global uiContext!')
        let customHUD = XTPromptHUD.initCustomInstance(options.uiContext)
        customHUD.show(hudNodeBuilder, hudNodeArgs, options)
      } else {
        console.error('[XTPromptHUD.showCustomHUD] error: globalConfigCustomHUD or options.uiContext must be executed first!')
        throw new Error('[XTPromptHUD.showCustomHUD] error: globalConfigCustomHUD or options.uiContext must be executed first!')
      }
      // XTPromptHUD.asyncConfigCustomHUD((customHUD: XTPromptHUDCustomClass | null) => {
      //   if (customHUD) {
      //     console.warn('[XTPromptHUD.showCustomHUD] warning: globalConfigCustomHUD is not executed, the default context is used!')
      //     customHUD.show(hudNodeBuilder, hudNodeArgs, options)
      //   } else {
      //     console.error('[XTPromptHUD.showCustomHUD] error: globalConfigCustomHUD must be executed first!')
      //     // throw new Error('globalConfigCustomHUD must be executed first!')
      //   }
      // })
    }
  }
  /**
   * 自定义 HUD 显示更新
   *
   * @param { <T extends Object> } hudNodeArgs wrapBuilder 参数，即 @Builder 构造函数入参，需要封装为对象形式
   * 更新和初始显示对象格式必须保持统一，否则报错
   */
  static updateCustomHUD<T extends Object>(
    hudNodeArgs: T
  ): void {
    if (XTPromptHUD._custom) {
      XTPromptHUD._custom.update(hudNodeArgs)
    } else {
      console.error('[XTPromptHUD.updateCustomHUD] error: showCustomHUD must be executed first!')
    }
  }
  /**
   * 自定义 HUD 关闭
   */
  static hideCustomHUD(): void {
    if (XTPromptHUD._custom) {
      XTPromptHUD._custom.hide()
    } else {
      console.error('[XTPromptHUD.hideCustomHUD] error: showCustomHUD must be executed first!')
    }
  }
}