# [v3.4.0] 20250301
1. CustomHUD 新增 supportMultilayer 属性，支持多个自定义弹窗堆叠显示，默认为 false，也就是单层显示
2. 某些场景中，使用 CustomHUD 自定义不同类别弹窗，原有的单层弹窗多次执行仅更新数据的模式无法满足需求，需要支持多层自定义弹窗显示
3. supportMultilayer 支持全局配置或者独立配置，框架内部维护弹窗栈逻辑，使用方无需关心实现细节

# [v3.3.0] 20241206
- 去除了 XTPromptHUD 内部的 UIContext 自动异步获取的兜底策略，避免出时序问题！
- 之前的自动兜底策略获取的是 LastWindow 的 UIContext，所以针对 subwindow 的显示一定会出问题！
- 后续版本的 XTPromptHUD 使用，UIContext 必须显示指定一次，强烈建议全局初始化阶段执行 globalConfigXXX API 去配置 UI 上下文
- XTPromptHUD 的所有 HUD 的 show 操作，从上个版本开始均已支持 uiContext 配置属性，支持动态设置，也就是临时更新 UI 上下文
- 用户必须清楚并自行决定自己的 HUD 所要显示的 window 层级，或者说是 UI 上下文，默认是 mainWindow 的
- 放开了 asyncGetLastWindowUIContext API，用户可以自行决定是否使用该 API 获取 UIContext
> 🌟 注意：
> 1. 如果不设置 UIContext ，直接 show PromptHUD，该版本会强制触发内部的异常提示导致 crash，所以谨慎更新该版本！
> 2. 新版本使用，只需稍微适配一下即可，使用也会更加规范，避免后续出不必要的 bug 问题。
> 3. 如果之前使用已经使用了 globalConfigXXX API，无需更改代码即可继续使用


# [v3.2.0] 20241030
- XTHUD 系列组件和 XTHUDManager 标识废弃，后续不再维护更新
- XTEasyHUD 标识废弃，后续不再维护更新
- XTPromptHUD.showRingLoading 新增 strokeBackgroundColor 属性，支持自定义 loading 环背景色
- XTPromptHUD.ProgressHUD 新增 strokeBackgroundColor 属性，支持自定义加载进度背景色
- XTHUDReactiveBaseOptions 新增 uiContext 属性，支持 HUD 在执行显示阶段重新自定义 UI 上下文，指定显示 window 层级

# [v3.1.4] 20240919
- 使用 Beta1(5.0.3.806) 构建
- 新增 showInSubWindow 属性，支持在子窗口中显示 HUD
- 新增 keyboardAvoidMode 属性，支持键盘避让模式设置，注意该属性为 5.0.3.806 新增！
- 注意 showInSubWindow = true 时，KeyboardAvoidMode.DEFAULT 失效，这应该是系统特性

# [v3.1.3] 20240806
- ProgressHUD 新增 autoHideWhenProgressCompletion 属性，支持用户自定义 ProgressHUD 的自动隐藏逻辑

# [v3.1.2] 20240802
- HUD 的 Text 显示新增 font 属性，可以用于自定义 fontWeight、fontFamily、fontStyle
- HUD 的 Text 显示新增 lineHeight 属性
- ProgressHUD 的进度字体样式控制拆分，新增 progressFont、progressTextColor 属性

# [v3.1.1] 20240722
- 修复 XTEasyHUD 崩溃问题
- 换用 DevEco-Studio Beta2 构建

# [v3.1.0] 20240717
- 所有的 HUD（XTHUDManager、XTEasyHUD、XTPromptHUD）的 text 入参由 string 类型改为 ResourceStr，支持多语言配置
- 修复 XTEasyHUD 的 UI 上下文安全性问题，避免在异步等场景中无法显示，现在无需注册即可安全的使用 XTEasyHUD

# [v3.0.2] 20240715
- XTPromptHUD 增加免注册能力，不执行手动全局配置，将默认使用当前 window 的 context，并不太推荐这种方式，默认会有 warn log
- 修改所有的 ToastHUD 在 text 传值为空串时，将屏蔽显示逻辑，避免显示空 toast

# [v3.0.1] 20240712
- 解决直接执行 globalDestroy 系列 API 崩溃的问题
- 去除异常调用时的 throw new Error 动作，改为 console.error

# [v3.0.0] 20240712
- V3 版本强制依赖 API12 环境（5.0.0(12)），API11 无法使用，如需适配 API11 请使用 v1.2.1 
- 新增 XTPromptHUD 工具类，基于 ComponentContent 重构 HUD 渲染逻辑，不再受限于 ArkUI 的 @Component 上下文环境 
- 支持在 EntryAbility 中显示 HUD 
- 支持在 Promise 异步环境中显示 HUD 
- XTPromptHUD 新增 showCustomHUD API，支持自定义弹出层显示，支持例如开屏广告的业务场景自定义实现 
- 新增 onPressBack 回调，可以避免设置 closeOnPressBack = false 后，系统返回响应丢失
- 后续版本将主推 XTPromptHUD，XTEasyHUD 和 XTHUDManager 将不再更新维护

# [v2.0.1] 20240703
- V2 版本后将强制依赖 API12 环境（5.0.0(12)），API11 无法使用，如需适配 API11 请使用 v1.2.1
- 新增 closeOnPressBack 属性，可控制是否点击系统返回键时关闭 HUD，默认 false，开启后触发返回关闭会执行 onCancel
- 新增 closeOnClickOutside 属性，可控制是否点击 HUD 背景时关闭（isModal 为 true 时生效），默认 false，开启后触发点击背景关闭会执行 onCancel

# [v1.2.1] 20240703
- 修复 LocalizedMargin 在 API11 上不兼容的问题
- 注意，后续该组件库将强推 V2 版本（还未发布），V2 中增加了 API12 的相关特性支持，例如可屏蔽返回键关闭 Dialog 的操作，这在 API11 中无法实现
- 后续 V1 版本仅做 bugfix 支持，V2 版本会作为主版本持续更新维护

# [v1.2.0] 20240702
- 新增 iconMargin、textPadding、minWidth、maxWidth 样式自定义属性支持
- 代码结构整合优化

# [v1.1.1] 20240625
- 修复 Toast 阴影问题
- 修复构建兼容 API11

# [v1.1.0] 20240622
- 新增 XTEasyHUD 工具类，HUD 组件无需挂载即可直接使用;
- 代码结构再次优化;
- 适配 API12 beta1，基于 API12 build，不兼容 API11

# [v1.0.3] 20240621
- 新增 XTEasyHUD 工具类，HUD 组件无需挂载即可直接使用；
- 代码结构优化；
- 命名修改：XTHUDReactiveOptions 接口中的 completionCallback 替换为 onCompletion，cancelCallback 替换为 onCancel

# [v1.0.2] 20240606
- 完善API注释，完善使用文档，更新LICENSE，增加example

# [v1.0.1] 20240604
- 更新协议，更新组件名

# [v1.0.0] 20240603
- 初始发布