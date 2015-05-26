//
//  YFAppBackgroudConfiger.h
//  SJFood
//
//  Created by 叶帆 on 14/12/7.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

//该文件方法提取AppDelegate DidEnterBackground 方法中的常用操作，清除缓存，阻止云备份

@interface YFAppBackgroudConfiger : NSObject

//5.1之前版本不会有云备份，5.1之后会有document下的文件云备份，占用device空间，下面方法阻止云备份
//使用方法: [AppDelegateConfiger preventFilesFromBeingBackedupToiCloudWithSystemVersion:[[UIDevice currentDevice] systemVersion]]
+ (void)preventFilesFromBeingBackedupToiCloudWithSystemVersion:(NSString *)currSysVer;

//计算传递文件夹中所有文件大小，返回总大小，单位byte
+ (double)calculateCacheSizeWithCacheDirs:(NSArray *)dirs;

//清除指定文件夹的所有文件，成功返回yes，失败返回no
+ (BOOL)clearCachedWithCacheDirs:(NSArray *)dirs;

//清除Documents文件夹下的所有缓存文件
+ (void)clearAllCachesWhenBiggerThanSize:(double)size;

@end
