import BuildProfile from '../../../BuildProfile';

import { AnimatorOptions } from '@kit.ArkUI';

@Builder
export function _headerView() {
  Text("headerView:()=>{your @Builder View}")
}

@Builder
export function _ContentView() {
  Text("contentView:()=>{your @Builder View}")
}

@Builder
export function _loadMoreView() {
  Text("loadView:()=>{your @Builder View}")
}
@Builder
export function _noMoreView() {
  Text("noMoreView:()=>{your @Builder View}")
}

export class RefreshLayoutHelper {
  public debug: boolean = BuildProfile.DEBUG

  private log(str: string, tag: string = "RefreshLayout") {
    if (!this.debug) {
      return
    }
    console.debug(tag + "==" + str)
  }
  /*记录列表滑动到底部的偏移量*/
  public scrollerOffset: number = 0;
  /*下拉刷新*/
  public preOffset: number = 0;
  public totalOffset: number = 0;
  /*上拉加载*/
  // public preOffsetLoad: number = 0;
  public totalOffsetLoad: number = 0;
  public headerSize: number = 0;
  public footerSize: number = 0;
  public isPressDown: boolean = false
  public options: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Down | PanDirection.Up })
  /*不是释放刷新*/
  public notReleaseRefresh: boolean = false
  /*不是释放加载*/
  public notReleaseLoad: boolean = false
  public animOptions: AnimatorOptions = {
    duration: 250,
    easing: "fast-out-linear-in",
    delay: 0,
    fill: "forwards",
    direction: "normal",
    iterations: 1,
    begin: 0,
    end: 1
  }
  public animLoadOptions: AnimatorOptions = {
    duration: 250,
    easing: "fast-out-linear-in",
    delay: 0,
    fill: "forwards",
    direction: "normal",
    iterations: 1,
    begin: 0,
    end: 1
  }
  /*webview滑动偏移量*/
  public webViewXOffset:number=0
  public webViewYOffset:number=0
}