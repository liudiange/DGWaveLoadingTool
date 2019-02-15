//
//  DGWaveLoadingView.m
//  DGWaveLoadingDemo
//
//  Created by apple on 2019/2/15.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "DGWaveLoadingView.h"
#import <objc/message.h>


#define DGContainerViewW 100
#define DGContainerTitleKey @"titleKey"

@interface DGWaveLoadingView ()
/** 定时器 */
@property (strong, nonatomic) CADisplayLink *link;
/** 曲线的振幅 */
@property (assign, nonatomic) CGFloat waveAmpliteude;
/** 角速度 */
@property (assign, nonatomic) CGFloat wavePalstance;
/** 曲线的出相 */
@property (assign, nonatomic) CGFloat waveX;
/** 曲线的偏距 */
@property (assign, nonatomic) CGFloat waveY;
/** 曲线的移动速度 */
@property (assign, nonatomic) CGFloat waveMoveSpeed;
/** 白底蓝字 */
@property (strong, nonatomic) UIImageView *blueImageView;
/** 蓝底白字 */
@property (strong, nonatomic) UIImageView *whiteImageView;
/** 动画的容器 */
@property (strong, nonatomic) UIView *containerView;
/** 需要显示的文字 */
@property (copy, nonatomic) NSString *displayTitle;

@end
@implementation DGWaveLoadingView
#pragma mark - 供外界调用的方法
/**
 在哪个view上来进行显示动画
 
 @param title 标题（不能超过）
 @param atView 需要在哪个view上进行显示
 */
+ (void)showLoadingTitle:(NSString *)title
                  inView:(UIView *)atView{
    NSAssert(title.length <= 3, @"对不起文字输入过多了兄弟，字符串的长度不能大于2奥");
    [[NSUserDefaults standardUserDefaults] setObject:title forKey:DGContainerTitleKey];
    
    DGWaveLoadingView *waveLoadingView = [[DGWaveLoadingView alloc] initWithFrame:atView.bounds];
    [atView addSubview:waveLoadingView];
    [waveLoadingView bringSubviewToFront:atView];
    
}
/**
 隐藏动画
 */
- (void)hideLoading{
    
}
#pragma mark - 本身需要实现的方法

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
        [self configData];
    }
    return self;
}
/**
 创建UI
 */
-(void)setUpUI{
    
    self.displayTitle = [[NSUserDefaults standardUserDefaults] objectForKey:DGContainerTitleKey];
    // 创建容器的view
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DGContainerViewW, DGContainerViewW)];
    self.containerView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    self.containerView.layer.cornerRadius = DGContainerViewW/2.0;
    self.containerView.layer.masksToBounds = YES;
    [self addSubview:self.containerView];
    
    // 创建底部图片白底蓝字
    NSDictionary *dic = @{
                         NSFontAttributeName : [UIFont systemFontOfSize:60],
                         NSForegroundColorAttributeName : [UIColor blueColor]
                         };
    UIImage *bottomImage = [DGWaveLoadingView imageWithColor:[UIColor clearColor] size:self.containerView.frame.size text:self.displayTitle textAttributes:dic circular:YES];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.containerView.bounds];
    imageView.image = bottomImage;
    [self.containerView addSubview:imageView];
    
    // 创建第二张图片 蓝底白字
    NSDictionary *blueDic1 = @{
                          NSFontAttributeName : [UIFont systemFontOfSize:60],
                          NSForegroundColorAttributeName : [UIColor whiteColor]
                          };
    UIImage *blueImage1 = [DGWaveLoadingView imageWithColor:[UIColor blueColor] size:self.containerView.frame.size text:self.displayTitle textAttributes:blueDic1 circular:YES];
    self.blueImageView = [[UIImageView alloc] initWithFrame:self.containerView.bounds];
    self.blueImageView.image = blueImage1;
    [self.containerView addSubview:self.blueImageView];
    // 创建遮罩
    UIView *maskView = [[UIView alloc] initWithFrame:self.blueImageView.frame];
    maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.blueImageView addSubview:maskView];
    
    // 创建第三张图片 蓝底白字
    NSDictionary *blueDic2 = @{
                              NSFontAttributeName : [UIFont systemFontOfSize:60],
                              NSForegroundColorAttributeName : [UIColor whiteColor]
                              };
    UIImage *blueImage2 = [DGWaveLoadingView imageWithColor:[UIColor blueColor] size:self.containerView.frame.size text:self.displayTitle textAttributes:blueDic2 circular:YES];
    self.blueImageView = [[UIImageView alloc] initWithFrame:self.containerView.bounds];
    self.blueImageView.image = blueImage2;
    [self.containerView addSubview:self.blueImageView];
    
}
/**
 设置数据的初始值相关
 */
- (void)configData{
    
}
#pragma mark - 其他的方法的响应
/**
 绘制图片
 
 @param color 背景色
 @param size 大小
 @param text 文字
 @param textAttributes 字体设置
 @param isCircular 是否圆形
 @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color
                          size:(CGSize)size
                          text:(NSString *)text
                textAttributes:(NSDictionary *)textAttributes
                      circular:(BOOL)isCircular
{
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // circular
    if (isCircular) {
        CGPathRef path = CGPathCreateWithEllipseInRect(rect, NULL);
        CGContextAddPath(context, path);
        CGContextClip(context);
        CGPathRelease(path);
    }
    
    // color
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    // text
    CGSize textSize = [text sizeWithAttributes:textAttributes];
    [text drawInRect:CGRectMake((size.width - textSize.width) / 2, (size.height - textSize.height) / 2, textSize.width, textSize.height) withAttributes:textAttributes];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
