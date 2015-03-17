//
//  CustomNavigationController.m
//  SJFood
//
//  Created by 叶帆 on 14/11/25.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "CustomNavigationController.h"
#import "HomeViewController.h"

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
    self.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.interactivePopGestureRecognizer.delegate = self;
    self.delegate = self;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [super pushViewController:viewController animated:animated];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: kMainBlackColor};
    self.navigationBar.barTintColor = [UIColor whiteColor];//导航条的颜色
    self.navigationBar.tintColor = kMainProjColor;//左侧返回按钮，文字的颜色
    self.navigationBar.barStyle = UIBarStyleDefault;
}

#pragma mark - UINavigationControllerDelegate methods
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[HomeViewController class]])
    {
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
        self.navigationBar.barTintColor = kMainProjColor;//导航条的颜色
        self.navigationBar.tintColor = [UIColor whiteColor];//左侧返回按钮，文字的颜色
        self.navigationBar.barStyle = UIStatusBarStyleLightContent;
    }
}

@end
