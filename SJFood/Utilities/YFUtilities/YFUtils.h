//
//  YFUtils.h
//  YFUtilities
//
//  Created by 叶帆 on 14-7-21.
//  Copyright (c) 2014年 yefan. All rights reserved.
//

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
*/

#ifndef YFUtils_YFUtils_h
#define YFUtils_YFUtils_h

#import "YFProgressHUD.h"
#import "YFDownloader.h"
#import "YFDownloaderManager.h"
#import "YFAsynImageView.h"
#import "YFImageDownloader.h"
#import "UIView+YFUtilities.h"
#import "YFWebViewController.h"
#import "YFAppBackgroudConfiger.h"
#import "YFBadgeView.h"
#import "YFMediaPicker.h"
#import "UIImage+YFUtilities.h"

#endif

#ifdef DEBUG
#define NSLog(fmt,...) do{NSLog(fmt,##__VA_ARGS__);} while(0)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)  do{}while(0)
#define debugMethod()
#endif
