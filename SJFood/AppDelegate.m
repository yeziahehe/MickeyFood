//
//  AppDelegate.m
//  SJFood
//
//  Created by 叶帆 on 14/11/25.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize startViewController,rootTabBarViewController;
@synthesize hostReachability;

#pragma mark - Instance Methods
- (StartViewController *)startViewController
{
    if(nil == startViewController)
    {
        startViewController = [[StartViewController alloc] init];
    }
    return startViewController;
}

- (RootTabBarViewController *)rootTabBarViewController
{
    if(nil == rootTabBarViewController)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"RootTabBarViewController" owner:self options:nil];
        rootTabBarViewController = [nibs lastObject];
    }
    return rootTabBarViewController;
}

#pragma mark - Notification Methods
- (void)showPannelViewWithNotification:(NSNotification *)notification
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    if([notification.object isEqualToString:@"fromGuide"])
    {
        [self.window addAnimationWithType:kCATransitionPush subtype:kCATransitionFromRight];
    }
    else
    {
        [self.window addAnimationWithType:kCATransitionFade subtype:nil];
    }
    [self notifyNetworkStatus];
    self.window.rootViewController = self.rootTabBarViewController;
}

#pragma mark - Private Methods
- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability * reach = [note object];
    if(reach.currentReachabilityStatus != NotReachable)
    {
        //to do
    }
    else
    {
        if (self.window.rootViewController != self.startViewController) {
            // to do
            [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:@"当前无网络连接" hideDelay:2.0f];
        }
    }
}

- (void)notifyNetworkStatus
{
    self.hostReachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [self.hostReachability startNotifier];
}

#pragma mark - Application Methods
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPannelViewWithNotification:) name:kShowPannelViewNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    [self notifyNetworkStatus];
    self.window.tintColor = kMainProjColor;
    self.window.rootViewController = self.startViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
