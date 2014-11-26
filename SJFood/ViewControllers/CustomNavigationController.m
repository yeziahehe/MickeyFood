//
//  CustomNavigationController.m
//  SJFood
//
//  Created by 叶帆 on 14/11/25.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "CustomNavigationController.h"

@interface CustomNavigationController ()

@end

@implementation CustomNavigationController

#pragma mark - UIViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationBar.barTintColor = kMainProjColor;//导航条的颜色
    self.navigationBar.tintColor = [UIColor whiteColor];//左侧返回按钮，文字的颜色
    self.interactivePopGestureRecognizer.delegate = self;
    self.delegate = self;
}

#pragma mark - Status bar methods
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
