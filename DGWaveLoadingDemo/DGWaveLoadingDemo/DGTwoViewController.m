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
    // Do any additional setup after loading the view.
}

- (IBAction)showAnimation:(UIButton *)sender {
    
  self.loadingView = [DGWaveLoadingView showLoadingTitle:@"RD" inView:self.view];
    
}
- (IBAction)hideAnimation:(UIButton *)sender {
    
   [self.loadingView hideLoading];
    
}
-(void)dealloc{
    NSLog(@"%s",__func__);
}
@end
