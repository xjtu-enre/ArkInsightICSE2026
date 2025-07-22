
import { PullStatus } from './PullStatus'

export interface PullDown {
  /*是否是下拉*/
  isPullDown: boolean
  /*是否是上拉*/
  isPullUp: boolean
  /*是否触摸*/
  isTouch: boolean
  /*下拉距离*/
  distance: number
  /*上拉距离*/
  distanceLoad: number
  /*headerView高度*/
  headerViewSize: number
  /*footerView高度*/
  footerViewSize: number
  /*状态*/
  status: PullStatus
}