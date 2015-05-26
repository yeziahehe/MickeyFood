//
//  YFFramework.h
//  YFFramework
//
//  Created by 叶帆 on 15/5/24.
//  Copyright (c) 2015年 Fan Ye. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for YFFramework.
FOUNDATION_EXPORT double YFFrameworkVersionNumber;

//! Project version string for YFFramework.
FOUNDATION_EXPORT const unsigned char YFFrameworkVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <YFFramework/PublicHeader.h>

/**
 必要的denpendencies
 <QuartzCore/QuartzCore.h>          --YFBadgeView
 <CoreLocation/CoreLocation.h>      --YFMediaPicker
 
 版本日志
 -v1.0
 引入常用的网络库，图片下载库，小菊花，动画库
 -v1.1
 加入缓存计算清除的库
 -v1.2
 加入角标库
 -v1.3
 加入照片选择库
 -v1.4
 加入iOS8下tableview分割线的问题
 -v1.5
 加入截屏和毛玻璃效果
 -v1.6
 加入头图海报通用类和计算cell中label，text高度的类
 */

#import <YFFramework/YFProgressHUD.h>
#import <YFFramework/YFDownloader.h>
#import <YFFramework/YFDownloaderManager.h>
#import <YFFramework/YFAsynImageView.h>
#import <YFFramework/YFImageDownloader.h>
#import <YFFramework/UIView+YFUtilities.h>
#import <YFFramework/YFAppBackgroudConfiger.h>
#import <YFFramework/YFBadgeView.h>
#import <YFFramework/YFMediaPicker.h>
#import <YFFramework/UIImage+YFUtilities.h>
#import <YFFramework/UITableView+YFAdditions.h>
#import <YFFramework/UITableViewCell+YFAdditions.h>
#import <YFFramework/UIImage+YFBlurGlass.h>
#import <YFFramework/UIImage+YFScreenShot.h>
#import <YFFramework/YFCycleScrollView.h>
#import <YFFramework/YFCommonMethods.h>
#import <YFFramework/NSString+HtmlCss.h>


#ifdef DEBUG
#define NSLog(fmt,...) do{NSLog(fmt,##__VA_ARGS__);} while(0)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)  do{}while(0)
#define debugMethod()
#endif


