//
//  Constant.h
//  SJFood
//
//  Created by 叶帆 on 14/11/25.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

/*
 RootDirectory 是yefan创建的一个基本的项目模板，包含内容如下：
 AppDelegate                 - 包含了start - pannel的切换动画
 StartViewController         - 启动view，可加载广告
 PannelViewController        - root view，管理项目中所有子模块
 ModuleViewControlers        - 所有子模块
 
 使用方法：
 1. 复制一份原项目文件
 2. 替换项目名称
 3. 重新建立项目名称匹配的scheme
 4. 将各子模块加入ModuleViewControlers中
 
 --------------------------------------
 Utilities - yefan的常用库，可替换最新版本
 */

#ifndef RootDirectory_Constant_h
#define RootDirectory_Constant_h

//apple api
#define kAppAppleId         @"563444753"
#define kAppRateUrl         @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@"
#define kAppDownloadUrl     @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8"

//Constant Values
#define kMaxCacheSize 1000*1024*1024
#define IsIos8              [[UIDevice currentDevice].systemVersion floatValue]>=8.0?YES:NO
#define IsDevicePhone5      [UIScreen mainScreen].bounds.size.height==568.f?YES:NO
#define IsDevicePhone6      [UIScreen mainScreen].bounds.size.height==667.f?YES:NO
#define IsDevicePhone6P     [UIScreen mainScreen].bounds.size.height==736.f?YES:NO
#define ScreenWidth         [UIScreen mainScreen].bounds.size.width
#define ScreenHeight        [UIScreen mainScreen].bounds.size.height
#define kMainProjColor      [UIColor colorWithRed:240.f/255 green:97.f/255 blue:15.f/255 alpha:1.0f]
#define kMainBlackColor     [UIColor colorWithRed:30.f/255 green:30.f/255 blue:30.f/255 alpha:1.0f]
#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"]
#define kNetWorkErrorString @"网络错误"
#define kIsWelcomeShown     @"IsWelcomeShown"

//Notification Keys
#define kShowPannelViewNotification         @"ShowPannelViewNotification"
#define kShowLoginViewNotification          @"ShowLoginViewNotification"

#endif