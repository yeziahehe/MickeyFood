//
//  YFDownloader.m
//  V2EX
//
//  Created by 叶帆 on 14-9-20.
//  Copyright (c) 2014年 yefan. All rights reserved.
//

#import "YFDownloader.h"
#import "YFDownloaderManager.h"

@interface YFDownloader ()
- (void)clearData;//清除data操作
@end

@implementation YFDownloader

@synthesize purpose,urlRequest;
@synthesize theConnection,responseData;
@synthesize delegate,status;

#pragma mark - Memory management
- (id)init
{
    if(self = [super init])
    {
        status = kDownloadWaiting;
    }
    return self;
}

- (void)dealloc
{
    [self cancelDownload];
}

#pragma mark - Private methods
- (void)clearData
{
    self.responseData = nil;
    self.theConnection = nil;
    self.purpose = nil;
    self.urlRequest = nil;
}

#pragma mark - Public methods
- (void)refresh
{
    [theConnection cancel];
    self.theConnection = nil;
    self.responseData = nil;
    [self startDownloadWithRequest:self.urlRequest callback:self.delegate purpose:self.purpose];
}

- (void)startDownloadWithRequest:(NSURLRequest *)request
                        callback:(id<YFDownloaderDelegate>)receiver
                         purpose:(NSString *)pur
{
    self.urlRequest = request;
    self.delegate = receiver;
    self.purpose = pur;
    self.status = kDownloading;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSMutableData *data = [[NSMutableData alloc] init];
    self.responseData = data;
    self.theConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}
- (void)cancelDownload
{
	[theConnection cancel];
    [self clearData];
    self.status = kDownloadCanceled;
    [[YFDownloaderManager sharedManager] reloadNetworkActivityIndicator];
}

#pragma mark - NSURLConnectionDelegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse * httpResponse;
	httpResponse = (NSHTTPURLResponse *) response;
	assert( [httpResponse isKindOfClass:[NSHTTPURLResponse class]] );
	if ((httpResponse.statusCode / 100) != 2)
	{
        /**
         HTTP协议状态码表示的意思主要分为五类 ,大体是 :
         1×× 　　保留
         2×× 　　表示请求成功地接收                 - Successful
         3×× 　　为完成请求客户需进一步细化请求       - Redirection
         4×× 　　客户错误                         - Client Error
         5×× 　　服务器错误                       - Server Error
         */
        
        [connection cancel];
		[self connection:connection didFailWithError:[NSError errorWithDomain:@"response error" code:httpResponse.statusCode userInfo:nil]];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if([delegate respondsToSelector:@selector(downloader:didFinishWithError:)])
        [delegate downloader:self didFinishWithError:[NSString stringWithFormat:@"%@",error]];
    [self clearData];
    self.status = kDownloadFailed;
    [[YFDownloaderManager sharedManager] reloadNetworkActivityIndicator];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if([delegate respondsToSelector:@selector(downloader:completeWithNSData:)])
        [delegate downloader:self completeWithNSData:responseData];
    [self clearData];
    self.status = kDownloadSucceed;
    [[YFDownloaderManager sharedManager] reloadNetworkActivityIndicator];
}
@end
