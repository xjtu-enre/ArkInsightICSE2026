import { PullDown } from './PullDown';
import { PullStatus } from './PullStatus';
import { RefreshController } from './RefreshController';
import { RefreshLayout } from './RefreshLayout';
import { RefreshLayoutConfig } from './RefreshLayoutConfig';
import { _ContentView, _loadMoreView, _noMoreView } from './RefreshLayoutHelper';
import web from '@ohos.web.webview';
import preferences from '@ohos.data.preferences';
import { PullToRefreshConfig } from './PullToRefreshConfig';

@Component
export struct PullToRefreshLayout {
  @State clipView:boolean=true
  /*下拉箭头旋转角度*/
  @State arrowRotate: number = 0;
  /*上拉箭头旋转角度*/
  @State arrowRotateLoad: number = 180;
  @State status: PullStatus = PullStatus.DEF
  /********************************************************************************************************/
  public pullConfig: PullToRefreshConfig = new PullToRefreshConfig()
  /*记录组件刷新时间*/
  public viewKey: string = ""
  public scroller: Scroller | undefined = undefined
  public webviewController: web.WebviewController | undefined = undefined
  public controller: RefreshController = new RefreshController()
  /*是否可以下拉*/
  public onCanPullRefresh: () => boolean|undefined = () => undefined
  /*是否可以下拉*/
  public onCanPullLoad: () => boolean = () => false
  /*刷新通知*/
  public onRefresh: () => void = () => {
  }
  /*刷新通知*/
  public onLoad: () => void = () => {
  }
  /*打开页面通知*/
  public onOpenPage: () => void = () => {
  }
  /*打开页面通知*/
  public onLoadOpenPage: () => void = () => {
  }
  /*下拉状态监听*/
  public onPullListener: (pullDown: PullDown) => void = () => {
  }
  //内容视图
  @Require @BuilderParam contentView: () => void = _ContentView
  //loading视图
  @BuilderParam headerLoadIngView?: () => void
  //loading视图
  @BuilderParam footerLoadIngView?: () => void
  /*下拉刷新配置*/
  public config: RefreshLayoutConfig = new RefreshLayoutConfig()


  //正在加载视图
  @BuilderParam viewLoading?: () => void
  //空视图
  @BuilderParam viewEmpty?: () => void
  //加载错误视图
  @BuilderParam viewError?: () => void
  //无网络视图
  @BuilderParam viewNoNetwork?: () => void
  /********************************************************************************************************/

  aboutToAppear(): void {
    this.resetArrowRotate()
    this.resetArrowRotateLoad()
  }

  /*************垂直列表和水平列表feader视图箭头角度**************/
  private isPullRotate(): boolean {
    if (this.isVerticalLayout()) {
      return this.arrowRotate == 0
    } else {
      return this.arrowRotate == -90
    }
  }

  private isPreRefreshRotate(): boolean {
    if (this.isVerticalLayout()) {
      return this.arrowRotate == 180
    } else {
      return this.arrowRotate == 90
    }
  }

  private setPreRefreshRotate() {
    if (this.isVerticalLayout()) {
      this.arrowRotate = 180
    } else {
      this.arrowRotate = 90
    }
  }

  private resetArrowRotate() {
    if (this.isVerticalLayout()) {
      this.arrowRotate = 0
    } else {
      this.arrowRotate = -90
    }
  }

  /*************垂直列表和水平列表footer视图箭头角度**************/
  private isPullLoadRotate(): boolean {
    if (this.isVerticalLayout()) {
      return this.arrowRotateLoad == 180
    } else {
      return this.arrowRotateLoad == 90
    }
  }

  private isPreLoadRotate(): boolean {
    if (this.isVerticalLayout()) {
      return this.arrowRotateLoad == 0
    } else {
      return this.arrowRotateLoad == -90
    }
  }

  private setPreLoadRotate() {
    if (this.isVerticalLayout()) {
      this.arrowRotateLoad = 180
    } else {
      this.arrowRotateLoad = 90
    }
  }

  private resetArrowRotateLoad() {
    if (this.isVerticalLayout()) {
      this.arrowRotateLoad = 0
    } else {
      this.arrowRotateLoad = -90
    }
  }

  build() {
    RefreshLayout({
      scroller: this.scroller,
      webviewController: this.webviewController,
      controller: this.controller,
      config: this.config,
      headerView: () => {
        if (this.isVerticalLayout()) {
          this.defHeaderView()
        } else {
          this.defHeaderViewHorizontal()
        }
      },
      onCanPullRefresh: () => {
        const canPull=this.onCanPullRefresh()
        if(canPull==undefined||canPull==null){
          if(this.scroller){
            if (!this.scroller.currentOffset()) {
              /*处理无数据，为空的情况*/
              return true
            }
            //如果列表到顶，返回true，表示可以下拉，返回false，表示无法下拉
            return this.scroller.currentOffset().yOffset <= 0
          }
        }
        return canPull??false
      },
      onCanPullLoad: () => {
        return this.onCanPullLoad()
      },
      onRefresh: () => {
        this.onRefresh()
      },
      onLoad: () => {
        this.onLoad()
      },
      onOpenPage: () => {
        this.onOpenPage()
      },
      onLoadOpenPage: () => {
        this.onLoadOpenPage()
      },
      contentView: () => {
        this.contentView()
      },
      loadView: () => {
        if (this.isVerticalLayout()) {
          this.defFooterView()
        } else {
          this.defFooterViewHorizontal()
        }
      },
      noMoreView: () => {
        if (this.isVerticalLayout()) {
          this.defFooterNoMoreView()
        } else {
          this.defFooterNoMoreViewHorizontal()
        }
      },
      onPullListener: (pullDown: PullDown) => {
        this.status = pullDown.status
        this.updateRefreshTime(this.status)
        this.onPullListener?.(pullDown)
        if (this.config.pullHeaderHeightRefresh <= pullDown.headerViewSize) {
          this.config.pullHeaderHeightRefresh = pullDown.headerViewSize * 1.5
        }
        if (this.config.pullHeaderHeightOpenPage <= this.config.pullHeaderHeightRefresh) {
          this.config.pullHeaderHeightOpenPage = pullDown.headerViewSize * 2.6
        }

        if (this.config.pullFooterHeightLoad <= pullDown.footerViewSize) {
          this.config.pullFooterHeightLoad = pullDown.footerViewSize * 1.1
        }
        if (this.config.pullFooterHeightOpenPage <= this.config.pullFooterHeightLoad) {
          this.config.pullFooterHeightOpenPage = pullDown.footerViewSize * 2.6
        }
        if (this.status == PullStatus.PullDown) {
          if (this.isPullRotate()) {
            return
          }
          /*进入下拉状态*/
          animateTo({ duration: 10, curve: Curve.Linear }, () => {
            this.resetArrowRotate()
          })
        } else if (this.status == PullStatus.PreRefresh) {
          if (this.isPreRefreshRotate()) {
            return
          }
          /*进入释放刷新状态*/
          animateTo({ duration: 150, curve: Curve.Linear }, () => {
            this.setPreRefreshRotate()
          })
        } else if (this.status == PullStatus.PullUp) {
          if (this.isPullLoadRotate()) {
            return
          }
          /*进入上拉状态*/
          animateTo({ duration: 10, curve: Curve.Linear }, () => {
            this.setPreLoadRotate()
          })
        } else if (this.status == PullStatus.PreLoad) {
          if (this.isPreLoadRotate()) {
            return
          }
          /*进入释放加载状态*/
          animateTo({ duration: 150, curve: Curve.Linear }, () => {

            this.resetArrowRotateLoad()
          })
        }

      },
      /*正在加载视图*/
      viewLoading:this.viewLoading,
      /*空数据视图*/
      viewEmpty:this.viewEmpty,
      /*加载失败视图*/
      viewError:this.viewError,
      /*无网络视图*/
      viewNoNetwork:this.viewNoNetwork
    }).clip(this.clipView)

  }

  private isVerticalLayout(): boolean {
    return (this.config.isVertical || this.config.horizontalMode == 1 || this.config.horizontalMode == 2)
  }

  @State private zrLastUpdate: string = getContext().resourceManager.getStringByNameSync(("zr_last_update"))

  @Builder
  defHeaderViewHorizontal() {
    RelativeContainer() {
      Stack() {
        Image(this.pullConfig.arrowImage)
          .width(this.pullConfig.arrowImageWidth)
          .height(this.pullConfig.arrowImageHeight)
          .visibility(this.getPullArrowVisibility()).fillColor(this.pullConfig.arrowImageColor)
          .margin({ top: 5 })
          .rotate({ x: 0, y: 0, z: 1, angle: this.arrowRotate })
        if (this.headerLoadIngView) {
          Stack() {
            this.headerLoadIngView()
          }
          .visibility(this.getRefreshVisibility())
        } else {
          LoadingProgress()
            .color(this.pullConfig.refreshLoadingColor)
            .width(this.pullConfig.refreshLoadingWidth)
            .height(this.pullConfig.refreshLoadingHeight)
            .visibility(this.getRefreshVisibility())
        }
      }.alignRules({
        top: { anchor: "title", align: VerticalAlign.Bottom },
        middle: { anchor: "__container__", align: HorizontalAlign.Center }
      }).id("arrow")

      Row() {
        Text(this.getTips())
          .fontSize(this.pullConfig.pullDownTipsSize)
          .fontColor(this.pullConfig.pullDownTipsColor)
          .textAlign(TextAlign.Center)
        Text(this.zrLastUpdate)
          .fontSize(this.pullConfig.refreshTimeTipsSize)
          .fontColor(this.pullConfig.refreshTimeTipsColor)
          .margin({ left: 2 })
          .visibility(this.pullConfig.showRefreshTime ? this.getTimeTipsVisibility() : Visibility.None)
          .textAlign(TextAlign.Center)
      }.id("title").alignRules({
        middle: { anchor: "__container__", align: HorizontalAlign.Center },
        center: { anchor: "__container__", align: VerticalAlign.Center }
      }).alignItems(VerticalAlign.Center)

    }.width(50).height("100%")
  }

  @Builder
  defHeaderView() {
    RelativeContainer() {
      Stack() {
        Image(this.pullConfig.arrowImage)
          .width(this.pullConfig.arrowImageWidth)
          .height(this.pullConfig.arrowImageHeight)
          .visibility(this.getPullArrowVisibility()).fillColor(this.pullConfig.arrowImageColor)
          .margin({ right: 10 })
          .rotate({ x: 0, y: 0, z: 1, angle: this.arrowRotate })
        if (this.headerLoadIngView) {
          Stack() {
            this.headerLoadIngView()
          }
          .visibility(this.getRefreshVisibility())
        } else {
          LoadingProgress()
            .color(this.pullConfig.refreshLoadingColor)
            .width(this.pullConfig.refreshLoadingWidth)
            .height(this.pullConfig.refreshLoadingHeight)
            .visibility(this.getRefreshVisibility())
        }
      }.alignRules({
        right: { anchor: "title", align: HorizontalAlign.Start },
        center: { anchor: "__container__", align: VerticalAlign.Center }
      }).id("arrow")

      Column() {
        Text(this.getTips()).fontSize(this.pullConfig.pullDownTipsSize)
          .fontColor(this.pullConfig.pullDownTipsColor)
        Text(this.zrLastUpdate).fontSize(this.pullConfig.refreshTimeTipsSize)
          .fontColor(this.pullConfig.refreshTimeTipsColor).margin({ top: 2 })
          .visibility(this.pullConfig.showRefreshTime ? this.getTimeTipsVisibility() : Visibility.None)
      }.id("title").alignRules({
        middle: { anchor: "__container__", align: HorizontalAlign.Center },
        center: { anchor: "__container__", align: VerticalAlign.Center }
      }).constraintSize({ minWidth: 80 }).alignItems(HorizontalAlign.Center)

    }.height(50).width("100%")

  }

  @Builder
  defFooterViewHorizontal() {
    RelativeContainer() {
      Stack() {
        Image(this.pullConfig.arrowLoadImage)
          .width(this.pullConfig.arrowLoadImageWidth)
          .height(this.pullConfig.arrowLoadImageHeight)
          .visibility(this.getPullUpArrowVisibility()).fillColor(this.pullConfig.arrowLoadImageColor)
          .margin({ top: 5 })
          .rotate({ x: 0, y: 0, z: 1, angle: this.arrowRotateLoad })
        if (this.footerLoadIngView) {
          Stack() {
            this.footerLoadIngView()
          }
          .visibility(this.getLoadVisibility())
        } else {
          LoadingProgress()
            .color(this.pullConfig.refreshLoadingColor)
            .width(this.pullConfig.refreshLoadingWidth)
            .height(this.pullConfig.refreshLoadingHeight).visibility(this.getLoadVisibility())
        }
      }.alignRules({
        top: { anchor: "title", align: VerticalAlign.Bottom },
        middle: { anchor: "__container__", align: HorizontalAlign.Center }
      }).id("arrow")

      Row() {
        Text(this.getLoadTips())
          .fontSize(this.pullConfig.pullUpTipsSize)
          .fontColor(this.pullConfig.pullUpTipsColor)
          .textAlign(TextAlign.Center)
      }.id("title").alignRules({
        middle: { anchor: "__container__", align: HorizontalAlign.Center },
        center: { anchor: "__container__", align: VerticalAlign.Center }
      }).alignItems(VerticalAlign.Center)

    }.width(50).height("100%")
  }

  @Builder
  defFooterNoMoreViewHorizontal() {
    Text(this.pullConfig.noMoreTipsHorizontal)
      .textAlign(TextAlign.Center)
      .height("100%")
      .width(50)
      .fontSize(this.pullConfig.noMoreTipsSize)
      .fontColor(this.pullConfig.noMoreTipsColor)
  }

  @Builder
  defFooterView() {
    RelativeContainer() {
      Stack() {
        Image(this.pullConfig.arrowLoadImage)
          .width(this.pullConfig.arrowLoadImageWidth)
          .height(this.pullConfig.arrowLoadImageHeight)
          .visibility(this.getPullUpArrowVisibility()).fillColor(this.pullConfig.arrowLoadImageColor)
          .margin({ right: 10 })
          .rotate({ x: 0, y: 0, z: 1, angle: this.arrowRotateLoad })
        if (this.footerLoadIngView) {
          Stack() {
            this.footerLoadIngView()
          }
          .visibility(this.getLoadVisibility())
        } else {

          LoadingProgress()
            .color(this.pullConfig.refreshLoadingColor)
            .width(this.pullConfig.refreshLoadingWidth)
            .height(this.pullConfig.refreshLoadingHeight)
            .visibility(this.getLoadVisibility())
        }
      }.alignRules({
        right: { anchor: "title", align: HorizontalAlign.Start },
        center: { anchor: "__container__", align: VerticalAlign.Center }
      }).id("arrow")

      Column() {
        Text(this.getLoadTips()).fontSize(this.pullConfig.pullUpTipsSize).fontColor(this.pullConfig.pullUpTipsColor)
      }.id("title").alignRules({
        middle: { anchor: "__container__", align: HorizontalAlign.Center },
        center: { anchor: "__container__", align: VerticalAlign.Center }
      }).constraintSize({ minWidth: 80 }).alignItems(HorizontalAlign.Center)

    }.height(50).width("100%")

  }

  @Builder
  defFooterNoMoreView() {
    Text(this.pullConfig.noMoreTips)
      .textAlign(TextAlign.Center)
      .height(50)
      .width("100%")
      .fontSize(this.pullConfig.noMoreTipsSize)
      .fontColor(this.pullConfig.noMoreTipsColor)
  }

  private getTips(): Resource | string {
    // todo
    if (!this.config.isVertical && this.config.horizontalMode != 1 && this.config.horizontalMode != 2) {
      switch (this.status) {
        case PullStatus.DEF:
        case PullStatus.PullDown:
          return this.pullConfig.pullDownTipsHorizontal
        case PullStatus.PreRefresh:
          return this.pullConfig.releaseRefreshTipsHorizontal
        case PullStatus.Refresh:
          return this.pullConfig.refreshTipsHorizontal
        case PullStatus.PreOpenPage:
        case PullStatus.OpenPage:
          return this.pullConfig.pullOpenPageTipsHorizontal
        case PullStatus.RefreshSuccess:
          if (this.controller.getConfig().refreshShowSuccess) {
            return this.pullConfig.refreshSuccessTipsHorizontal
          } else {
            /*如果不显示刷新成功的视图*/
            return this.pullConfig.refreshTipsHorizontal
          }
        case PullStatus.RefreshError:
          if (this.controller.getConfig().refreshShowError) {
            return this.pullConfig.refreshErrorTipsHorizontal
          } else {
            /*如果不显示刷新失败的视图*/
            return this.pullConfig.refreshTipsHorizontal
          }
        default:
          return this.pullConfig.pullDownTipsHorizontal
      }
    }
    switch (this.status) {
      case PullStatus.DEF:
      case PullStatus.PullDown:
        return this.pullConfig.pullDownTips
      case PullStatus.PreRefresh:
        return this.pullConfig.releaseRefreshTips
      case PullStatus.Refresh:
        return this.pullConfig.refreshTips
      case PullStatus.PreOpenPage:
      case PullStatus.OpenPage:
        return this.pullConfig.pullOpenPageTips
      case PullStatus.RefreshSuccess:
        if (this.controller.getConfig().refreshShowSuccess) {
          return this.pullConfig.refreshSuccessTips
        } else {
          /*如果不显示刷新成功的视图*/
          return this.pullConfig.refreshTips
        }
      case PullStatus.RefreshError:
        if (this.controller.getConfig().refreshShowError) {
          return this.pullConfig.refreshErrorTips
        } else {
          /*如果不显示刷新失败的视图*/
          return this.pullConfig.refreshTips
        }
      default:
        return this.pullConfig.pullDownTips
    }
  }

  private getLoadTips(): Resource | string {
    if (!this.config.isVertical && this.config.horizontalMode != 1 && this.config.horizontalMode != 2) {
      switch (this.status) {
        case PullStatus.DEF:
        case PullStatus.PullUp:
          return this.pullConfig.pullUpTipsHorizontal
        case PullStatus.PreLoad:
          return this.pullConfig.releaseLoadTipsHorizontal
        case PullStatus.Load:
          return this.pullConfig.loadTipsHorizontal
        case PullStatus.PreLoadOpenPage:
        case PullStatus.LoadOpenPage:
          return this.pullConfig.pullOpenPageTipsHorizontal
        case PullStatus.LoadSuccess:
          if (this.controller.getConfig().loadShowSuccess) {
            return this.pullConfig.loadSuccessTipsHorizontal
          } else {
            /*如果不显示刷新成功的视图*/
            return this.pullConfig.loadTipsHorizontal
          }
        case PullStatus.LoadError:
          if (this.controller.getConfig().loadShowError) {
            return this.pullConfig.loadErrorTipsHorizontal
          } else {
            /*如果不显示刷新失败的视图*/
            return this.pullConfig.loadTipsHorizontal
          }
        default:
          return this.pullConfig.pullUpTipsHorizontal
      }
    }
    switch (this.status) {
      case PullStatus.DEF:
      case PullStatus.PullUp:
        return this.pullConfig.pullUpTips
      case PullStatus.PreLoad:
        return this.pullConfig.releaseLoadTips
      case PullStatus.Load:
        return this.pullConfig.loadTips
      case PullStatus.PreLoadOpenPage:
      case PullStatus.LoadOpenPage:
        return this.pullConfig.loadOpenPageTips
      case PullStatus.LoadSuccess:
        if (this.controller.getConfig().loadShowSuccess) {
          return this.pullConfig.loadSuccessTips
        } else {
          /*如果不显示刷新成功的视图*/
          return this.pullConfig.loadTips
        }
      case PullStatus.LoadError:
        if (this.controller.getConfig().loadShowError) {
          return this.pullConfig.loadErrorTips
        } else {
          /*如果不显示刷新失败的视图*/
          return this.pullConfig.loadTips
        }
      default:
        return this.pullConfig.pullUpTips
    }
  }

  /*下拉箭头显示逻辑*/
  private getPullArrowVisibility(): Visibility {
    switch (this.status) {
      case PullStatus.DEF:
      case PullStatus.PullDown:
      case PullStatus.PreRefresh:
        return Visibility.Visible
    }
    return Visibility.Hidden
  }

  private getRefreshVisibility(): Visibility {
    switch (this.status) {
      case PullStatus.Refresh:
        return Visibility.Visible
      case PullStatus.RefreshSuccess:
        if (this.controller.getConfig().refreshShowSuccess) {
          return Visibility.Hidden
        } else {
          /*如果不显示刷新成功的视图*/
          return Visibility.Visible
        }
      case PullStatus.RefreshError:
        if (this.controller.getConfig().refreshShowError) {
          return Visibility.Hidden
        } else {
          /*如果不显示刷新失败的视图*/
          return Visibility.Visible
        }
    }
    return Visibility.Hidden
  }

  private getPullUpArrowVisibility(): Visibility {
    switch (this.status) {
      case PullStatus.DEF:
      case PullStatus.PullUp:
      case PullStatus.PreLoad:
        return Visibility.Visible
    }
    return Visibility.Hidden
  }

  private getLoadVisibility(): Visibility {
    switch (this.status) {
      case PullStatus.Load:
        return Visibility.Visible
      case PullStatus.LoadSuccess:
        if (this.controller.getConfig().loadShowSuccess) {
          return Visibility.Hidden
        } else {
          /*如果不显示刷新成功的视图*/
          return Visibility.Visible
        }
      case PullStatus.LoadError:
        if (this.controller.getConfig().loadShowError) {
          return Visibility.Hidden
        } else {
          /*如果不显示刷新失败的视图*/
          return Visibility.Visible
        }
    }
    return Visibility.Hidden
  }

  private getTimeTipsVisibility(): Visibility {
    switch (this.status) {
      case PullStatus.Refresh:
      case PullStatus.PreOpenPage:
      case PullStatus.OpenPage:
      case PullStatus.RefreshSuccess:
      case PullStatus.RefreshError:
        return Visibility.None
    }
    if (this.getLastRefreshTime() <= 0) {
      return Visibility.None
    }
    return Visibility.Visible
  }

  private sp: preferences.Preferences | undefined = undefined
  private lastRefreshTime: number | undefined = undefined

  private getLastRefreshTime(): number {
    try {
      if (!this.sp) {
        this.sp = preferences.getPreferencesSync(getContext().getApplicationContext(), {
          name: "PullToRefreshLayoutTime"
        })
      }
      if (this.lastRefreshTime) {
        return this.lastRefreshTime
      }
      let preTime: number = this.sp.getSync("lastRefreshTimeKey" + this.viewKey, 0) as number
      this.lastRefreshTime = preTime
      return preTime;
    } catch (err) {
    }
    return 0
  }

  private saveRefreshTime() {
    try {
      if (!this.sp) {
        this.sp = preferences.getPreferencesSync(getContext().getApplicationContext(), {
          name: "PullToRefreshLayoutTime"
        })
      }
      this.lastRefreshTime = new Date().getTime()
      this.sp.put("lastRefreshTimeKey" + this.viewKey, this.lastRefreshTime)
      this.sp.flush()
    } catch (err) {
    }
  }

  private lineBreak(): string {
    if (this.isVerticalLayout()) {
      return ""
    } else {
      return "\n"
    }
  }

  private getLastFormatRefreshTime(): string {
    const time = this.getLastRefreshTime();
    if (time <= 0) {
      return ""
    }
    const currentTime = new Date().getTime()
    const timeIntervalSecond = Math.floor(((currentTime - time) / 1000))
    let timeFormat: string = ""
    if (!this.zr_last_update) {
      if (this.isVerticalLayout()) {
        this.zr_last_update = getContext().resourceManager.getStringByNameSync(("zr_last_update"))
      } else {
        this.zr_last_update = "\n" + getContext().resourceManager.getStringByNameSync(("h_zr_last_update"))
      }
    }
    timeFormat = timeFormat + this.zr_last_update
    if (timeIntervalSecond < 60) {
      timeFormat = timeFormat + this.lineBreak() + timeIntervalSecond;
      if (!this.zr_seconds_ago) {
        if (this.isVerticalLayout()) {
          this.zr_seconds_ago = getContext().resourceManager.getStringByNameSync(("zr_seconds_ago"))
        } else {
          this.zr_seconds_ago = "\n" + getContext().resourceManager.getStringByNameSync(("h_zr_seconds_ago"))
        }
      }
      timeFormat = timeFormat + this.zr_seconds_ago
    } else if (timeIntervalSecond < 3600) {
      /*小于一小时*/
      timeFormat = timeFormat + this.lineBreak() + Math.floor((timeIntervalSecond / 60));

      if (!this.zr_minutes_ago) {
        if (this.isVerticalLayout()) {
          this.zr_minutes_ago = getContext().resourceManager.getStringByNameSync(("zr_minutes_ago"))
        } else {
          this.zr_minutes_ago = "\n" + getContext().resourceManager.getStringByNameSync(("h_zr_minutes_ago"))
        }
      }
      timeFormat = timeFormat + this.zr_minutes_ago
    } else if (timeIntervalSecond < 86400) {
      /*小于一天*/
      timeFormat = timeFormat + this.lineBreak() + Math.floor((timeIntervalSecond / 3600));
      if (!this.zr_hours_ago) {
        if (this.isVerticalLayout()) {
          this.zr_hours_ago = getContext().resourceManager.getStringByNameSync(("zr_hours_ago"))
        } else {
          this.zr_hours_ago = "\n" + getContext().resourceManager.getStringByNameSync(("h_zr_hours_ago"))
        }
      }
      timeFormat = timeFormat + this.zr_hours_ago
    } else {
      /*大于一天*/
      timeFormat = timeFormat + this.lineBreak() + Math.floor((timeIntervalSecond / 86400));
      if (!this.zr_days_ago) {

        if (this.isVerticalLayout()) {
          this.zr_days_ago = getContext().resourceManager.getStringByNameSync(("zr_days_ago"))
        } else {
          this.zr_days_ago = "\n" + getContext().resourceManager.getStringByNameSync(("h_zr_days_ago"))
        }
      }
      timeFormat = timeFormat + this.zr_days_ago
    }
    return timeFormat
  }

  private zr_last_update: string | undefined = undefined
  private zr_seconds_ago: string | undefined = undefined
  private zr_minutes_ago: string | undefined = undefined
  private zr_hours_ago: string | undefined = undefined
  private zr_days_ago: string | undefined = undefined
  private isUpdateTime = false;

  private updateRefreshTime(status: PullStatus) {
    if (status == PullStatus.RefreshSuccess) {
      this.saveRefreshTime()
    }
    if (status == PullStatus.PullDown || status == PullStatus.PreRefresh) {
      if (this.isUpdateTime) {
        return;
      }
      this.isUpdateTime = true
      setTimeout(() => {
        this.zrLastUpdate = this.getLastFormatRefreshTime()
        this.startUpdateTime();
      })
    } else {
      this.stopUpdateTime();
    }
  }

  private startUpdateTime() {
    if (!this.isUpdateTime) {
      return
    }
    setTimeout(() => {
      this.zrLastUpdate = this.getLastFormatRefreshTime()
      // console.log(this.zrLastUpdate + "=======startUpdateTime=====" + (1000 - new Date().getTime() % 1000));
      this.startUpdateTime();
    }, 1000 - new Date().getTime() % 1000)
  }

  private stopUpdateTime() {
    this.isUpdateTime = false
  }
}