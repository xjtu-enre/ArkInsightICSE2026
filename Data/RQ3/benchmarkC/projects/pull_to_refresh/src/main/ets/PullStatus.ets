export enum PullStatus {
  /*0默认状态(无下拉距离)*/
  DEF,
  /***********************************下拉状态*******************************************/
  /*1下拉状态*/
  PullDown,
  /*2下拉至可以刷新的状态(准备刷新)*/
  PreRefresh,
  /*3刷新中*/
  Refresh,
  /*4下拉超过刷新高度时准备打开其他页面*/
  PreOpenPage,
  /*5下拉超过刷新高度时松手打开其他页面*/
  OpenPage,
  /*6刷新成功*/
  RefreshSuccess,
  /*7刷新失败*/
  RefreshError,
  /***********************************上拉状态*******************************************/
  /*8上拉状态*/
  PullUp,
  /*9上拉至可以加载的状态(准备加载)*/
  PreLoad,
  /*10加载中*/
  Load,
  /*11上拉超过加载高度时准备打开其他页面*/
  PreLoadOpenPage,
  /*12上拉超过加载高度时松手打开其他页面*/
  LoadOpenPage,
  /*13加载成功*/
  LoadSuccess,
  /*14加载失败*/
  LoadError
}