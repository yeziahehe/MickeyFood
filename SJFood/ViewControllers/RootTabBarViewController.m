//
//  RootTabBarViewController.m
//  SJFood
//
//  Created by 叶帆 on 14/11/25.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "RootTabBarViewController.h"

@interface RootTabBarViewController ()

@end

@implementation RootTabBarViewController

#pragma mark - UIViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tabBar.tintColor = kMainProjColor;
    self.tabBar.barTintColor = [UIColor colorWithRed:232.f/255 green:232.f/255 blue:232.f/255 alpha:1.f];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *naviController = (UINavigationController *)viewController;
        id vc = [naviController topViewController];
        // to do
    }
    return YES;
}

@end
