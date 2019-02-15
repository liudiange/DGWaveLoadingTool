//
//  ViewController.m
//  DGWaveLoadingDemo
//
//  Created by apple on 2019/2/15.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "ViewController.h"
#import "DGWaveLoadingView.h"

@interface ViewController ()

@property (nonatomic,strong) DGWaveLoadingView *loadingView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

/**
 开始动画

 @param sender 按钮
 */
- (IBAction)showAaimation:(UIButton *)sender {
    self.loadingView = [DGWaveLoadingView showLoadingTitle:@"RD" inView:self.view];
}

/**
 改变文字

 @param sender 按钮
 */
- (IBAction)changeText:(UIButton *)sender {
    self.loadingView = [DGWaveLoadingView showLoadingTitle:@"AB" inView:self.view];
}

/**
 停止动画

 @param sender 按钮
 */
- (IBAction)stopAnimation:(UIButton *)sender {
    [self.loadingView hideLoading];
}

@end
