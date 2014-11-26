//
//  YFDownloaderManager.h
//  V2EX
//
//  Created by 叶帆 on 14-9-20.
//  Copyright (c) 2014年 yefan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YFDownloaderManager : NSObject

/**
 request的receiver和purpose不可以同时为nil，这样cancel的时候会cancel掉所有的downloader，而无法确定具体某一个
 当receiver != nil时，相同receiver下的purpose不可以相同，如果相同会cancel掉同一个receiver下前面的downloader
 当receiver == nil时，manager中的所有purpose不可以相同，如果相同会cancel掉所有的downloader
 */

/**
 进行downloader的队列数组
*/
@property (nonatomic, strong) NSMutableArray *downloaders;

+ (YFDownloaderManager *)sharedManager;

- (void)removeUnuseDownloaders;
- (void)reloadNetworkActivityIndicator;

/**
 根据receiver和purpose取消队列中的downloader request，但downloader没有释放
 使用类似notification:name:object的管理方式
 当receiver=nil && purpose == nil，则取消所有downloader request
 @param receiver 取消delegate=receiver的所有downloader request
 @param purpose  取消purpose equal的所有downloader request
 */
- (void)cancelDownloaderWithDelegate:(id)receiver
                             purpose:(NSString *)purpose;

/**
 post方式与server交互
 @param urlStr 请求地址
 @param params 请求参数
 @param contentType 请求的Content-Type， 如application/x-www-form-urlencoded/ text/html
 @param receiver 接受callback的对象
 @param purpose downloader的purpose
 */
- (void)requestDataByPostWithURLString:(NSString *)urlStr
                            postParams:(NSMutableDictionary *)params
                           contentType:(NSString *)contentType
                              delegate:(id)receiver
                               purpose:(NSString *)purpose;

/**
 get方式与server交互
 @param urlStr 请求地址
 @param receiver 接受callback的对象
 @param purpose downloader的purpose
 */
- (void)requestDataByGetWithURLString:(NSString *)urlStr
                             delegate:(id)receiver
                              purpose:(NSString *)purpose;

@end
