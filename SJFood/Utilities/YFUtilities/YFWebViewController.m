//
//  YFWebViewController.m
//  SJFood
//
//  Created by 叶帆 on 14/12/2.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "YFWebViewController.h"
#import "NSString+HtmlCss.h"

@interface YFWebViewController ()

@property (nonatomic, copy) NSString *htmlString;

@end

@implementation YFWebViewController
@synthesize yfWebView,htmlPath,htmlTitle,htmlString,htmlType,fontSize,isContainCSS;

#pragma mark - Private methods
- (NSString *)bodyStringForHtmlString:(NSString *)wholeHtmlString
{
    NSRange startRange = [wholeHtmlString rangeOfString:@"<body>"];
    NSRange endRange = [wholeHtmlString rangeOfString:@"</body>"];
    NSString *bodyString = nil;
    @try {
        bodyString = [wholeHtmlString substringWithRange:NSMakeRange(startRange.location+6,endRange.location-startRange.location-6)];
    }
    @catch (NSException *exception) {
        bodyString = @"";
        NSLog(@"需要load的html资源<body>内容不合法.");
    }
    return bodyString;
}

#pragma mark - Public methods

- (void)loadHtmlResource
{
    self.htmlString = nil;
    if(self.htmlType == kLocalHtml)
    {
        //本地html资源
        if(self.isContainCSS)
        {
            self.htmlString = [NSString stringWithContentsOfFile:self.htmlPath encoding:NSUTF8StringEncoding error:nil];
        }
        else
        {
            NSString *wholeHtmlString = [NSString stringWithContentsOfFile:self.htmlPath encoding:NSUTF8StringEncoding error:nil];
            NSString *bodyString = [self bodyStringForHtmlString:wholeHtmlString];
            self.htmlString = [NSString adjustHtmlCSSForString:bodyString];
        }
        [self.yfWebView loadHTMLString:self.htmlString baseURL:nil];
    }
    else if (self.htmlType == kRemoteHtml)
    {
        //网络html资源
        if(self.isContainCSS)
        {
            [self.yfWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.htmlPath] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.f]];
        }
        else
        {
            [[YFDownloaderManager sharedManager] requestDataByGetWithURLString:self.htmlPath delegate:self purpose:nil];
        }
    }
}

#pragma mark - UIViewController methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:self.htmlTitle];
    [self loadHtmlResource];
}

- (void)dealloc
{
    [[YFDownloaderManager sharedManager] cancelDownloaderWithDelegate:self purpose:nil];
}

#pragma mark - UIWebViewDelegate methods
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *fs = nil;
    if(self.fontSize == kMinFontSize)
    {
        fs = @"80%";
    }
    else if(self.fontSize == kMiddleFontSize)
    {
        fs = @"100%";
    }
    else
    {
        fs = @"120%";
    }
    NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%@%%'", fs];
    [webView stringByEvaluatingJavaScriptFromString:jsString];
}

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    if(navigationType == UIWebViewNavigationTypeLinkClicked)
//    {
//        if([request.URL.absoluteString rangeOfString:@"tel:"].length > 0)
//        {
//            return YES;
//        }
//        else
//            return NO;
//    }
//    return YES;
//}
#pragma mark - YFDownloaderDelegate methods
- (void)downloader:(YFDownloader *)downloader completeWithNSData:(NSData*)data
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *bodyString = [self bodyStringForHtmlString:str];
    self.htmlString = [NSString adjustHtmlCSSForString:bodyString];
    [self.yfWebView loadHTMLString:self.htmlString baseURL:nil];
}

- (void)downloader:(YFDownloader *)downloader didFinishWithError:(NSString*)message
{
    [[YFProgressHUD sharedProgressHUD] showWithMessage:kNetWorkErrorString customView:nil hideDelay:4.f];
}

@end
