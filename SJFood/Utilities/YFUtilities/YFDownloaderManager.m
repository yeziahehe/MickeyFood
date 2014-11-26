//
//  YFDownloaderManager.m
//  V2EX
//
//  Created by 叶帆 on 14-9-20.
//  Copyright (c) 2014年 yefan. All rights reserved.
//

#import "YFDownloaderManager.h"
#import "YFDownloader.h"

@interface YFDownloaderManager ()
/**
 用reuse的方式获取downloader，如果当前downloader已存在并处于downloading中，则cancel掉，再reuse
 receiver和purpose用来标识downloader的唯一性，两个不能同时为nil
 @param receiver downloader的callback
 @param purpose  downloader的purpose
 @returns 返回manager中空闲YFDownloader实例
 */
- (YFDownloader *)reuseDownloaderWithDelegate:(id<YFDownloaderDelegate>)receiver
                                      purpose:(NSString*)purpose;

/**
 建立网络请求，判断receiver和purpose不可以同时为nil(crash)
 @param urlRequest 请求的url request
 @param receiver   请求之后的callback
 @param purpose    请求的purpose
 */
- (void)requestDataWithURLRequest:(NSURLRequest *)urlRequest
                         delegate:(id<YFDownloaderDelegate>)receiver
                          purpose:(NSString *)purpose;

@end

@implementation YFDownloaderManager

@synthesize downloaders;

#pragma mark - Singleton methods
+ (YFDownloaderManager *)sharedManager
{
    static YFDownloaderManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YFDownloaderManager alloc] init];
    });
    return manager;
}

- (id)init
{
    if(self = [super init])
    {
        self.downloaders = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc
{
    
}

#pragma mark - Private methods
- (YFDownloader *)reuseDownloaderWithDelegate:(id<YFDownloaderDelegate>)receiver
                                      purpose:(NSString*)purpose
{
    //如果当前的download已经存在，将request cancel，再从空闲的downloader中取出reuse
    [self cancelDownloaderWithDelegate:receiver purpose:purpose];
    
    YFDownloader *downloader = nil;
    
    for(YFDownloader *down in downloaders)
    {
        if(nil == downloader)
        {
            if(down.status == kDownloadCanceled || down.status == kDownloadFailed || down.status == kDownloadSucceed)
            {
                downloader = down;
                downloader.status = kDownloadWaiting;
            }
        }
    }
    
    if(nil == downloader)
    {
        downloader = [[YFDownloader alloc] init];
        [downloaders addObject:downloader];
    }
    return downloader;
}


- (void)requestDataWithURLRequest:(NSURLRequest *)urlRequest
                         delegate:(id<YFDownloaderDelegate>)receiver
                          purpose:(NSString *)purpose
{
    if(nil == receiver && nil == purpose)
    {
        NSAssert(nil, @"receiver and purpose can not be nil together.");
    }
    YFDownloader *downloader = [self reuseDownloaderWithDelegate:receiver purpose:purpose];
    [downloader startDownloadWithRequest:urlRequest callback:receiver purpose:purpose];
}

#pragma mark - Public methods
#pragma mark Cancel request methods
- (void)cancelDownloaderWithDelegate:(id)receiver
                             purpose:(NSString *)purpose
{
    if(!receiver && !purpose)
    {
        //cancel所有下载中的downloader
        for(YFDownloader *down in downloaders)
        {
            if(down.status == kDownloading)
                [down cancelDownload];
        }
    }
    else if(receiver && !purpose)
    {
        //cancel所有下载中且delegate = receiver的downloader
        for(YFDownloader *down in downloaders)
        {
            if(down.delegate == receiver && down.status == kDownloading )
                [down cancelDownload];
        }
    }
    else if(!receiver && purpose)
    {
        //cancel所有下载中且purpose equal的downloader
        for(YFDownloader *down in downloaders)
        {
            if([down.purpose isEqualToString:purpose] && down.status == kDownloading)
                [down cancelDownload];
        }
    }
    else
    {
        //cancel所有下载中且purpose equal且delegate = receiver的downloader
        for(YFDownloader *down in downloaders)
        {
            if(down.delegate == receiver && [down.purpose isEqualToString:purpose] && down.status == kDownloading)
                [down cancelDownload];
        }
    }
}

- (void)removeUnuseDownloaders
{
    NSInteger index = 0;
    NSMutableIndexSet *unuseSet = [NSMutableIndexSet indexSet];
    for(YFDownloader *down in downloaders)
    {
        if(down.status != kDownloading)
            [unuseSet addIndex:index];
        index++;
    }
    [downloaders removeObjectsAtIndexes:unuseSet];
}

- (void)reloadNetworkActivityIndicator
{
    BOOL show = NO;
    for(YFDownloader *down in downloaders)
    {
        if(down.status == kDownloading)
        {
            show = YES;
            break;
        }
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = show;
}

#pragma mark Call server methods
- (void)requestDataByGetWithURLString:(NSString *)urlStr
                             delegate:(id<YFDownloaderDelegate>)receiver
                              purpose:(NSString *)purpose
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.f];
    [self requestDataWithURLRequest:request delegate:receiver purpose:purpose];
}

- (void)requestDataByPostWithURLString:(NSString *)urlStr
                            postParams:(NSMutableDictionary *)params
                           contentType:(NSString *)contentType
                              delegate:(id<YFDownloaderDelegate>)receiver
                               purpose:(NSString *)purpose
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setHTTPMethod:@"POST"];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    NSString *realString = nil;
    if([contentType rangeOfString:@"json"].length > 0)
    {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
        realString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    else
    {
        if(params && params.allKeys.count != 0)
        {
            NSMutableString *bodyString = [NSMutableString string];
            for(NSString *key in [params allKeys])
            {
                NSString *value = [NSString stringWithFormat:@"%@",[params objectForKey:key]];
                [bodyString appendFormat:@"%@=%@&",key,value];
            }
            realString = [bodyString substringToIndex:(bodyString.length-1)];
        }
        else
            realString = @"";
    }
    NSData *paramData = [realString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:paramData];
    
    [self requestDataWithURLRequest:request delegate:receiver purpose:purpose];
}

@end
