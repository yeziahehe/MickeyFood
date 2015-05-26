//
//  YFUtils.h
//  YFUtilities
//
//  Created by 叶帆 on 14-7-21.
//  Copyright (c) 2014年 yefan. All rights reserved.
//

#ifndef YFUtils_YFUtils_h
#define YFUtils_YFUtils_h

#import "YFWebViewController.h"

#endif

#ifdef DEBUG
#define NSLog(fmt,...) do{NSLog(fmt,##__VA_ARGS__);} while(0)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)  do{}while(0)
#define debugMethod()
#endif
