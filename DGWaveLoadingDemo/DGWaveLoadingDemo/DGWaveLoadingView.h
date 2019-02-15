//
//  DGWaveLoadingView.h
//  DGWaveLoadingDemo
//
//  Created by apple on 2019/2/15.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DGWaveLoadingView : UIView


/**
 在哪个view上来进行显示动画
 
 @param title 标题（不能超过）
 @param atView 需要在哪个view上进行显示
 @return 对象本身
 */
+ (DGWaveLoadingView *)showLoadingTitle:(NSString *)title
                  inView:(UIView *)atView;
/**
 隐藏动画
 */
- (void)hideLoading;

@end

NS_ASSUME_NONNULL_END
