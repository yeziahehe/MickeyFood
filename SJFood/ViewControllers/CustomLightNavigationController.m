//
//  CustomLightNavigationController.m
//  SJFood
//
//  Created by 叶帆 on 14/12/1.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "CustomLightNavigationController.h"

@interface CustomLightNavigationController ()

@end

@implementation CustomLightNavigationController

#pragma mark - UIViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: kMainBlackColor};
    self.navigationBar.barTintColor = [UIColor whiteColor];//导航条的颜色
    self.navigationBar.tintColor = kMainBlackColor;//左侧返回按钮，文字的颜色
    self.interactivePopGestureRecognizer.delegate = self;
    self.delegate = self;
}

#pragma mark - Status bar methods
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

@end
