# 版本记录
### 1.1.5
1. 修复回弹过程header出现横线问题
2. PullToRefreshLayout默认根据传入的Scroller自动计算是否可以下拉

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