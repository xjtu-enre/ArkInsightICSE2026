import {
  XTHUDToastOptions,
  XTHUDLoadingOptions,
  XTHUDProgressOptions
} from './XTHUDInterface'


/// XTHUD管理虚类，具体方法实现在XTHUD内部组件挂载处，此处为默认空实现，不要覆写
class _XTHUDManager {
  // 单例对象
  static _instance: _XTHUDManager
  // 获取单例对象
  static getInstance(): _XTHUDManager {
    if (!_XTHUDManager._instance) {
      _XTHUDManager._instance = new _XTHUDManager()
    }
    return _XTHUDManager._instance
  }

  /// Toast，默认不屏蔽用户交互
  /// 常规纯文本toast，自定义图标需要实现options.iconSrc
  showToast: (text: ResourceStr, options?: XTHUDToastOptions) => void = (text: ResourceStr) => {
    throw new Error('XTHUDToast components must be mounted first!')
  }
  /// 带info图标的文本toast
  showInfo: (text: ResourceStr, options?: XTHUDToastOptions) => void = (text: ResourceStr) => {
    throw new Error('XTHUDToast components must be mounted first!')
  }
  /// 带warning图标的文本toast
  showWarning: (text: ResourceStr, options?: XTHUDToastOptions) => void = (text: ResourceStr) => {
    throw new Error('XTHUDToast components must be mounted first!')
  }
  /// 带success图标的文本toast
  showSuccess: (text: ResourceStr, options?: XTHUDToastOptions) => void = (text: ResourceStr) => {
    throw new Error('XTHUDToast components must be mounted first!')
  }
  /// 带error图标的文本toast
  showError: (text: ResourceStr, options?: XTHUDToastOptions) => void = (text: ResourceStr) => {
    throw new Error('XTHUDToast components must be mounted first!')
  }
  /// 隐藏一个toast，toast默认自动隐藏，如有需求可用hide方法提前关闭
  hideToast: () => void = () => {
    throw new Error('XTHUDToast components must be mounted first!')
  }
  /// 隐藏全部toast，如果同时触发多个toast，可用这个全部关闭
  hideAllToast: () => void = () => {
    throw new Error('XTHUDToast components must be mounted first!')
  }

  /// Loading，默认屏蔽用户交互
  /// 默认样式loading，使用了鸿蒙默认的loading样式，也就是原生LoadingProgress组件
  showLoading: (text?: ResourceStr, options?: XTHUDLoadingOptions) => void = () => {
    throw new Error('XTHUDLoading components must be mounted first!')
  }
  /// 圆环样式loading，使用了鸿蒙原生Progress组件的LOADING样式
  showRingLoading: (text?: ResourceStr, options?: XTHUDLoadingOptions) => void = () => {
    throw new Error('XTHUDLoading components must be mounted first!')
  }
  /// 自定义样式loading，建议使用svg动效图标资源，具体参考Demo
  showCustomLoading: (iconSrc: PixelMap | ResourceStr | DrawableDescriptor, text?: ResourceStr, options?: XTHUDLoadingOptions) => void = (iconSrc: PixelMap | ResourceStr | DrawableDescriptor) => {
    throw new Error('XTHUDLoading components must be mounted first!')
  }
  /// 隐藏一次loading，在并发请求中，如果需要loading去屏蔽用户交互，可能会有多次触发loading的情况
  /// 内部维护了一个计数器，所以重复执行show方法并不会重复创建loading组件，可以避免资源消耗和loading显示冲突问题
  hideLoading: () => void = () => {
    throw new Error('XTHUDLoading components must be mounted first!')
  }
  /// 隐藏全部loading，可以在并发请求结束后，一次执行关闭所有的loading（计数器清零）
  hideAllLoading: () => void = () => {
    throw new Error('XTHUDLoading components must be mounted first!')
  }

  /// Progress，默认屏蔽用户交互
  /// 圆环进度组件，使用了鸿蒙原生Progress组件的PROGRESSING样式，
  showProgress: (progress: number, text?: ResourceStr, options?: XTHUDProgressOptions) => void = (progress: number) => {
    throw new Error('XTHUDProgress components must be mounted first!')
  }
  /// Linear进度组件，使用了鸿蒙原生Progress组件的Linear样式
  showBarProgress: (progress: number, text?: ResourceStr, options?: XTHUDProgressOptions) => void = (progress: number) => {
    throw new Error('XTHUDProgress components must be mounted first!')
  }
  /// 隐藏全部progress，progress无法同时创建多个
  hideProgress: () => void = () => {
    throw new Error('XTHUDProgress components must be mounted first!')
  }
}

/// 单例对象
// const _HUDManager = new _XTHUDManager()
const _HUDManager = _XTHUDManager.getInstance()
export default _HUDManager