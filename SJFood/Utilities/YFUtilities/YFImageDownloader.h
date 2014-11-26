//
//  YFImageDownloader.h
//  V2EX
//
//  Created by 叶帆 on 14-9-24.
//  Copyright (c) 2014年 yefan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YFImageDownloaderDelegate;

@interface YFImageDownloader : NSObject

@property (nonatomic, strong)NSString* purpose;
@property (nonatomic, strong) NSURLConnection *theConnection;
@property (nonatomic, strong) NSMutableData *activeDownload;
@property (nonatomic, copy) NSString *requestUrl;
@property (nonatomic, strong)id<YFImageDownloaderDelegate> delegate;
/**
 通过url开始下载图片
 @param url 图片下载的url
 */
- (void)startDownloadWithURL:(NSString*)url;
/**
 取消下载图片的请求
 */
- (void)cancelDownload;
@end

/**
 @protocol DownloaderDelegate
 */
@protocol YFImageDownloaderDelegate
- (void)downloader:(YFImageDownloader*)downloader completeWithNSData:(NSData*)data;
- (void)downloader:(YFImageDownloader*)downloader didFinishWithError:(NSString*)message;

@end
