//
//  DGWaveLoadingView.m
//  DGWaveLoadingDemo
//
//  Created by apple on 2019/2/15.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "DGWaveLoadingView.h"
#import "DGLinkProxy.h"
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
/** 动画的容器 */
@property (strong, nonatomic) UIView *containerView;


@end
@implementation DGWaveLoadingView

static NSString *displayTitle_ = nil;

#pragma mark - 供外界调用的方法
/**
 在哪个view上来进行显示动画
 
 @param title 标题（不能超过）
 @param atView 需要在哪个view上进行显示
 @return 对象本身
 */

+ (DGWaveLoadingView *)showLoadingTitle:(NSString *)title
                  inView:(UIView *)atView{
    NSAssert(title.length <= 2, @"对不起文字输入过多了兄弟，字符串的长度不能大于2奥");
    displayTitle_ = title;
    
    NSMutableArray *loadingViewArray = [NSMutableArray array];
    for (UIView * view in atView.subviews) {
        if ([view isKindOfClass:[DGWaveLoadingView class]]) {
            [loadingViewArray addObject:view];
        }
    }
    for (DGWaveLoadingView *loadingView in loadingViewArray) {
        [loadingView removeFromSuperview];
    }
    
    DGWaveLoadingView *waveLoadingView = [[DGWaveLoadingView alloc] initWithFrame:CGRectMake((atView.frame.size.width -DGContainerViewW) *0.5, (atView.frame.size.height -DGContainerViewW) *0.5, DGContainerViewW, DGContainerViewW)];
    [atView addSubview:waveLoadingView];
    return waveLoadingView;
}
/**
 隐藏动画
 */
- (void)hideLoading{
    
    if (self.link) {
        [self.link invalidate];
        self.link = nil;
    }
    displayTitle_ = nil;
    [self removeFromSuperview];
}
/**
 隐藏动画
 
 @param atView 在a那个views上开始隐藏
 */
+ (void)hideLoadingAtView:(UIView *)atView{
    
    NSMutableArray *temViewArray = [NSMutableArray array];
    NSEnumerator *enumerator = [atView.subviews reverseObjectEnumerator];
    
    for (UIView *sonView in enumerator) {
        if ([sonView isKindOfClass:[DGWaveLoadingView class]]) {
            [temViewArray addObject:sonView];
        }
    }
    for (DGWaveLoadingView *loadingView in temViewArray) {
        [loadingView removeFromSuperview];
    }
    temViewArray = nil;
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
    UIImage *bottomImage = [DGWaveLoadingView imageWithColor:[UIColor clearColor] size:self.containerView.frame.size text:displayTitle_ textAttributes:dic circular:YES];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.containerView.bounds];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.image = bottomImage;
    [self.containerView addSubview:imageView];
    
    // 创建第二张图片 蓝底白字
    NSDictionary *blueDic1 = @{
                          NSFontAttributeName : [UIFont systemFontOfSize:60],
                          NSForegroundColorAttributeName : [UIColor whiteColor]
                          };
    UIImage *blueImage1 = [DGWaveLoadingView imageWithColor:[UIColor blueColor] size:self.containerView.frame.size text:displayTitle_ textAttributes:blueDic1 circular:YES];
    self.blueImageView = [[UIImageView alloc] initWithFrame:self.containerView.bounds];
    self.blueImageView.image = blueImage1;
    self.blueImageView.backgroundColor = [UIColor blueColor];
    [self.containerView addSubview:self.blueImageView];
}
/**
 设置数据的初始值相关
 */
- (void)configData{
    self.waveAmpliteude = 6;
    self.wavePalstance = 0.08;
    self.waveY = self.containerView.frame.size.height * 0.5;
    self.waveX = 0;
    self.waveMoveSpeed = 0.15;
    
    self.link = [CADisplayLink displayLinkWithTarget:[DGLinkProxy initWithTarget:self] selector:@selector(updateWave)];
    [self.link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
}
/**
 定时器的方法
 */
- (void)updateWave{
    self.waveX -= self.waveMoveSpeed;
    [self beginWave];
}
/**
 开始波浪相关的动画
 */
- (void)beginWave{
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 0, self.waveY);
    // 指函数y=Asin(ωx+φ)+k(其中A，ω，φ均为常数，且A>0，ω>0)。这里A称为振幅，ω称为圆频率或角频率，φ称为初相位或初相角，正弦型函数y=Asin(ωx+φ)是周期函数，其周期为2π/ω
    CGFloat y = 0;
    for (float x = 0.0; x < self.containerView.frame.size.width; x++) {
        y = self.waveAmpliteude * sin(self.wavePalstance*x + self.waveX +1 ) + self.waveY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    CGPathAddLineToPoint(path, nil, self.containerView.frame.size.width, self.containerView.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.containerView.frame.size.height);
    CGPathCloseSubpath(path);
    
    CAShapeLayer *shapelayer = [CAShapeLayer layer];
    shapelayer.path = path;
    self.blueImageView.layer.mask = shapelayer;
    CGPathRelease(path);
    
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
-(void)dealloc{
    NSLog(@"%s",__func__);
    [self.link invalidate];
}

@end
