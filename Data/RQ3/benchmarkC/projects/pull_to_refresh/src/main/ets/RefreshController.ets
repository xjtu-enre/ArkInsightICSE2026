import { PullStatus } from './PullStatus'
import { RefreshLayoutConfig } from './RefreshLayoutConfig'
export enum ViewState{
  success=0,
  loading,
  empty,
  error,
  noNetwork
}
export class RefreshController {
  /*刷新成功*/
  refreshSuccess: (ignoreViewTips?:boolean) => void = (ignoreViewTips?:boolean) => {
  }
  /*刷新失败*/
  refreshError: () => void = () => {
  }
  /*刷新完成，true:成功，false：失败*/
  refreshComplete: (isSuccess: boolean,ignoreViewTips?:boolean) => void = (isSuccess: boolean,ignoreViewTips?:boolean) => {
  }
  /*取消刷新*/
  refreshCancel: () => void = () => {
  }
  /*加载成功*/
  loadSuccess: (hasMore?: boolean) => void = (hasMore?: boolean) => {
  }
  /*加载失败*/
  loadError: () => void = () => {
  }
  /*加载完成，true:成功，false：失败*/
  loadComplete: (isSuccess: boolean, hasMore?: boolean) => void = (isSuccess: boolean, hasMore?: boolean) => {
  }
  /*取消加载*/
  loadCancel: () => void = () => {
  }
  /*显示加载中*/
  viewLoading: () => void = () => {
    this.viewState=ViewState.loading
  }
  /*显示空布局*/
  viewEmpty: () => void = () => {
    this.viewState=ViewState.empty
  }
  /*显示加载失败布局*/
  viewError: () => void = () => {
    this.viewState=ViewState.error
  }
  /*显示无网络布局*/
  viewNoNetwork: () => void = () => {
    this.viewState=ViewState.noNetwork
  }
  /**/
  /*获取当前状态*/
  getStatus: () => PullStatus = () => PullStatus.DEF
  /*设置是否还有更多数据*/
  hasMore: (hasMore: boolean) => void = (hasMore: boolean) => {
  }
  /*手动触发下拉刷新*/
  refresh: () => void = () => {
  }
  /*手动触发上拉*/
  load: () => void = () => {
  }
  /*下拉刷新开关是否打开*/
  refreshIsEnable: () => boolean = () => true

  /*设置下拉刷新开关*/
  setRefreshEnable: (enable:boolean) => void = (enable:boolean) => {

  }
  /*上拉加载开关是否打开*/
  loadIsEnable: () => boolean = () => false
  /*设置上拉加载开关*/
  setLoadEnable: (enable:boolean) => void = (enable:boolean) => {

  }
  /*设置配置*/
  setConfig: (config: RefreshLayoutConfig) => void = () => {
  }
  /*获取配置*/
  getConfig: () => RefreshLayoutConfig = () => new RefreshLayoutConfig()
  /*webview专用*/
  onWebviewScroll: (xOffset: number, yOffset: number) => void = (xOffset: number, yOffset: number) => {
  }
  private viewState:ViewState=ViewState.success
  public getViewState():ViewState{
    return this.viewState
  }
}