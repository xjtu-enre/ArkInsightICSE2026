# PullToRefresh

[v1装饰器版本](https://gitee.com/zhongrui_developer/PullToRefresh)

[v2装饰器版本](https://gitee.com/zhongrui_developer/PullToRefresh/tree/master_v2/)
## 简介
PullToRefresh 实现垂直列表下拉刷新,上拉加载，横向列表左拉刷新，右拉加载

## 下载安装
```text
ohpm install @zhongrui/pull_to_refresh
```

```text
import {
  PullToRefreshLayout,
  RefreshLayout,
  RefreshLayoutConfig,
  PullDown,
  PullStatus,
  RefreshController,
  PullToRefreshConfig,
} from 'PullToRefresh/Index';
```

#### 特点
1.无入侵性，不需要传数据源

2.不限制组件，支持任意布局(List,Grid,Web,Scroll,Text,Row,Column等布局)

3.支持header和footer定制(支持Lottie动画)

4.支持垂直列表和横向列表的刷新和加载

5.支持下拉(或者上拉)打开其他页面 

<br/>

##### 提供了RefreshLayout和PullToRefreshLayout
1.RefreshLayout支持各种定制化<br/>
2.PullToRefreshLayout是在RefreshLayout基础上定制的，实现常用刷新和加载功能<br/>
3.如果没有个性化需求，可以直接使用PullToRefreshLayout


**如果图片不能正常显示**[点这里](https://gitee.com/zhongrui_developer/PullToRefresh)

| 垂直List列表刷新效果  | 垂直Grid列表刷新效果  | 下拉打开其他页面  | 自动刷新  |
|---|---|---|---|
| <img src="https://gitee.com/zhongrui_developer/PullToRefresh/raw/master/screenshot/refresh_list.gif" width="200px" />  | <img src="https://gitee.com/zhongrui_developer/PullToRefresh/raw/master/screenshot/refresh_grid.gif" width="200px" />  | <img src="https://gitee.com/zhongrui_developer/PullToRefresh/raw/master/screenshot/open_page_v_h.gif" width="200px" />  | <img src="https://gitee.com/zhongrui_developer/PullToRefresh/raw/master/screenshot/refresh_auto.gif" width="200px" />  |

|  Web视图刷新效果 | 自定义动画刷新效果  | Lottie动画刷新效果  | 横向列表刷新  |
|---|---|---|---|
|  <img src="https://gitee.com/zhongrui_developer/PullToRefresh/raw/master/screenshot/refresh_web.gif" width="200px" /> | <img src="https://gitee.com/zhongrui_developer/PullToRefresh/raw/master/screenshot/refresh_anim.gif" width="200px" />  |  <img src="https://gitee.com/zhongrui_developer/PullToRefresh/raw/master/screenshot/refresh_lottie.gif" width="200px" /> | <img src="https://gitee.com/zhongrui_developer/PullToRefresh/raw/master/screenshot/refresh_h.gif" width="200px" />   |


#### 三种横向模式header效果图(footer同理)
|  header正常横向<br/>header宽度固定,高度撑满 | header布局逆时针旋转90°<br/>header宽度撑满,高度固定<br/>和垂直列表布局方式一致  | header布局顺时针旋转90°<br/>header宽度撑满,高度固定<br/>和垂直列表布局方式一致  |  
|---|---|---|
|  <img src="https://gitee.com/zhongrui_developer/PullToRefresh/raw/master/screenshot/h_0.png"  width="200px" /> | <img src="https://gitee.com/zhongrui_developer/PullToRefresh/raw/master/screenshot/h_1.png"  width="200px" /> |  <img src="https://gitee.com/zhongrui_developer/PullToRefresh/raw/master/screenshot/h_2.png"  width="200px" />  |

#### 缺省页设置(加载中，空数据，加载失败，无网络)
|  |   |   |  
|---------------------------------------------------------------------------------------------------------------|---|---|
| <img src="https://gitee.com/zhongrui_developer/PullToRefresh/raw/master/screenshot/custom_view.gif"  width="200px" /> |   |

### PullToRefreshLayout使用说明(通用方案)(如需个性化定制,请使用[RefreshLayout](#target-id))
**默认带弹性效果的列表需要关闭弹性滑动，.edgeEffect(EdgeEffect.None)**
```text
@Component
export struct Example {
  /*RefreshLayout控制器*/
  controller: RefreshController = new RefreshController()
  
  /*RefreshLayout配置*/
  config: RefreshLayoutConfig = new RefreshLayoutConfig()
  
  /*需要将scroller设置给列表组件*/
  scroller: Scroller = new Scroller()
  
  /*webview配置器*/
  webviewController: web.WebviewController = new web.WebviewController()

  build() {
    PullToRefreshLayout({
       /*非必传，headerloading动画视图*/
       headerLoadIngView:()=>{
          this.loading()
       },
       
       /*非必传，footerloading动画视图*/
       footerLoadIngView:()=>{
          this.loading()
       },
       
      /*必传，记录刷新时间的key*/
      viewKey: "列表标识",
      
      /*非必传，设置刷新配置，不设置时自动设置默认值*/
      config: this.config,
      
      /*必传，RefreshLayout控制器*/
      controller: this.controller,
      
      /*必传，设置和列表相关的Scroller，比如List,Grid,Scroll,WaterFlow等组件*/
      scroller: this.scroller,
      
      /*如果contentView是Web组件时必传，必须设置WebviewController，不用设置scroller*/
      webviewController: this.webviewController,
      
      /*设置列表内容布局*/
      contentView: () => {
        this.contentView()
      },
      
      /*根据当前列表滑动距离或者其他业务逻辑判断是否可以下拉，true:可以下拉刷新，false:不能下拉*/
      onCanPullRefresh: () => {
        //判断列表是否滑到顶部
        /*默认带弹性效果的列表需要关闭弹性滑动，.edgeEffect(EdgeEffect.None)*/
        return (this.scroller.currentOffset()?.yOffset ?? 0) <= 0
      },
      
      /*根据当前列表滑动距离或者其他业务逻辑判断是否可以上拉，true:可以上拉加载，false:不能上拉*/
      onCanPullLoad: () => {
        //判断列表是否滑到底部
        return this.scroller.isAtEnd()
      },
      
      /*触发刷新*/
      onRefresh: () => {
        //可以执行刷新数据的操作
      },
      
      /*触发加载*/
      onLoad: () => {
        //可以执行加载数据的操作
      },
      
      /*下拉触发打开页面的通知*/
      onOpenPage: () => {
        //可以执行跳转页面或者其他业务逻辑操作
      },
      
      /*上拉触发打开页面的通知*/
      onLoadOpenPage: () => {
        //可以执行跳转页面或者其他业务逻辑操作
      },
    })
      .width("100%").height("100%")
  }
  @Builder
  contentView() {
    List({ scroller: this.scroller }) {
    }.width("100%").height("100%").edgeEffect(EdgeEffect.None)
  }
}
```
<span id="target-id"></span>
### RefreshLayout使用说明(可自定义扩展各种交互效果)
**默认带弹性效果的列表需要关闭弹性滑动，.edgeEffect(EdgeEffect.None)**
```text
@Component
export struct Example {
  /*RefreshLayout控制器*/
  controller: RefreshController = new RefreshController()
  
  /*RefreshLayout配置*/
  config: RefreshLayoutConfig = new RefreshLayoutConfig()
  
  /*需要将scroller设置给列表组件*/
  scroller: Scroller = new Scroller()
  
  /*webview需要配置的控制器*/
  webviewController: web.WebviewController = new web.WebviewController()

  build() {
    RefreshLayout({
      /*非必传，设置刷新配置，不设置时自动设置默认值*/
      config: this.config,
      
      /*必传，RefreshLayout控制器*/
      controller: this.controller,
      
      /*必传，设置和列表相关的Scroller，比如List,Grid,Scroll,WaterFlow等组件*/
      scroller: this.scroller,
      
      /*如果contentView是Web组件时必传，必须设置WebviewController，不用设置scroller*/
      webviewController: this.webviewController,
      
      /*1:设置header布局*/
      headerView: () => {
        this.headerView()
      },
      
      /*2：设置列表内容布局*/
      contentView: () => {
        this.contentView()
      },
      
      /*3：设置footer布局*/
      loadView: () => {
        this.loadView()
      },
      
      /*根据当前列表滑动距离或者其他业务逻辑判断是否可以下拉，true:可以下拉刷新，false:不能下拉*/
      onCanPullRefresh: () => {
        //判断列表是否滑到顶部
        /*默认带弹性效果的列表需要关闭弹性滑动，.edgeEffect(EdgeEffect.None)*/
        return (this.scroller.currentOffset()?.yOffset ?? 0) <= 0
      },
      
      /*根据当前列表滑动距离或者其他业务逻辑判断是否可以上拉，true:可以上拉加载，false:不能上拉*/
      onCanPullLoad: () => {
        //判断列表是否滑到底部
        return this.scroller.isAtEnd()
      },
      
      /*触发刷新*/
      onRefresh: () => {
        //可以执行刷新数据的操作
      },
      
      /*触发加载*/
      onLoad: () => {
        //可以执行加载数据的操作
      },
      
      /*下拉触发打开页面的通知*/
      onOpenPage: () => {
        //可以执行跳转页面或者其他业务逻辑操作
      },
      
      /*上拉触发打开页面的通知*/
      onLoadOpenPage: () => {
        //可以执行跳转页面或者其他业务逻辑操作
      },
      
      /*下拉或上拉过程状态监听，可以根据onPullListener实现自定义header和footer交互效果*/
      onPullListener: (pullDown: PullDown) => {

      }
    })
      .clip(true)//必须设置clip:true
      .width("100%").height("100%")
  }

  @Builder
  headerView() {
  }
  @Builder
  contentView() {
    List({ scroller: this.scroller }) {
    }.width("100%").height("100%").edgeEffect(EdgeEffect.None)
  }
  @Builder
  loadView() {
  }
}
```


### controller: RefreshController说明

|方法名   | 说明  |  返回值 |
|---|---|---|
| refreshSuccess() | 通知RefreshLayout刷新成功  |  无 |
| refreshError()  |  通知RefreshLayout刷新失败 |  无 |
|  refreshComplete(true or false)|  通知RefreshLayout刷新成功或者失败 |  无 |
| loadSuccess()  |  通知RefreshLayout加载成功 | 无  |
|  loadError() |  通知RefreshLayout加载失败 |  无 |
|  loadComplete(true or false) |  通知RefreshLayout加载成功或者失败 | 无  |
|  getStatus()|  获取RefreshLayout当前状态 |  PullStatus |
|  refresh() |  手动触发RefreshLayout刷新 |  无 |
|  load() | 手动触发RefreshLayout加载  | 无  |
|  refreshIsEnable() | 刷新开关是否打开  | boolean  |
|  loadIsEnable() |  加载开关是否打开 |  boolean |
|  setConfig(config: RefreshLayoutConfig) | RefreshLayout配置config  |  无 |
|  getConfig() |  获取RefreshLayout配置 |  RefreshLayoutConfig |
|  onWebviewScroll(xOffset: number, yOffset: number) |  webview专用(监听滑动距离) |  无 |


### config: RefreshLayoutConfig说明

|  属性 | 说明  |默认值  |
|---|---|---|
|  isVertical |  是否是垂直列表，true:垂直，false:横向 |  true |
|  horizontalMode | 横向模式0：正常横向布局，<br/>1：header和footer逆时针旋转90度，<br/>2：header和footer顺时针旋转90度  |  0 |
|  pullRefreshEnable |  是否打开刷新开关 | true  |
|  pullLoadEnable |  是否打开加载更多开关 |  true |
|  **刷新相关配置** |    |    |
|  releaseRefresh | 下拉达到刷新条件,是否需要释放才触发刷新  | true  |
|  pullMaxDistance |  下拉最大距离 |  500vp |
|  pullRefreshResistance |  下拉阻力，取值范围(0,1] | 0.5  |
|  pullHeaderHeightRefresh |  下拉距离超过多少时达到刷新条件<br/>小于等于0时,自动设置为header高度或者宽度的1.5倍 |  0 |
|  pullRefreshOpenPageEnable |  是否开启下拉打开其他页面开关 |  false |
|  pullHeaderHeightOpenPage |  下拉距离超过多少时达到打开其他页面条件<br/>小于等于0时,自动设置为header高度或者宽度的2.6倍  |  0 |
|  durationToHeader |  释放刷新时，回弹至headerView高度的时间 |  250ms |
|  durationCloseHeader |  headerView刷新结束时回弹的时间 |  200ms |
|  durationCloseForOpenPage |  打开其他页面时，布局的回弹时间 |  180ms |
|  refreshKeepHeader |  刷新时是否显示headerView | true  |
| refreshShowSuccess  |  是否显示刷新成功状态的view | true  |
|  refreshShowError | 是否显示刷新失败状态的view  | true  |
|  refreshResultDurationTime |  刷新结果view显示持续时间 | 600ms  |
|  **加载相关配置** |    |    |
|  releaseLoad  | 上拉达到加载条件,是否需要释放才触发加载  | true  |
|  pullLoadMaxDistance  |  上拉最大距离  |  500vp  |
|  pullLoadResistance  |   上拉阻力,取值范围(0,1] | 0.5  |
|  pullFooterHeightLoad  |  上拉距离超过多少时达到刷新条件<br/>小于等于0时,自动设置为footer高度或者宽度的1.1倍  | 0   |
|  pullLoadOpenPageEnable  |   上拉打开其他页面开关 |  false  |
|  pullFooterHeightOpenPage  |  上拉距离超过多少时达到打开其他页面条件<br/>小于等于0时,自动设置为footer高度或者宽度的2.6倍  |  0  |
|  durationToFooter  |  释放刷新时，回弹至footerView高度的时间  |  250ms  |
|  durationCloseFooter  |  footer布局刷新结束时回弹的时间  |  200ms  |
|  durationCloseLoadForOpenPage  |  打开其他页面时，布局的回弹时间  |  180ms |
|  loadKeepFooter  |  加载时是否显示footerView  |  true  |
|  loadShowSuccess  |  是否显示加载成功状态的view  |  true  |
|  loadShowError  |  是否显示加载失败状态的view  |  true  |
|   loadResultDurationTime |  加载结果view显示持续时间  |  600  |


#### PullDown说明(通过该数据可以实现个性化交互)

|  属性 |  说明 |
|---|---|
| isPullDown |  是否是下拉  |
| isPullUp |  是否是上拉  |
| isTouch |  是否触摸  |
| distance |  下拉距离vp  |
| distanceLoad |  上拉距离vp  |
| headerViewSize |   headerView高度vp<br/>headerView宽度vp(如果是横向模式，且horizontalMode==0)|
| footerViewSize |  footerView高度vp <br/>headerView宽度vp(如果是横向模式，且horizontalMode==0)|
| status |  当前PullStatus状态  |


#### PullStatus说明
|  属性 |  说明 |
|---|---|
|  DEF |  默认状态(无下拉或上拉距离) |
|  **刷新相关状态** |   |
|  PullDown |  下拉状态 |
|  PreRefresh |  下拉达到刷新条件的状态 |
|  Refresh |  正在刷新 |
|  PreOpenPage |  下拉达到打开其他页面条件 |
|  OpenPage |  打开其他页面 |
|  RefreshSuccess | 刷新成功  |
|  RefreshError | 刷新失败  |
|  **加载相关状态** |   |
| PullUp  | 上拉状态  |
|  PreLoad |  上拉达到加载条件的状态 |
| Load  | 加载中  |
| PreLoadOpenPage  | 上拉达到打开其他页面条件  |
| LoadOpenPage  |  打开其他页面 |
| LoadOpenPage  | 加载成功  |
|  LoadError |  加载失败 |

<br/>

#### PullToRefreshLayout自定义配置
```typescript
  /*刷新loading宽度*/
  public refreshLoadingWidth: Length = 25
  
  /*刷新loading高度*/
  public refreshLoadingHeight: Length = 25
  
  /*刷新loading颜色*/
  public refreshLoadingColor: ResourceColor = "#333333"
  
  /*下拉刷新箭头*/
  public arrowImage: Resource = $r("app.media.zr_refresh_arrow")
  
  /*下拉刷新箭头宽度*/
  public arrowImageWidth: Length = 20
  
  /*下拉刷新箭头高度*/
  public arrowImageHeight: Length = 20
  
  /*上拉刷新箭头*/
  public arrowLoadImage: Resource = $r("app.media.zr_refresh_arrow")
  
  /*上拉刷新箭头颜色*/
  public arrowLoadImageColor: ResourceColor = "#333333"
  
  /*上拉刷新箭头宽度*/
  public arrowLoadImageWidth: Length = 20
  
  /*上拉刷新箭头高度*/
  public arrowLoadImageHeight: Length = 20
  
  /*暂无更多提示*/
  public noMoreTips: string | Resource = $r("app.string.zr_load_no_more")
  
  /*暂无更多提示大小*/
  public noMoreTipsSize: number | string | Resource = 13
  
  /*暂无更多提示颜色*/
  public noMoreTipsColor: ResourceColor = "#666666"
  
  /*暂无更多提示——横向列表*/
  public noMoreTipsHorizontal: string | Resource = $r("app.string.h_zr_load_no_more")
  
  /*是否显示刷新时间*/
  public showRefreshTime: boolean = false
  
  /*刷新时间tips大小*/
  public refreshTimeTipsSize: number | string | Resource = 11
  
  /*刷新时间tips颜色*/
  public refreshTimeTipsColor: ResourceColor = "#999999"
  
  /*下拉刷新提示*/
  public pullDownTips: string | Resource = $r("app.string.zr_pull_down_to_refresh")
  
  /*下拉刷新提示——横向列表*/
  public pullDownTipsHorizontal: string | Resource = $r("app.string.h_zr_pull_down_to_refresh")
  
  /*下拉刷新提示大小*/
  public pullDownTipsSize: number | string | Resource = 13
  
  /*下拉刷新提示颜色*/
  public pullDownTipsColor: ResourceColor = "#666666"
  
  /*释放立即刷新tips*/
  public releaseRefreshTips: string | Resource = $r("app.string.zr_release_to_refresh")
  
  /*释放立即刷新tips——横向列表*/
  public releaseRefreshTipsHorizontal: string | Resource = $r("app.string.h_zr_release_to_refresh")
  
  /*正在刷新tips*/
  public refreshTips: string | Resource = $r("app.string.zr_refreshing")
  
  /*正在刷新tips——横向列表*/
  public refreshTipsHorizontal: string | Resource = $r("app.string.h_zr_refreshing")
  
  /*刷新成功tips*/
  public refreshSuccessTips: string | Resource = $r("app.string.zr_refresh_success")
  
  /*刷新成功tips——横向列表*/
  public refreshSuccessTipsHorizontal: string | Resource = $r("app.string.h_zr_refresh_success")
  
  /*刷新失败tips*/
  public refreshErrorTips: string | Resource = $r("app.string.zr_refresh_error")
  
  /*刷新失败tips——横向列表*/
  public refreshErrorTipsHorizontal: string | Resource = $r("app.string.h_zr_refresh_error")
  
  /*下拉打开其他页面tips*/
  public pullOpenPageTips: string | Resource = $r("app.string.zr_release_to_open_age")
  
  /*下拉打开其他页面tips——横向列表*/
  public pullOpenPageTipsHorizontal: string | Resource = $r("app.string.h_zr_release_to_open_age")
  
  /*上拉加载提示*/
  public pullUpTips: string | Resource = $r("app.string.zr_pull_up_to_load")
  
  /*上拉加载提示——横向列表*/
  public pullUpTipsHorizontal: string | Resource = $r("app.string.h_zr_pull_up_to_load")
  
  /*上拉加载提示大小*/
  public pullUpTipsSize: number | string | Resource = 13
  
  /*上拉加载提示颜色*/
  public pullUpTipsColor: ResourceColor = "#333333"
  
  /*释放立即加载tips*/
  public releaseLoadTips: string | Resource = $r("app.string.zr_release_to_load")
  
  /*释放立即加载tips——横向列表*/
  public releaseLoadTipsHorizontal: string | Resource = $r("app.string.h_zr_release_to_load")
  
  /*正在加载tips*/
  public loadTips: string | Resource = $r("app.string.zr_loading")
  
  /*正在加载tips——横向列表*/
  public loadTipsHorizontal: string | Resource = $r("app.string.h_zr_loading")
  
  /*加载成功tips*/
  public loadSuccessTips: string | Resource = $r("app.string.zr_load_success")
  
  /*加载成功tips——横向列表*/
  public loadSuccessTipsHorizontal: string | Resource = $r("app.string.h_zr_load_success")
  
  /*加载失败tips*/
  public loadErrorTips: string | Resource = $r("app.string.zr_load_error")
  
  /*加载失败tips——横向列表*/
  public loadErrorTipsHorizontal: string | Resource = $r("app.string.h_zr_load_error")
  
  /*下拉打开其他页面tips*/
  public loadOpenPageTips: string | Resource = $r("app.string.zr_release_to_open_age")

```
### 版本更新
#### 1.0.8
```typescript
@Builder
viewLoading(){
  Text("加载中(支持自定义视图)")
}

PullToRefreshLayout({
  /*设置加载中视图*/
  viewLoading:()=>{
    this.viewLoading()
  },
  /*设置加载中视图*/
  viewEmpty:()=>{
    this.viewEmpty()
  },
  /*设置加载中视图*/
  viewError:()=>{
    this.viewError()
  },
  /*设置加载中视图*/
  viewNoNetwork:()=>{
    this.viewNoNetwork()
  }
}).width("100%").layoutWeight(1).clip(true)
  
//RefreshController
//显示加载中自定义视图
this.controller.viewLoading()
//显示空视图自定义视图
this.controller.viewEmpty()
//显示加载失败自定义视图
this.controller.viewError()
//显示无网络自定义视图
this.controller.viewNoNetwork()

```
# 版本记录
### 1.1.4
1. 修复视图回弹或触摸过程中禁止下拉或上拉再次触摸视图和视图回弹异常问题

### 1.1.3
1. RefreshController新增setRefreshEnable(enable)设置开启或禁止下拉刷新api
2. RefreshController新增setLoadEnable(enable)设置开启或禁止上拉加载api


### 1.1.2
1. 新增属性支持外部设置PullToRefreshLayout的clip属性

### 1.1.1
1. 修复context is invalid问题

### 1.1.0
1. 组件挂载之前可以设置页面状态

### 1.0.9
1. 解决刷新成功缺省页面无法切换问题

### 1.0.8
1. 增加自定义缺省页方法(刷新中、数据为空、刷新失败、无网络)

### 1.0.7
1. RefreshController增加取消刷新、取消加载方法

### 1.0.6
1. PullToRefreshConfig增加下拉刷新上拉加载箭头颜色配置

### 1.0.5
1. RefreshLayout刷新成功后默认不修改是否还有更多状态

### 1.0.4
1. PullToRefreshLayout增加简单的自定义配置

### 1.0.3
1. 触发刷新成功失败或加载成功失败之前增加是否是刷新中或者加载中状态判断

### 1.0.2
1. 补充README说明

### 1.0.1
1. 解决release包获取资源崩溃问题

### 1.0.0 初版
1. 发布1.0.0初版。


#### 开源协议
本项目基于 [MIT license](https://gitee.com/zhongrui_developer/PullToRefresh/blob/master/LICENSE) ，请自由地享受和参与开源。