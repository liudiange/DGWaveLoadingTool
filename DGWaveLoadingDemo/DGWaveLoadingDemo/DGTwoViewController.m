//
//  DGTwoViewController.m
//  DGWaveLoadingDemo
//
//  Created by 刘殿阁 on 2019/2/16.
//  Copyright © 2019 apple. All rights reserved.
//

#import "DGTwoViewController.h"
#import "WaveLoadingTool/DGWaveLoadingView.h"

@interface DGTwoViewController ()

@property(strong,nonatomic)DGWaveLoadingView *loadingView;

@end

@implementation DGTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 500)];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
    
}

- (IBAction)showAnimation:(UIButton *)sender {
    
  self.loadingView = [DGWaveLoadingView showLoadingTitle:@"RD" inView:self.view];
    
}
- (IBAction)hideAnimation:(UIButton *)sender {
    
   [DGWaveLoadingView hideLoadingAtView:self.view];
    
}
-(void)dealloc{
    NSLog(@"%s",__func__);
}
@end
