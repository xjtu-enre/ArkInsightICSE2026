/**
 * @Author zhongrui
 * @Date 2024/6/20
 */
export class PullToRefreshConfig {
  /*刷新loading宽度*/
  public refreshLoadingWidth: Length = 25
  /*刷新loading高度*/
  public refreshLoadingHeight: Length = 25
  /*刷新loading颜色*/
  public refreshLoadingColor: ResourceColor = "#333333"
  /*下拉刷新箭头*/
  public arrowImage: Resource = $r("app.media.zr_refresh_arrow")
  /*下拉刷新箭头颜色*/
  public arrowImageColor: ResourceColor = "#333333"
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
}