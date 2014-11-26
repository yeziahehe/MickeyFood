//
//  YFImageDownloader.m
//  V2EX
//
//  Created by 叶帆 on 14-9-24.
//  Copyright (c) 2014年 yefan. All rights reserved.
//

#import "YFImageDownloader.h"

@implementation YFImageDownloader
@synthesize delegate, purpose;
@synthesize activeDownload, theConnection;
@synthesize requestUrl;

#pragma mark Memory management
- (void)dealloc
{
    [theConnection cancel];
    theConnection = nil;
}

#pragma mark interface functions
- (void)startDownloadWithURL:(NSString*)url
{
    [self cancelDownload];
    self.requestUrl = url;
	NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                                                                      cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0] delegate:self];
    self.theConnection = conn;
	if (self.theConnection != nil) {
		NSMutableData *data = [[NSMutableData alloc] init];
        self.activeDownload = data;
	}
}
- (void)cancelDownload
{
	[self.theConnection cancel];
    self.theConnection = nil;
}

#pragma mark Download support (NSURLConnectionDelegate)
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [delegate downloader:self didFinishWithError:[NSString stringWithFormat:@"%@",error]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[delegate downloader:self completeWithNSData:activeDownload];
    self.activeDownload = nil;
}
@end
