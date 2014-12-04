//
//  RootTabBarViewController.m
//  SJFood
//
//  Created by 叶帆 on 14/11/25.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "RootTabBarViewController.h"
#import "UserInfoViewController.h"
#import "LoginViewController.h"

@interface RootTabBarViewController ()

@end

@implementation RootTabBarViewController

@synthesize loginNavController;

#pragma mark - Properties Methods
- (CustomLightNavigationController *)loginNavController {
    if (nil == loginNavController) {
        LoginViewController *loginViewController = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        loginNavController = [[CustomLightNavigationController alloc]initWithRootViewController:loginViewController];
    } else {
        [loginNavController popToRootViewControllerAnimated:YES];
    }
    return loginNavController;
}

#pragma mark - Notification Methods
- (void)showLoginViewWithNotification:(NSNotification *)notification
{
    if(self.presentedViewController)
        [self dismissViewControllerAnimated:NO completion:nil];
    [self presentViewController:self.loginNavController animated:YES completion:nil];
}

#pragma mark - UIViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tabBar.tintColor = kMainProjColor;
    self.tabBar.barTintColor = [UIColor colorWithRed:233.f/255 green:233.f/255 blue:233.f/255 alpha:1.f];
    self.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoginViewWithNotification:) name:kShowLoginViewNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - TabBarrController Delegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *naviController = (UINavigationController *)viewController;
        id vc = [naviController topViewController];
        // to do
        if ([vc isKindOfClass:[UserInfoViewController class]]) {
            if ([[MemberDataManager sharedManager] isLogin])
            {
                return YES;
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kShowLoginViewNotification object:nil];
                return NO;
            }
        }
    }
    return YES;
}

@end
