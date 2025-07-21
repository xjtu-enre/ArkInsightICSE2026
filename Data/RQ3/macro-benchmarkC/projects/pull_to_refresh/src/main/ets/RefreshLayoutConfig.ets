export class RefreshLayoutConfig {
  /*是否是垂直列表*/
  public isVertical: boolean = true
  /*横向模式0：正常横向布局，1：header和footer逆时针旋转90度，2：header和footer顺时针旋转90度*/
  public horizontalMode: number = 0
  /*是否打开刷新*/
  public pullRefreshEnable: boolean = true
  /*是否打开加载更多*/
  public pullLoadEnable: boolean = true
  /*******************************刷新配置*******************************************/
  /*true:释放刷新，false下拉到一定距离刷新*/
  public releaseRefresh: boolean = true
  /*下拉最大距离*/
  public pullMaxDistance: number = 500
  /*下拉阻力*/
  public pullRefreshResistance: number = 0.5
  /*下拉距离超过多少时达到刷新条件*/
  public pullHeaderHeightRefresh: number = 0
  /*下拉打开其他页面开关*/
  public pullRefreshOpenPageEnable: boolean = false
  /*下拉距离超过多少时达到打开其他页面条件*/
  public pullHeaderHeightOpenPage: number = 0
  /*释放刷新时，回弹至headerView高度的时间*/
  public durationToHeader: number = 250
  /*头布局刷新结束时回弹的时间*/
  public durationCloseHeader: number = 200
  /*需要打开其他页面时，头布局的回弹时间*/
  public durationCloseForOpenPage: number = 180
  /*刷新时是否显示头view*/
  public refreshKeepHeader: boolean = true
  /*是否显示刷新成功状态的view*/
  public refreshShowSuccess: boolean = true;
  /*是否显示刷新失败状态的view*/
  public refreshShowError: boolean = true;
  /*刷新结果view显示持续时间*/
  public refreshResultDurationTime: number = 600



  /*******************************加载更多配置*******************************************/

  /*true:释放加载，false下拉到一定距离加载*/
  public releaseLoad: boolean = true
  /*上拉最大距离*/
  public pullLoadMaxDistance: number = 500
  /*上拉阻力*/
  public pullLoadResistance: number = 0.5
  /*上拉距离超过多少时达到刷新条件*/
  public pullFooterHeightLoad: number = 0
  /*上拉打开其他页面开关*/
  public pullLoadOpenPageEnable: boolean = false
  /*上拉距离超过多少时达到打开其他页面条件*/
  public pullFooterHeightOpenPage: number = 0
  /*释放刷新时，回弹至footerView高度的时间*/
  public durationToFooter: number = 250
  /*footer布局刷新结束时回弹的时间*/
  public durationCloseFooter: number = 200
  /*需要打开其他页面时，头布局的回弹时间*/
  public durationCloseLoadForOpenPage: number = 180
  /*刷新时是否显示footerView*/
  public loadKeepFooter: boolean = true
  /*是否显示刷新成功状态的view*/
  public loadShowSuccess: boolean = true;
  /*是否显示刷新失败状态的view*/
  public loadShowError: boolean = true;
  /*刷新结果view显示持续时间*/
  public loadResultDurationTime: number = 600
}