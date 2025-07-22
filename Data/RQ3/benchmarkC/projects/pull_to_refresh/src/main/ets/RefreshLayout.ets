import BuildProfile from '../../../BuildProfile'
import { RefreshLayoutConfig } from './RefreshLayoutConfig'
import { RefreshLayoutHelper, _ContentView, _headerView, _loadMoreView, _noMoreView } from './RefreshLayoutHelper'
import { AnimatorResult } from '@kit.ArkUI'
import animator from '@ohos.animator'
import { PullStatus } from './PullStatus'
import { RefreshController, ViewState } from './RefreshController'
import { PullDown } from './PullDown'
import web from '@ohos.web.webview'

@Component
export struct RefreshLayout {
  public debug: boolean = BuildProfile.DEBUG
  /*下拉刷新逻辑处理*/
  private helper: RefreshLayoutHelper = new RefreshLayoutHelper()
  /*****************************************对外提供属性******************************************************/
  public scroller: Scroller | undefined = undefined
  public webviewController: web.WebviewController | undefined = undefined
  public controller: RefreshController = new RefreshController()
  //头布局视图
  @Require @BuilderParam headerView: () => void = _headerView
  //内容视图
  @Require @BuilderParam contentView: () => void = _ContentView
  //加载更多视图
  @BuilderParam loadView: () => void = _loadMoreView
  //暂无更多视图
  @BuilderParam noMoreView: () => void = _noMoreView

  //正在加载视图
  @BuilderParam viewLoading?: () => void
  //空视图
  @BuilderParam viewEmpty?: () => void
  //加载错误视图
  @BuilderParam viewError?: () => void
  //无网络视图
  @BuilderParam viewNoNetwork?: () => void
  /*是否可以下拉刷新*/
  public onCanPullRefresh: () => boolean = () => true
  /*刷新通知*/
  public onRefresh: () => void = () => {
  }
  /*加载通知*/
  public onLoad: () => void = () => {
  }
  /*是否可以上拉加载*/
  public onCanPullLoad: () => boolean = () => false //todo
  /*下拉状态监听*/
  public onPullListener: (pullDown: PullDown) => void = () => {
  }
  /*打开页面通知*/
  public onOpenPage: () => void = () => {
  }
  /*打开页面通知*/
  public onLoadOpenPage: () => void = () => {
  }
  /*下拉刷新配置*/
  public config: RefreshLayoutConfig = new RefreshLayoutConfig()
  /***********************************************************************************************/
  /*下拉或右拉总偏移量*/
  @State currentOffset: number = 0
  /*当前状态*/
  @State status: PullStatus = PullStatus.DEF
  /*上拉或左拉总偏移量*/
  @State currentOffsetLoad: number = 0
  /*是否有更多数据*/
  @State hasMore: boolean = true

  /*防止重复挂载，这里通过多个变量动态控制挂载，显示，隐藏*/
  @State viewSuccessState:number=1
  @State viewLoadingState:number=0
  @State viewEmptyState:number=0
  @State viewErrorState:number=0
  @State viewNoNetworkState:number=0

  /***********************************************************************************************/
  //region onMeasureSize
  private log(str: string, tag: string = "RefreshLayout") {
    if (!this.debug) {
      return
    }
    console.debug(tag + "==" + str)
  }
  private setViewLoadSuccessState(){
    this.viewSuccessState=1
    /*不等于0才修改值*/
    if(this.viewLoadingState){
      this.viewLoadingState=2
    }
    if(this.viewEmptyState){
      this.viewEmptyState=2
    }
    if(this.viewErrorState){
      this.viewErrorState=2
    }
    if(this.viewNoNetworkState){
      this.viewNoNetworkState=2
    }
  }
  private setViewLoadingState(){
    this.viewLoadingState=1
    if(this.viewEmptyState){
      this.viewEmptyState=2
    }
    if(this.viewErrorState){
      this.viewErrorState=2
    }
    if(this.viewNoNetworkState){
      this.viewNoNetworkState=2
    }
    this.viewSuccessState=0
  }
  private setViewLoadEmptyState(){
    if(this.viewLoadingState){
      this.viewLoadingState=2
    }
    this.viewEmptyState=1
    if(this.viewErrorState){
      this.viewErrorState=2
    }
    if(this.viewNoNetworkState){
      this.viewNoNetworkState=2
    }
    this.viewSuccessState=0
  }
  private setViewLoadErrorState(){
    if(this.viewLoadingState){
      this.viewLoadingState=2
    }
    if(this.viewEmptyState){
      this.viewEmptyState=2
    }
    this.viewErrorState=1
    if(this.viewNoNetworkState){
      this.viewNoNetworkState=2
    }
    this.viewSuccessState=0
  }
  private setViewLoadNoNetworkState(){
    if(this.viewLoadingState){
      this.viewLoadingState=2
    }
    if(this.viewEmptyState){
      this.viewEmptyState=2
    }
    if(this.viewErrorState){
      this.viewErrorState=2
    }
    this.viewNoNetworkState=1
    this.viewSuccessState=0
  }

  private sizeResult: SizeResult = { width: 0, height: 0 }

  onMeasureSize(selfLayoutInfo: GeometryInfo, children: Measurable[], constraint: ConstraintSizeOptions): SizeResult {
    // this.log("======onAppear=1")
    const count = children.length
    if (typeof (constraint.maxWidth) == "number") {
      this.sizeResult.width = constraint.maxWidth as number;
    }
    if (typeof (constraint.maxHeight) == "number") {
      this.sizeResult.height = constraint.maxHeight as number;
    }
    for (let i = 0; i < count; i++) {
      const result = children[i].measure(constraint)
      if (i == 0) {
        if (this.config.isVertical || this.config.horizontalMode == 1 || this.config.horizontalMode == 2) {
          /*保存header高度*/
          this.helper.headerSize = result.height
        } else {
          /*保存header宽度*/
          this.helper.headerSize = result.width
        }
      } else if (i == 1 && (this.sizeResult.width <= 0 || this.sizeResult.height <= 0)) {
        this.sizeResult.width = result.width;
        this.sizeResult.height = result.height;
      } else if (i == 2) {
        if (this.config.isVertical || this.config.horizontalMode == 1 || this.config.horizontalMode == 2) {
          /*保存footer高度*/
          this.helper.footerSize = result.height
        } else {
          /*保存footer宽度*/
          this.helper.footerSize = result.width
        }
      }
    }
    return this.sizeResult
  }

  onPlaceChildren(selfLayoutInfo: GeometryInfo, children: Layoutable[], constraint: ConstraintSizeOptions): void {
    let count = children.length
    if (count <= 0) {
      return
    }
    for (let i = 0; i < count; i++) {
      const child = children[i]
      if (i == 0) {
        /*header*/
        // this.helper.initOffsetY = -child.measureResult.height
        if (this.config.isVertical) {
          child.layout({ y: -child.measureResult.height })
        } else {
          if (this.config.horizontalMode == 1 || this.config.horizontalMode == 2) {
            child.layout({
              x: -child.measureResult.width / 2 - child.measureResult.height / 2,
              y: this.sizeResult.height / 2 - child.measureResult.height / 2
            })
          } else {
            child.layout({ x: -child.measureResult.width })
          }
        }
      } else if (i == 1) {
        /*content*/
        child.layout({})
      } else if (i == 2) {
        /*footer*/
        if (this.config.isVertical) {
          child.layout({ y: this.sizeResult.height })
        } else {
          if (this.config.horizontalMode == 1 || this.config.horizontalMode == 2) {
            child.layout({
              x: this.sizeResult.width - child.measureResult.width / 2 + child.measureResult.height / 2,
              y: this.sizeResult.height / 2 - child.measureResult.height / 2
            })
          } else {
            child.layout({ x: this.sizeResult.width })
          }
        }
      }
    }
  }

  build() {
    this.headerAndContent()
  }

  // endregion
  /***********************************************************************************************/


  /*****************************************下拉刷新******************************************************/
  /*释放刷新回弹至header动画*/
  private anim: AnimatorResult | undefined = animator.create(this.helper.animOptions);
  /*回弹动画暂停*/
  private animPause = false
  private setDefStatusId = 0;
  /*自动刷新动画*/
  private autoRefreshAnim: AnimatorResult | undefined = undefined
  /*记录动画执行进度，在回弹至header高度过程中记录已经执行了多少进度，方便在回弹header高度之前收到刷新或者加载成功的结果后，再执行剩余时间的动画*/
  private animProgress: number = 1
  /******************************************上拉加载*****************************************************/
  /*释放加载回弹至footer动画*/
  private animLoad: AnimatorResult | undefined = undefined
  /*回弹动画暂停*/
  private animLoadPause = false
  private setDefLoadStatusId = 0;
  /*自动刷新动画*/
  private autoLoadAnim: AnimatorResult | undefined = undefined
  /*记录动画执行进度，在回弹至header高度过程中记录已经执行了多少进度，方便在回弹header高度之前收到刷新或者加载成功的结果后，再执行剩余时间的动画*/
  private animProgressLoad: number = 1

  aboutToAppear(): void {
    /*刷新成功*/
    this.controller.refreshSuccess = (ignoreViewTips?:boolean) => {
      this.refreshSuccess(ignoreViewTips)
    }
    /*刷新失败*/
    this.controller.refreshError = () => {
      this.refreshError()
    }
    /*通过参数通知刷新结果*/
    this.controller.refreshComplete = (isSuccess: boolean,ignoreViewTips?:boolean) => {
      this.refreshComplete(isSuccess,ignoreViewTips)
    }
    /*刷新取消*/
    this.controller.refreshCancel = () => {
      this.refreshCancel()
    }

    /*刷新成功*/
    this.controller.loadSuccess = (hasMore?: boolean) => {
      this.loadSuccess(hasMore)
    }
    /*刷新失败*/
    this.controller.loadError = () => {
      this.loadError()
    }
    /*通过参数通知加载结果*/
    this.controller.loadComplete = (isSuccess: boolean, hasMore?: boolean) => {
      this.loadComplete(isSuccess, hasMore)
    }
    /*加载取消*/
    this.controller.loadCancel = () => {
      this.loadCancel()
    }
    /*设置当前是否还有更多*/
    this.controller.hasMore = (hasMore: boolean) => {
      this.hasMore = hasMore
    }
    /*获取当前状态*/
    this.controller.getStatus = () => {
      return this.status
    }
    /*自动刷新*/
    this.controller.refresh = () => {
      this.autoRefresh()
    }
    /*自动加载*/
    this.controller.load = () => {
      this.autoLoad()
    }
    /*是否开启刷新*/
    this.controller.refreshIsEnable = () => {
      return this.config.pullRefreshEnable
    }
    this.controller.setRefreshEnable=(enable:boolean)=>{
      this.config.pullRefreshEnable=enable
    }
    /*是否开启加载*/
    this.controller.loadIsEnable = () => {
      return this.config.pullLoadEnable
    }
    this.controller.setLoadEnable=(enable:boolean)=>{
      this.config.pullLoadEnable=enable
    }
    /*设置配置*/
    this.controller.setConfig = (config: RefreshLayoutConfig) => {
      this.config = config
    }
    this.controller.getConfig = () => this.config
    /*webView专用*/
    this.controller.onWebviewScroll = (xOffset, yOffset) => {
      this.helper.webViewXOffset = xOffset;
      this.helper.webViewYOffset = yOffset
    }
    const viewState=this.controller.getViewState()
    if(viewState==ViewState.loading){
      this.setViewLoadingState()
    }else if(viewState==ViewState.empty){
      this.setViewLoadEmptyState()
    }else if(viewState==ViewState.error){
      this.setViewLoadErrorState()
    }else if(viewState==ViewState.noNetwork){
      this.setViewLoadNoNetworkState()
    }
    this.controller.viewLoading=()=>{
      if(this.viewLoading){
        this.setViewLoadingState()
      }
    }

    this.controller.viewEmpty=()=>{
      if(this.viewEmpty){
        this.setViewLoadEmptyState()
      }
    }

    this.controller.viewError=()=>{
      if(this.viewError){
        this.setViewLoadErrorState()
      }
    }

    this.controller.viewNoNetwork=()=>{
      if(this.viewNoNetwork){
        this.setViewLoadNoNetworkState()
      }
    }


    this.helper.debug = this.debug
    this.setAnimListener()
  }

  aboutToDisappear(): void {
    //按照官方示例，置空处理防止内存泄漏
    this.anim = undefined
    this.autoRefreshAnim = undefined

    this.animLoad = undefined
  }

  private setAnimListener() {
    if (!this.anim) {
      return
    }
    this.anim.onFrame = (progress: number) => {
      if (this.animPause) {
        return
      }
      this.animProgress = progress
      this.currentOffset = this.helper.totalOffset * (1 - progress)
    }
    this.anim.onFinish = () => {
      this.animProgress = 1
      /*如果是回弹至header高度结束，开始判断是否是刷新完成或失败状态，继续回弹动画*/
      if (this.status == PullStatus.RefreshSuccess || this.status == PullStatus.RefreshError) {
        if (this.currentOffset > 0) {
          //开始隐藏header动画
          this.hiddenHeaderAnim()
        } else if (this.currentOffset <= 0) {
          /*如果动画结束，需要改变状态*/
          this.setDefStatus()
        }
        /*状态监听*/
        this.pullDownListener({
          isPullDown: false,
          isPullUp: false,
          isTouch: this.helper.isPressDown,
          distance: this.currentOffset,
          distanceLoad: this.currentOffsetLoad,
          headerViewSize: this.helper.headerSize,
          footerViewSize: this.helper.footerSize,
          status: this.status
        }, 0)
        return
      }
      if (this.helper.notReleaseRefresh && this.currentOffset <= 0) {
        /*非释放刷新，在刷新完成后，需要改变状态，否则非释放刷新时不松手，刷新完成后再下拉没反应*/
        this.helper.notReleaseRefresh = false
      }
      this.helper.totalOffset = this.currentOffset;
      this.changeStatus(this.currentOffset)
      /*状态监听*/
      this.pullDownListener({
        isPullDown: false,
        isPullUp: false,
        isTouch: this.helper.isPressDown,
        distance: this.currentOffset,
        distanceLoad: this.currentOffsetLoad,
        headerViewSize: this.helper.headerSize,
        footerViewSize: this.helper.footerSize,
        status: this.status
      }, 1)
    }
    this.anim.oncancel = () => {
      this.helper.totalOffset = this.currentOffset;
    }
  }

  //用于上拉加载更多
  private initLoadAnim() {
    if (this.animLoad) {
      return
    }
    this.animLoad = animator.create(this.helper.animLoadOptions);
    this.animLoad.onFrame = (progress: number) => {
      if (this.animLoadPause) {
        return
      }
      this.animProgressLoad = progress
      this.currentOffsetLoad = this.helper.totalOffsetLoad * (1 - progress)
    }
    this.animLoad.onFinish = () => {
      this.animProgressLoad = 1
      /*如果是回弹至header高度结束，开始判断是否是刷新完成或失败状态，继续回弹动画*/
      if (this.status == PullStatus.LoadSuccess || this.status == PullStatus.LoadError) {
        if (this.currentOffsetLoad < 0) {
          //开始隐藏footer动画
          this.hiddenFooterAnim()
        } else if (this.currentOffsetLoad <= 0) {
          /*如果动画结束，需要改变状态*/
          this.setDefStatusLoad()
        }
        /*状态监听*/
        this.pullDownListener({
          isPullDown: false,
          isPullUp: false,
          isTouch: this.helper.isPressDown,
          distance: this.currentOffset,
          distanceLoad: this.currentOffsetLoad,
          headerViewSize: this.helper.headerSize,
          footerViewSize: this.helper.footerSize,
          status: this.status
        }, 2)
        return
      }
      if (this.helper.notReleaseLoad && this.currentOffsetLoad >= 0) {
        /*非释放加载，在加载完成后，需要改变状态，否则非释放加载时不松手，加载完成后再上拉没反应*/
        this.helper.notReleaseLoad = false
      }
      this.helper.totalOffsetLoad = this.currentOffsetLoad;
      this.changeStatusLoad(this.currentOffsetLoad)
      /*状态监听*/
      this.pullDownListener({
        isPullDown: false,
        isPullUp: false,
        isTouch: this.helper.isPressDown,
        distance: this.currentOffset,
        distanceLoad: this.currentOffsetLoad,
        headerViewSize: this.helper.headerSize,
        footerViewSize: this.helper.footerSize,
        status: this.status
      }, 3)
    }
    this.animLoad.oncancel = () => {
      this.helper.totalOffsetLoad = this.currentOffsetLoad;
    }
  }

  private getHeaderOffsetY() {
    return this.currentOffset;
  }

  private getFooterOffsetY() {
    return this.currentOffsetLoad;
  }

  /*下拉高度触发刷新*/
  public getPullRefreshHeaderHeight(): number {
    if (this.config.pullHeaderHeightRefresh <= 0) {
      this.config.pullHeaderHeightRefresh = this.helper.headerSize * 1.5
    }
    return this.config.pullHeaderHeightRefresh
  }

  /*下拉高度触发打开页面*/
  public getPullOpenPageHeight(): number {
    if (this.config.pullHeaderHeightOpenPage <= this.getPullRefreshHeaderHeight()) {
      this.config.pullHeaderHeightOpenPage = this.helper.headerSize * 2.6
    }
    return this.config.pullHeaderHeightOpenPage
  }

  /*上拉高度触发加载*/
  public getPullLoadFooterHeight(): number {
    if (this.config.pullFooterHeightLoad <= 0) {
      this.config.pullFooterHeightLoad = this.helper.footerSize * 1.1
    }
    return this.config.pullFooterHeightLoad
  }

  /*上拉高度触发打开页面*/
  public getPullLoadOpenPageHeight(): number {
    if (this.config.pullFooterHeightOpenPage <= this.getPullLoadFooterHeight()) {
      this.config.pullFooterHeightOpenPage = this.helper.footerSize * 2.6
    }
    return this.config.pullFooterHeightOpenPage
  }

  private getAngle() {
    if (this.config.isVertical) {
      return 0
    }
    /*横向模式0：正常横向布局，1：header和footer逆时针旋转90度，2：header和footer顺时针旋转90度*/
    if (this.config.horizontalMode == 1) {
      return -90
    } else if (this.config.horizontalMode == 2) {
      return 90
    }
    return 0
  }
  /*是否是垂直列表或者布局旋转后的横向header或footer*/
  private isVerticalLayout(): boolean {
    return (this.config.isVertical || this.config.horizontalMode == 1 || this.config.horizontalMode == 2)
  }

  /***********************************************************************************************/
  @Builder
  private headerAndContent() {
    Stack() {
      this.headerView()
    }
    .onAppear(() => {
      // this.totalOffsetY = this.helper.initOffsetY
      this.getPullRefreshHeaderHeight()
      this.getPullOpenPageHeight()
    })
    .offset({
      y: this.config.isVertical ? this.getHeaderOffsetY() + this.getFooterOffsetY() : 0,
      x: this.config.isVertical ? 0 : this.getHeaderOffsetY() + this.getFooterOffsetY()
    })
    .rotate({ angle: this.getAngle(), z: 1, x: 0, y: 0 })
    .width(this.isVerticalLayout() ? "100%" : "auto")
    .height(this.isVerticalLayout() ? "auto" : "100%")

    // .borderWidth(2)
    // .borderColor(Color.Black)

    Stack() {
      /*正在加载中视图*/
      if(this.viewLoading&&this.viewLoadingState){
        Stack(){
          this.viewLoading()
        }.width("100%").height("100%").visibility(this.viewLoadingState==1?Visibility.Visible:Visibility.Hidden)
      }
      /*空数据视图*/
      if(this.viewEmpty&&this.viewEmptyState){
        Stack(){
          this.viewEmpty()
        }.width("100%").height("100%").visibility(this.viewEmptyState==1?Visibility.Visible:Visibility.Hidden)
      }
      /*数据加载失败视图*/
      if(this.viewError&&this.viewErrorState){
        Stack(){
          this.viewError()
        }.width("100%").height("100%").visibility(this.viewErrorState==1?Visibility.Visible:Visibility.Hidden)
      }
      /*无网络视图*/
      if(this.viewNoNetwork&&this.viewNoNetworkState){
        Stack(){
          this.viewNoNetwork()
        }.width("100%").height("100%").visibility(this.viewNoNetworkState==1?Visibility.Visible:Visibility.Hidden)
      }
      Stack(){
        this.contentView()
      }.width("100%").height("100%").visibility(this.viewSuccessState==1?Visibility.Visible:Visibility.Hidden)
    }
    .offset({
      y: this.config.isVertical ? this.getHeaderOffsetY() + this.getFooterOffsetY() : 0,
      x: this.config.isVertical ? 0 : this.getHeaderOffsetY() + this.getFooterOffsetY()
    })
    // .borderWidth(2)
    // .borderColor(Color.Red)
    .width("100%")
    .height("100%")
    .onTouch((event: TouchEvent) => {
      if (this.status == PullStatus.OpenPage) {
        /*下拉打开其他页面回弹结束前不响应事件*/
        return;
      }
      if (this.status == PullStatus.LoadOpenPage) {
        /*上拉打开其他页面回弹结束前不响应事件*/
        return;
      }
      if (event.type == TouchType.Down) {
        if (!this.config.pullRefreshEnable||!this.config.pullLoadEnable) {
          /*禁用下拉刷新不响应事件*/
          return
        }
        //todo 临时方案，后续等官方增加事件拦截后再替换
        if (this.currentOffset > 0 || this.currentOffsetLoad < 0) {
          //因为通过Scroller.scrollTo不让列表滑动，这里提前记录当前滑动距离，后面判断最大值(回弹期间快速松手，回弹完成之前再按下，需要记录grid列表当前滑动距离，防止上拉再下拉时列表跟随滚动)
          if (this.scroller) {
            /*其他列表记录当前滑动距离*/
            if (this.config.isVertical) {
              /*垂直列表*/
              this.helper.scrollerOffset = this.scroller?.currentOffset()?.yOffset ?? 0
            } else {
              /*水平列表*/
              this.helper.scrollerOffset = this.scroller?.currentOffset()?.xOffset ?? 0
            }
          } else if (this.webviewController) {
            /*webview记录当前滑动距离*/
            this.helper.scrollerOffset = this.config.isVertical ? this.helper.webViewYOffset : this.helper.webViewXOffset
          }
        }


        this.helper.isPressDown = true
        /*暂停下拉刷新相关动画*/
        this.pauseAnim()
        /*暂停上拉加载相关动画*/
        this.pauseAnimLoad()
        if (this.status == PullStatus.RefreshSuccess || this.status == PullStatus.RefreshError) {
          /*刷新中，或者刷新完成，此时触摸暂停动画，但是状态还是需要继续改变*/
          this.setDefAfterRefreshEnd(this.config.refreshResultDurationTime)
        } else if (this.status == PullStatus.LoadSuccess || this.status == PullStatus.LoadError) {
          /*加载中，或者加载完成，此时触摸暂停动画，但是状态还是需要继续改变*/
          this.setDefAfterLoadEnd(this.config.loadResultDurationTime)
        }

        /*状态监听*/
        this.pullDownListener({
          isPullDown: false,
          isPullUp: false,
          isTouch: true,
          distance: this.currentOffset,
          distanceLoad: this.currentOffsetLoad,
          headerViewSize: this.helper.headerSize,
          footerViewSize: this.helper.footerSize,
          status: this.status
        }, 4)
      } else if (event.type == TouchType.Up || event.type == TouchType.Cancel) {
        this.helper.scrollerOffset = 0
        this.helper.notReleaseRefresh = false
        this.helper.notReleaseLoad = false
        /*刷新完成状态，开始倒计时重置状态时，正好触发down事件，如果在倒计时结束之前this.currentOffsetY>0触发了up或者cancel事件，则需要取消，否则在回弹期间会突然改变状态*/
        /*下拉刷新相关*/
        if (this.setDefStatusId != 0 && this.currentOffsetLoad > 0) {
          clearTimeout(this.setDefStatusId)
          this.setDefStatusId = 0
        }
        /*同上*/
        /*上拉加载相关*/
        if (this.setDefLoadStatusId != 0 && this.currentOffsetLoad < 0) {
          clearTimeout(this.setDefLoadStatusId)
          this.setDefLoadStatusId = 0
        }

        this.helper.isPressDown = false
        this.animLoadPause = false
        this.animPause = false

        if (this.currentOffset > 0 || (this.currentOffset == 0 && !this.isLoadStatus())) {
          /*是否关闭下拉刷新*/
          // if (this.config.pullRefreshEnable) {
            /*如果处于加载相关的状态，则不需要执行该方法*/
            this.releaseActionByRefresh()
          // }
        } else if (this.currentOffsetLoad <= 0) {
          /*是否关闭上拉加载*/
          // if (this.config.pullLoadEnable) {
            this.releaseActionByLoad()
          // }
        }


        /*状态监听*/
        this.pullDownListener({
          isPullDown: false,
          isPullUp: false,
          isTouch: false,
          distance: this.currentOffset,
          distanceLoad: this.currentOffsetLoad,
          headerViewSize: this.helper.headerSize,
          footerViewSize: this.helper.footerSize,
          status: this.status
        }, 5)
      }
    })
    .parallelGesture(PanGesture(new PanGestureOptions(this.config.isVertical ? {
      direction: PanDirection.Down | PanDirection.Up
    } : { direction: PanDirection.Horizontal }))
      .onActionStart((event: GestureEvent) => {
        if (this.status == PullStatus.OpenPage) {
          /*打开其他页面回弹结束前不响应事件*/
          return;
        }
        if (this.status == PullStatus.LoadOpenPage) {
          /*打开其他页面回弹结束前不响应事件*/
          return;
        }
        this.helper.preOffset = this.getOffset(event)
      })
      .onActionUpdate((event: GestureEvent) => {
        if (this.getOffset(event) == this.helper.preOffset) {
          /*如果没有偏移量*/
          return
        }
        const pullDown = this.getOffset(event) > this.helper.preOffset
        /*下拉刷新相关动作*/
        //因为下拉之后可以上拉，所以增加this.currentOffsetY>0判断
        if ((pullDown || this.currentOffset > 0) && (this.currentOffsetLoad >= 0)) { //如果加载视图屏幕不可见，才允许下拉
          /*关闭下拉刷新*/
          if (pullDown&&!this.config.pullRefreshEnable) {
            /*如果是在下拉过程才需要禁用下拉动作，如果下拉再上滑不需要禁用*/
            this.helper.preOffset = this.getOffset(event)
            return
          }
          /*下拉后可以往上拉，所以需要event.offsetY > this.helper.preOffsetY判断，onCanPullRefresh需要配合下拉动作，这里如果是上拉动作，就不需要判断onCanPullRefresh*/
          if (pullDown && !this.onCanPullRefresh?.()&&this.viewSuccessState==1) {
            this.helper.preOffset = this.getOffset(event)
            /*不可以下拉*/
            return
          }
          //todo 临时方案，后续等官方增加事件拦截后再替换
          if (this.currentOffset > 0 && !pullDown) {
            /*如果下拉再上拉，不让列表滑动*/
            if (this.scroller) {
              /*其他列表*/
              if (this.config.isVertical) {
                this.scroller.scrollTo({ yOffset: 0, xOffset: this.scroller.currentOffset()?.xOffset ?? 0 })
              } else {
                this.scroller.scrollTo({ yOffset: this.scroller.currentOffset()?.yOffset ?? 0, xOffset: 0 })
              }
            } else if (this.webviewController) {
              /*webview*/
              if (this.config.isVertical) {
                this.webviewController.scrollTo(this.helper.webViewXOffset, 0)
              } else {
                this.webviewController.scrollTo(0, this.helper.webViewYOffset)
              }
            }
          }
          /*如果正在加载中，加载成功或失败，不允许下拉*/
          if (this.status == PullStatus.Load || this.status == PullStatus.LoadSuccess || this.status == PullStatus.LoadError) {
            return
          }
          this.actionUpdateForRefresh(event)

          return
        }
        /*上拉加载相关动作*/
        if (!pullDown || this.currentOffsetLoad < 0) {
          /*关闭上拉加载*/
          if (!pullDown&&!this.config.pullLoadEnable) {
            /*如果是在上拉过程才需要禁用上拉动作，如果上滑再下拉不需要禁用*/
            this.helper.preOffset = this.getOffset(event)
            return
          }
          //todo 临时方案，后续等官方增加事件拦截后再替换
          if (this.onCanPullLoad?.()) {
            //因为通过Scroller.scrollTo不让列表滑动，这里提前记录当前滑动距离，后面判断最大值
            if (this.scroller) {
              /*其他列表*/
              if (this.config.isVertical) {
                /*垂直列表*/
                this.helper.scrollerOffset = this.scroller?.currentOffset()?.yOffset ?? 0
              } else {
                /*水平列表*/
                this.helper.scrollerOffset = this.scroller?.currentOffset()?.xOffset ?? 0
              }
            } else if (this.webviewController) {
              /*webview*/
              this.helper.scrollerOffset = this.config.isVertical ? this.helper.webViewYOffset : this.helper.webViewXOffset
            }
          }
          /*上拉后可以往下拉，所以需要event.offsetY < this.helper.preOffsetYLoad判断，onCanPullLoad需要配合上拉动作，这里如果是下拉动作，就不需要判断onCanPullLoad*/
          if (!pullDown && !this.onCanPullLoad?.()) {
            this.helper.preOffset = this.getOffset(event)
            /*不可以上拉*/
            return
          }
          //todo 临时方案，后续等官方增加事件拦截后再替换
          if (this.currentOffsetLoad < 0 && pullDown) {
            /*如果下拉再上拉，不让列表滑动*/
            if (this.scroller) {
              /*其他列表*/
              let offset = this.scroller.currentOffset()
              if (offset) {
                /*判断垂直还是水平列表*/
                if (this.config.isVertical) {
                  this.scroller.scrollTo({
                    yOffset: Math.max(this.helper.scrollerOffset, this.config.isVertical ? offset.yOffset : offset.xOffset),
                    xOffset: offset.xOffset
                  })
                } else {
                  this.scroller.scrollTo({
                    yOffset: offset.yOffset,
                    xOffset: Math.max(this.helper.scrollerOffset, this.config.isVertical ? offset.yOffset : offset.xOffset)
                  })
                }
              }
            } else if (this.webviewController) {
              /*webview*/
              if (this.config.isVertical) {
                this.webviewController.scrollTo(this.helper.webViewXOffset, this.helper.scrollerOffset)
              } else {
                this.webviewController.scrollTo(this.helper.scrollerOffset, this.helper.webViewYOffset)
              }
            }
          }
          /*如果正在刷新中，加载成功或失败，不允许下拉*/
          if (this.status == PullStatus.Refresh || this.status == PullStatus.RefreshSuccess || this.status == PullStatus.RefreshError) {
            return
          }
          this.actionUpdateForLoad(event)
          return
        }
      })
      .onActionEnd((event: GestureEvent) => {
        // this.releaseAction()
      })
      .onActionCancel(() => {
        // this.releaseAction()
      }))


    Stack() {
      if (this.hasMore||this.status==PullStatus.PreLoadOpenPage||this.status==PullStatus.LoadOpenPage) {
        this.loadView()
      } else {
        this.noMoreView()
      }
    }
    .onAppear(() => {
      this.getPullLoadFooterHeight()
      this.getPullLoadOpenPageHeight()
    })
    .offset({
      y: this.config.isVertical ? this.getFooterOffsetY() : 0,
      x: this.config.isVertical ? 0 : this.getFooterOffsetY()
    })
    .rotate({ angle: this.getAngle(), z: 1, x: 0, y: 0 })
    .width(this.isVerticalLayout() ? "100%" : "auto")
    .height(this.isVerticalLayout() ? "auto" : "100%")

    // .borderWidth(2)
    // .borderColor(Color.Black)

  }

  private getOffset(event: GestureEvent) {
    if (this.config.isVertical) {
      return event.offsetY
    } else {
      return event.offsetX
    }
  }

  /*下拉刷新*/
  private actionUpdateForRefresh(event: GestureEvent) {
    /*如果触发了非释放刷新，需要在up事件中改变状态*/
    if (this.helper.notReleaseRefresh) {
      /*非释放刷新过程中，继续下拉，需要保存当前偏移量，(否则保存的是刚触发刷新时的偏移量)，等刷新完成后，防止出现headerView闪动情况*/
      this.helper.preOffset = this.getOffset(event)
      return
    }
    if (this.status == PullStatus.OpenPage) {
      /*打开其他页面回弹结束前不响应事件*/
      return;
    }
    if (this.config.pullRefreshResistance < 0) {
      this.config.pullRefreshResistance = 0.5
    } else if (this.config.pullRefreshResistance > 1) {
      this.config.pullRefreshResistance = 1
    }
    this.currentOffset = this.currentOffset + (this.getOffset(event) - this.helper.preOffset) * this.config.pullRefreshResistance
    if (this.currentOffset < 0) {
      this.currentOffset = 0;
    } else if (this.currentOffset > this.config.pullMaxDistance) {
      this.currentOffset = this.config.pullMaxDistance
    }
    this.changeStatus(this.currentOffset)
    /*状态监听*/
    this.pullDownListener({
      isPullDown: this.currentOffset > this.helper.totalOffset,
      isPullUp: this.currentOffsetLoad < this.helper.totalOffsetLoad,
      isTouch: true,
      distance: this.currentOffset,
      distanceLoad: this.currentOffsetLoad,
      headerViewSize: this.helper.headerSize,
      footerViewSize: this.helper.footerSize,
      status: this.status
    }, 6)
    this.helper.totalOffset = this.currentOffset
    this.helper.preOffset = this.getOffset(event)
    /*是否是下拉不用up事件触发刷新*/
    if (!this.config.releaseRefresh) {
      if (this.currentOffset >= this.getPullRefreshHeaderHeight() && this.status != PullStatus.Refresh && this.status != PullStatus.RefreshSuccess && this.status != PullStatus.RefreshError) {
        this.helper.notReleaseRefresh = true
        //自动触发刷新，改变动画暂停状态
        this.animPause = false
        this.releaseActionByRefresh()
        return
      }
    }
  }

  /*加载更多*/
  private actionUpdateForLoad(event: GestureEvent) {
    /*如果触发了非释放加载，需要在up事件中改变状态*/
    if (this.helper.notReleaseLoad) {
      /*非释放加载过程中，继续上拉，需要保存当前偏移量，(否则保存的是刚触发加载时的偏移量)，等加载完成后，防止出现footerView闪动情况*/
      this.helper.preOffset = this.getOffset(event)
      return
    }
    if (this.status == PullStatus.LoadOpenPage) {
      /*打开其他页面回弹结束前不响应事件*/
      return;
    }
    if (this.config.pullLoadResistance < 0) {
      this.config.pullLoadResistance = 0.5
    } else if (this.config.pullLoadResistance > 1) {
      this.config.pullLoadResistance = 1
    }
    this.currentOffsetLoad = this.currentOffsetLoad + (this.getOffset(event) - this.helper.preOffset) * this.config.pullLoadResistance
    if (this.currentOffsetLoad > 0) {
      this.currentOffsetLoad = 0;
    } else if (-this.currentOffsetLoad > this.config.pullLoadMaxDistance) {
      this.currentOffsetLoad = -this.config.pullLoadMaxDistance
    }
    this.changeStatusLoad(this.currentOffsetLoad)
    /*状态监听*/
    this.pullDownListener({
      isPullDown: this.currentOffset > this.helper.totalOffset,
      isPullUp: this.currentOffsetLoad < this.helper.totalOffsetLoad,
      isTouch: true,
      distance: this.currentOffset,
      distanceLoad: this.currentOffsetLoad,
      headerViewSize: this.helper.headerSize,
      footerViewSize: this.helper.footerSize,
      status: this.status
    }, 7)
    this.helper.totalOffsetLoad = this.currentOffsetLoad
    this.helper.preOffset = this.getOffset(event)

    if (this.hasMore) {
      /*如果有更多数据*/
      /*是否是下拉不用up事件触发刷新*/
      if (!this.config.releaseLoad) {
        if (-this.currentOffsetLoad >= this.getPullLoadFooterHeight() && this.status != PullStatus.Load && this.status != PullStatus.LoadSuccess && this.status != PullStatus.LoadError) {
          this.helper.notReleaseLoad = true
          //自动触发刷新，改变动画暂停状态
          this.animLoadPause = false
          this.releaseActionByLoad()
          return
        }
      }
    }
  }

  private pullDownListener(pullDown: PullDown, flag: number = 0) {
    /*状态监听*/
    this.onPullListener?.(pullDown)
    // this.log(flag + "===pullDownListener===" + pullDown.isPullDown)
  }

  public autoRefresh() {
    if (this.status == PullStatus.Refresh || this.status == PullStatus.RefreshSuccess || this.status == PullStatus.RefreshError || this.status == PullStatus.OpenPage) {
      return
    }
    if (this.status == PullStatus.Load) {
      return
    }
    if (!this.autoRefreshAnim) {
      this.autoRefreshAnim = animator.create({
        duration: 200,
        easing: "fast-out-linear-in",
        delay: 0,
        fill: "forwards",
        direction: "normal",
        iterations: 1,
        begin: 0,
        end: 1
      })
      this.autoRefreshAnim.onFrame = (progress: number) => {
        /*如果触摸视图，也暂停处理*/
        if (this.animPause) {
          this.autoRefreshAnim?.cancel()
          return
        }
        this.currentOffset = this.helper.headerSize * progress
        this.helper.totalOffset = this.currentOffset
      }
      this.autoRefreshAnim.onFinish = () => {
        this.releaseActionByRefresh()
      }
    }
    this.status = PullStatus.Refresh
    this.onRefresh?.()
    this.autoRefreshAnim.play()
    /*状态监听*/
    this.pullDownListener({
      isPullDown: true,
      isPullUp: false,
      isTouch: this.helper.isPressDown,
      distance: this.helper.headerSize,
      distanceLoad: this.currentOffsetLoad,
      headerViewSize: this.helper.headerSize,
      footerViewSize: this.helper.footerSize,
      status: this.status
    }, 8)
  }

  public autoLoad() {
    if (this.status == PullStatus.Load || this.status == PullStatus.LoadSuccess || this.status == PullStatus.LoadError || this.status == PullStatus.LoadOpenPage) {
      return
    }
    if (this.status == PullStatus.Refresh) {
      return
    }
    if (!this.autoLoadAnim) {
      this.autoLoadAnim = animator.create({
        duration: 200,
        easing: "fast-out-linear-in",
        delay: 0,
        fill: "forwards",
        direction: "normal",
        iterations: 1,
        begin: 0,
        end: 1
      })
      this.autoLoadAnim.onFrame = (progress: number) => {
        /*如果触摸视图，也暂停处理*/
        if (this.animLoadPause) {
          this.autoLoadAnim?.cancel()
          return
        }
        this.currentOffsetLoad = -this.helper.footerSize * progress
        this.helper.totalOffsetLoad = this.currentOffsetLoad
      }
      this.autoLoadAnim.onFinish = () => {
        this.releaseActionByLoad()
      }
    }
    this.status = PullStatus.Load
    this.onLoad?.()
    this.autoLoadAnim.play()
    /*状态监听*/
    this.pullDownListener({
      isPullDown: false,
      isPullUp: true,
      isTouch: this.helper.isPressDown,
      distance: this.currentOffset,
      distanceLoad: -this.helper.footerSize,
      headerViewSize: this.helper.headerSize,
      footerViewSize: this.helper.footerSize,
      status: this.status
    }, 82)
  }

  /*刷新成功*/
  public refreshSuccess(ignoreViewTips?:boolean) {
    /*如果上一个状态不是刷新中，直接返回*/
    if (this.status != PullStatus.Refresh&&this.viewSuccessState==1) {
      /*如果显示其他异常页面，则刷新成功不需要校验刷新中的状态*/
      return
    }
    /*刷新成功后，可能存在暂无更多，这里不改成true*/
    // this.hasMore=true
    if(!ignoreViewTips){
      this.status = PullStatus.RefreshSuccess
    }
    this.setViewLoadSuccessState()
    this.refreshEnd();
  }

  /*刷新失败*/
  public refreshError() {
    /*如果上一个状态不是刷新中，直接返回*/
    if (this.status != PullStatus.Refresh) {
      return
    }
    this.status = PullStatus.RefreshError
    this.refreshEnd();
  }

  /*完成刷新*/
  public refreshComplete(refreshSuccess: boolean,ignoreViewTips?:boolean) {
    if (refreshSuccess) {
      this.refreshSuccess(ignoreViewTips);
    } else {
      this.refreshError();
    }
  }
  /*刷新取消*/
  public refreshCancel(){
    /*如果上一个状态不是刷新中，直接返回*/
    if (this.status != PullStatus.Refresh) {
      return
    }
    this.refreshEnd();
  }

  private refreshEnd() {
    /*状态监听*/
    this.pullDownListener({
      isPullDown: false || (this.helper.isPressDown && this.helper.preOffset < this.currentOffset),
      isPullUp: false || (this.helper.isPressDown && this.helper.preOffset > this.currentOffsetLoad),
      isTouch: this.helper.isPressDown,
      distance: this.currentOffset,
      distanceLoad: this.currentOffsetLoad,
      headerViewSize: this.helper.headerSize,
      footerViewSize: this.helper.footerSize,
      status: this.status
    }, 9)

    /*如果不需要释放刷新情况下，不需要考虑是否是触摸状态*/
    if (!this.helper.notReleaseRefresh) {
      /*如果是touch状态，则返回不做回弹操作*/
      if (this.helper.isPressDown || this.currentOffset <= 0) {
        //超过显示刷新结果的时间之后改变状态
        this.setDefAfterRefreshEnd(this.config.refreshResultDurationTime)
        return
      }
    }
    /*设置刷新结果之后准备回弹*/
    if (this.currentOffset > this.helper.headerSize) {
      /*如果回弹至header高度前就刷新成功了，则先回弹至header高度，再回弹至0高度*/
      // 这里会直接回弹至header高度后再回弹至0高度，所以不需要暂停动画再回弹
      this.pauseAnim()
      this.releaseActionByRefresh();
      // (动画执行完可能存在误差(精度问题)，导致return不会执行hiddenFooterAnim，最终还是不注释)
      return
    }
    /*如果偏移量距离小于等于header高度,直接回弹至0高度*/
    this.hiddenHeaderAnim()
  }

  /*加载成功*/
  public loadSuccess(hasMore: boolean = true) {
    /*如果上一个状态不是加载中，直接返回*/
    if (this.status != PullStatus.Load) {
      return
    }
    this.hasMore = hasMore
    this.status = PullStatus.LoadSuccess
    this.loadEnd();
  }

  /*加载失败*/
  public loadError() {
    /*如果上一个状态不是加载中，直接返回*/
    if (this.status != PullStatus.Load) {
      return
    }
    this.status = PullStatus.LoadError
    this.loadEnd();
  }

  /*加载完成*/
  public loadComplete(loadSuccess: boolean, hasMore: boolean = true) {
    if (loadSuccess) {
      this.loadSuccess(hasMore);
    } else {
      this.loadError();
    }
  }
  /*加载取消*/
  public loadCancel(){
    /*如果上一个状态不是加载中，直接返回*/
    if (this.status != PullStatus.Load) {
      return
    }
    this.loadEnd();
  }

  private loadEnd() {
    /*状态监听*/
    this.pullDownListener({
      isPullDown: false || (this.helper.isPressDown && this.helper.preOffset < this.currentOffset),
      isPullUp: false || (this.helper.isPressDown && this.helper.preOffset > this.currentOffsetLoad),
      isTouch: this.helper.isPressDown,
      distance: this.currentOffset,
      distanceLoad: this.currentOffsetLoad,
      headerViewSize: this.helper.headerSize,
      footerViewSize: this.helper.footerSize,
      status: this.status
    }, 9)

    /*如果不需要释放加载情况下，不需要考虑是否是触摸状态*/
    if (!this.helper.notReleaseLoad) {
      /*如果是touch状态，则返回不做回弹操作*/
      if (this.helper.isPressDown || this.currentOffsetLoad >= 0) {
        //超过显示刷新结果的时间之后改变状态
        this.setDefAfterLoadEnd(this.config.loadResultDurationTime)
        return
      }
    }

    /*设置刷新结果之后准备回弹*/
    if (-this.currentOffsetLoad - this.helper.footerSize > 0.5) {
      /*如果回弹至header高度前就刷新成功了，则先回弹至footer高度，再回弹至0高度*/
      // 这里会直接回弹至footer高度后再回弹至0高度，所以不需要暂停动画再回弹
      this.pauseAnimLoad()
      this.releaseActionByLoad();
      // (动画执行完可能存在误差(精度问题)，导致return不会执行hiddenFooterAnim，最终还是不注释)
      return
    }
    /*如果偏移量距离小于等于footer高度,直接回弹至0高度*/
    this.hiddenFooterAnim()
  }

  /*设置下拉刷新默认状态*/
  private setDefStatus() {
    // this.arrowRotate = 0
    this.status = PullStatus.DEF
    this.changeStatus(this.currentOffset)
  }

  /*设置上拉加载默认状态*/
  private setDefStatusLoad() {
    // this.arrowRotate = 0
    this.status = PullStatus.DEF
    this.changeStatusLoad(this.currentOffsetLoad)
  }

  /*刷新完成之后改变状态，1：刷新时触摸，2：刷新完成时再触摸*/
  private setDefAfterRefreshEnd(durationTime: number) {
    if (durationTime <= 0) {
      durationTime = 200
    }
    if (this.setDefStatusId != 0) {
      // this.log("=====setDefStatusId==防止重复调用===" + this.setDefStatusId)
      //防止重复调用
      return
    }
    this.setDefStatusId = setTimeout(() => {
      this.setDefStatusId = 0
      this.setDefStatus()
      /*刷新中，手动把header视图上拉至0*/
      this.pullDownListener({
        isPullDown: false || (this.helper.isPressDown && this.helper.preOffset < this.currentOffset),
        isPullUp: false || (this.helper.isPressDown && this.helper.preOffset > this.currentOffsetLoad),
        isTouch: this.helper.isPressDown,
        distance: this.currentOffset,
        distanceLoad: this.currentOffsetLoad,
        headerViewSize: this.helper.headerSize,
        footerViewSize: this.helper.footerSize,
        status: this.status
      }, 10)
    }, durationTime)
    // this.log("=====setDefStatusId=====" + this.setDefStatusId)
  }

  /*加载完成之后改变状态，1：加载时触摸，2：加载完成时再触摸*/
  private setDefAfterLoadEnd(durationTime: number) {
    if (durationTime <= 0) {
      durationTime = 200
    }
    if (this.setDefLoadStatusId != 0) {
      // this.log("=====setDefLoadStatusId==防止重复调用===" + this.setDefLoadStatusId)
      //防止重复调用
      return
    }
    this.setDefLoadStatusId = setTimeout(() => {
      this.setDefLoadStatusId = 0
      this.setDefStatusLoad()
      /*加载中，手动把footer视图下拉至0*/
      this.pullDownListener({
        isPullDown: false || (this.helper.isPressDown && this.helper.preOffset < this.currentOffset),
        isPullUp: false || (this.helper.isPressDown && this.helper.preOffset > this.currentOffsetLoad),
        isTouch: this.helper.isPressDown,
        distance: this.currentOffset,
        distanceLoad: this.currentOffsetLoad,
        headerViewSize: this.helper.headerSize,
        footerViewSize: this.helper.footerSize,
        status: this.status
      }, 10)
    }, durationTime)
    // this.log("=====setDefLoadStatusId=====" + this.setDefLoadStatusId)
  }

  /*隐藏header回弹动画*/
  private hiddenHeaderAnim() {
    /*如果不需要显示刷新成功或者失败视图*/
    let timeDuration = 0
    if ((this.config.refreshShowSuccess && this.status == PullStatus.RefreshSuccess) || (this.config.refreshShowError && this.status == PullStatus.RefreshError)) {
      timeDuration = this.config.refreshResultDurationTime
    }
    setTimeout(() => {
      /*如果不需要释放刷新情况下，不需要考虑是否是触摸状态*/
      if (!this.helper.notReleaseRefresh) {
        //显示刷新完成的结果之后，准备回弹至0时，正好触摸
        if (this.helper.isPressDown || this.currentOffset <= 0) {
          this.setDefStatus()
          return
        }
      }

      //不管动画执行完毕还是动画被触摸时暂停，都需要重置状态(隐藏header之后)
      this.setDefAfterRefreshEnd(this.config.durationCloseHeader)


      this.pauseAnim()
      this.anim?.reset({
        duration: this.config.durationCloseHeader * (this.currentOffset / this.helper.headerSize),
        easing: "fast-out-linear-in",
        delay: 0,
        fill: "forwards",
        direction: "normal",
        iterations: 1,
        begin: 0,
        end: 1
      })
      this.animPause = false
      this.anim?.play()
    }, timeDuration)
  }

  /*隐藏footer回弹动画*/
  private hiddenFooterAnim() {
    this.initLoadAnim()
    /*如果不需要显示加载成功或者失败视图*/
    let timeDuration = 0
    if ((this.config.loadShowSuccess && this.status == PullStatus.LoadSuccess) || (this.config.loadShowError && this.status == PullStatus.LoadError)) {
      timeDuration = this.config.loadResultDurationTime
    }
    setTimeout(() => {
      /*如果不需要释放加载情况下，不需要考虑是否是触摸状态*/
      if (!this.helper.notReleaseLoad) {
        //显示刷新完成的结果之后，准备回弹至0时，正好触摸
        if (this.helper.isPressDown || this.currentOffsetLoad >= 0) {
          this.setDefStatusLoad()
          return
        }
      }

      //不管动画执行完毕还是动画被触摸时暂停，都需要重置状态(隐藏header之后)
      this.setDefAfterLoadEnd(this.config.durationCloseFooter)


      this.pauseAnimLoad()
      this.animLoad?.reset({
        duration: this.config.durationCloseFooter * (-this.currentOffsetLoad / this.helper.footerSize),
        easing: "fast-out-linear-in",
        delay: 0,
        fill: "forwards",
        direction: "normal",
        iterations: 1,
        begin: 0,
        end: 1
      })
      this.animLoadPause = false
      this.animLoad?.play()
    }, timeDuration)
  }

  private changeStatus(currentOffsetY: number) {
    /*如果是刷新中，刷新完成，刷新失败，下拉不改变状态*/
    if (this.status == PullStatus.Refresh || this.status == PullStatus.RefreshSuccess || this.status == PullStatus.RefreshError) {
      return
    }
    /*根据下拉距离改变状态*/
    if (this.config.pullRefreshOpenPageEnable && currentOffsetY >= this.getPullOpenPageHeight()) {
      /*满足打开其他页面条件*/
      this.status = PullStatus.PreOpenPage
    } else if (currentOffsetY >= this.getPullRefreshHeaderHeight()) {
      if (this.status == PullStatus.PullDown) {
        /*进入释放刷新状态*/
        /*animateTo({ duration: 150, curve: Curve.Linear }, () => {
          this.arrowRotate = 180
        })*/
      }
      /*满足释放刷新条件*/
      this.status = PullStatus.PreRefresh
    } else if (currentOffsetY > 0) {
      if (this.status == PullStatus.PreRefresh) {
        /*进入下拉状态*/
        /*animateTo({ duration: 10, curve: Curve.Linear }, () => {
          this.arrowRotate = 0
        })*/
      }
      /*满足下拉条件*/
      this.status = PullStatus.PullDown
    } else if (currentOffsetY <= 0) {
      /*默认状态*/
      this.status = PullStatus.DEF
    }
  }

  private changeStatusLoad(currentOffsetYLoad: number) {
    /*如果是加载中，加载完成，加载失败，上拉不改变状态*/
    if (this.status == PullStatus.Load || this.status == PullStatus.LoadSuccess || this.status == PullStatus.LoadError) {
      return
    }
    /*根据下拉距离改变状态*/
    if (this.config.pullLoadOpenPageEnable && -currentOffsetYLoad >= this.getPullLoadOpenPageHeight()) {
      /*满足打开其他页面条件*/
      this.status = PullStatus.PreLoadOpenPage
    } else if (-currentOffsetYLoad >= this.getPullLoadFooterHeight()) {
      /*如果没有更多数据*/
      if (!this.hasMore) {
        this.status = PullStatus.PullUp
        return
      }
      if (this.status == PullStatus.PullUp) {
        /*进入释放加载状态*/
        /*animateTo({ duration: 150, curve: Curve.Linear }, () => {
          this.arrowRotate = 180
        })*/
      }
      /*满足释放加载条件*/
      this.status = PullStatus.PreLoad
    } else if (-currentOffsetYLoad > 0) {
      if (this.status == PullStatus.PreLoad) {
        /*进入上拉状态*/
        /*animateTo({ duration: 10, curve: Curve.Linear }, () => {
          this.arrowRotate = 0
        })*/
      }
      /*满足上拉条件*/
      this.status = PullStatus.PullUp
    } else if (currentOffsetYLoad <= 0) {
      /*默认状态*/
      this.status = PullStatus.DEF
    }
  }

  /*下拉刷新*/
  private pauseAnim() {
    //回弹过程中暂停动画
    this.animPause = true
    this.anim?.cancel()
  }

  /*上拉加载*/
  private pauseAnimLoad() {
    //回弹过程中暂停动画
    this.animLoadPause = true
    this.initLoadAnim()
    this.animLoad?.cancel()
  }

  private releaseActionByRefresh() {
    this.helper.totalOffset = this.currentOffset
    if (this.currentOffset <= 0) {
      // this.arrowRotate = 0
      this.changeStatus(this.currentOffset)
      return
    }

    if (this.status == PullStatus.PreRefresh) {
      /*释放刷新*/
      this.status = PullStatus.Refresh
      // this.startRefresh()
      /*触发刷新操作*/
      this.onRefresh?.()
    } else if (this.status == PullStatus.PreOpenPage) {
      /*打开其他页面*/
      this.status = PullStatus.OpenPage
      this.onOpenPage?.()
    }

    let endFraction: number = 1;
    /*如果刷新需要保持header视图*/
    if (this.config.refreshKeepHeader) {
      if (this.status == PullStatus.Refresh || this.status == PullStatus.RefreshSuccess || this.status == PullStatus.RefreshError) {
        /*如果此时下拉距离大于header高度，则回弹至header高度，否则回弹到0*/
        if (this.currentOffset >= this.helper.headerSize) {
          endFraction = (this.currentOffset - this.helper.headerSize) / this.currentOffset
          /*处理精度问题*/
          endFraction=Math.round(endFraction*100)/100
        }
      }
    }

    let durationTime = this.config.durationToHeader
    /*如果回弹至header高度过程中刷新完成了，再次回弹时不用执行相同时间*/
    if (this.animProgress != 1) {
      durationTime = durationTime * (1 - this.animProgress)
    }
    if (this.status == PullStatus.OpenPage) {
      durationTime = this.config.durationCloseForOpenPage
    }

    this.animPause = false
    this.anim?.reset({
      duration: durationTime,
      easing: "fast-out-linear-in",
      delay: 0,
      fill: "forwards",
      direction: "normal",
      iterations: 1,
      begin: 0,
      end: endFraction
    })
    this.anim?.play()
  }

  /*是否处于加载相关的状态*/
  private isLoadStatus(): boolean {
    if (this.status == PullStatus.PullUp || this.status == PullStatus.PreLoad || this.status == PullStatus.Load
      || this.status == PullStatus.PreLoadOpenPage || this.status == PullStatus.LoadOpenPage || this.status == PullStatus.LoadSuccess || this.status == PullStatus.LoadError) {
      return true
    }
    return false
  }

  private releaseActionByLoad() {
    this.helper.totalOffsetLoad = this.currentOffsetLoad
    if (this.currentOffsetLoad >= 0) {
      // this.arrowRotate = 0
      this.changeStatusLoad(this.currentOffsetLoad)
      return
    }

    if (this.status == PullStatus.PreLoad) {
      /*释放加载*/
      this.status = PullStatus.Load
      /*触发加载操作*/
      this.onLoad?.()
    } else if (this.status == PullStatus.PreLoadOpenPage) {
      /*打开其他页面*/
      this.status = PullStatus.LoadOpenPage
      this.onLoadOpenPage?.()
    }

    let endFraction: number = 1;
    /*如果刷新需要保持header视图*/
    if (this.config.loadKeepFooter) {
      if (this.status == PullStatus.Load || this.status == PullStatus.LoadSuccess || this.status == PullStatus.LoadError) {
        /*如果此时下拉距离大于header高度，则回弹至header高度，否则回弹到0*/
        if (-this.currentOffsetLoad >= this.helper.footerSize) {
          endFraction = (-this.currentOffsetLoad - this.helper.footerSize) / -this.currentOffsetLoad
          /*处理精度问题*/
          endFraction=Math.round(endFraction*100)/100
        }
      }
    }

    let durationTime = this.config.durationToFooter
    /*如果回弹至footer高度过程中刷新完成了，再次回弹时不用执行相同时间*/
    if (this.animProgressLoad != 1) {
      durationTime = durationTime * (1 - this.animProgressLoad)
    }
    if (this.status == PullStatus.LoadOpenPage) {
      durationTime = this.config.durationCloseLoadForOpenPage
    }
    this.animLoadPause = false
    this.initLoadAnim()
    this.animLoad?.reset({
      duration: durationTime,
      easing: "fast-out-linear-in",
      delay: 0,
      fill: "forwards",
      direction: "normal",
      iterations: 1,
      begin: 0,
      end: endFraction
    })
    this.animLoad?.play()
  }
}

