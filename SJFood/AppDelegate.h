//
//  AppDelegate.h
//  SJFood
//
//  Created by 叶帆 on 14/11/25.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StartViewController.h"
#import "RootTabBarViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudCrashReporting/AVOSCloudCrashReporting.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) StartViewController *startViewController;
@property (strong, nonatomic) RootTabBarViewController *rootTabBarViewController;
@property (strong, nonatomic) Reachability *hostReachability;

@end

