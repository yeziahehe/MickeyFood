//
//  AppDelegate.m
//  SJFood
//
//  Created by 叶帆 on 14/11/25.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "AppDelegate.h"
#import <SMS_SDK/SMS_SDK.h>

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
/**
 *  清空通知数据
 */
- (void)clearNotifications
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

/**
 *  监听到网络状态变化
 *
 *  @param note 网络状态
 */
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
            [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:@"当前无网络连接" hideDelay:4.0f];
        }
    }
}

/**
 *  开启网络监听
 */
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
    //添加SMS应用
    [self connectShareSDK];
    //检测网络状态
    [self notifyNetworkStatus];
    //清空通知数据
    [self clearNotifications];
    
    self.window.tintColor = kMainProjColor;
    self.window.rootViewController = self.startViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    if (launchOptions)
    {
        [self dealNotificationWithLaunchOptions:launchOptions];
    }
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
    
    return YES;
}

#pragma mark - Push Notification Methods
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Prepare the Device Token for Registration (remove spaces and < >)
    NSString *devToken = [[[[deviceToken description]stringByReplacingOccurrencesOfString:@"<"withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""]stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSLog(@"device token: %@",devToken);
    if(devToken.length > 0)
    {
        [[NSUserDefaults standardUserDefaults] setObject:devToken forKey:kDeviceTokenKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([[MemberDataManager sharedManager] isLogin]) {
        [APService registerDeviceToken:deviceToken];
        [APService setTags:[NSSet setWithObject:[MemberDataManager sharedManager].loginMember.type] alias:[MemberDataManager sharedManager].loginMember.phone callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    }
}

-(void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet *)tags
                   alias:(NSString *)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"注册失败，无法获取设备ID, 具体错误: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self clearNotifications];
    [[MemberDataManager sharedManager] saveLoginMemberData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self clearNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Notification Methods
- (void)dealNotificationWithLaunchOptions:(NSDictionary *)launchOptions
{
    //根据不同的推送状态处理跳转页面
}

// The notification is delivered when the application is running in the foreground.
// 收到推送时，除了App未启动外（此时调用didFinishLaunchingWithOptions：），其余情形都调用此方法。
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive)
    {
        //do no action
    }
    else
    {
        if ([[userInfo objectForKey:@"aps"] objectForKey:@"alert"] != nil)
        {
            // 点击推送，启动应用时，并不调用到此方法。
            // 用于点击推送，将应用恢复到前台时使用。
            [[NSNotificationCenter defaultCenter] postNotificationName:kApnsNotification object:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]];
        }
    }
}

#pragma mark - ShareSDK methods
- (void)connectShareSDK
{
    //配置SMS
    [SMS_SDK registerApp:@"486f6cde1a52" withSecret:@"0af52d82128a9eadab1447b94435a47c"];
}

@end
