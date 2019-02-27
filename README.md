# DGWaveLoadingTool
## DGWaveLoadingTool实现的功能类似于百度贴吧的波浪动画
具体效果如下：
![image](https://github.com/liudiange/DGWaveLoadingTool/blob/master/DGWaveLoadingDemo/DGWaveLoadingDemo/1.GIF)
- 不用图片
- 可以传递不同的文字
- 没有内存泄露的问题 不管执不执行隐藏的方法，在控制器销毁的时候都能将动画销毁。
## 实现的思路
![image](https://github.com/liudiange/DGWaveLoadingTool/blob/master/DGWaveLoadingDemo/DGWaveLoadingDemo/2.png)
##### 解释：
- 首先是创建一个loadingView 以及实现他的尺寸
- 在loadview上创建一个篮字白边的图片
- 在创建一个白字蓝边的图片
- 利用正弦函数和quartz 2D的知识 实现波动的动画

## 怎样使用
- 显示动画
````objc
[DGWaveLoadingView showLoadingTitle:@"RD" inView:self.view];
````
- 隐藏动画
````objc
[self.loadingView hideLoading];
````
- 隐藏动画 
````objc
[DGWaveLoadingView hideLoadingAtView:self.view];
````
## 备注
- 以后有时间会增加更多的更能
- 代码的严谨性会继续修改
