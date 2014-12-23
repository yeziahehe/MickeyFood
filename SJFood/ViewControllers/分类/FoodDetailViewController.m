//
//  FoodDetailViewController.m
//  SJFood
//
//  Created by 叶帆 on 14/12/20.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "FoodDetailViewController.h"
#import "FoodDetailSubView.h"
#import "FoodHeaderView.h"
#import "FoodParamView.h"
#import "FoodCommentView.h"
#import "FoodImageDetailView.h"

#define kGetFoodByIdDownloaderKey         @"GetFoodByIdDownloaderKey"
#define kFoodDetailMapFileName            @"FoodDetailMap"
#define kSubViewGap                     15.f

@interface FoodDetailViewController ()
@property (nonatomic, strong) NSMutableArray *subViewArray;
@property (nonatomic, strong) FoodDetail *foodDetail;
@end

@implementation FoodDetailViewController
@synthesize contentScrollView;
@synthesize subViewArray,foodDetail,foodId;

#pragma mark - Private Methods
- (void)loadSubViews
{
    for (UIView *subView in self.contentScrollView.subviews)
    {
        if ([subView isKindOfClass:[FoodDetailSubView class]]) {
            [subView removeFromSuperview];
        }
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:kFoodDetailMapFileName ofType:@"plist"];
    self.subViewArray = [NSMutableArray arrayWithContentsOfFile:path];
    //加载每个子模块
    CGFloat originY = 0.0f;
    for (NSString *classString in self.subViewArray) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:classString owner:self options:nil];
        FoodDetailSubView *foodDetailSubView = [nibs lastObject];
        CGRect rect = foodDetailSubView.frame;
        rect.origin.y = originY;
        rect.origin.x = (self.contentScrollView.frame.size.width-rect.size.width)/2;
        if ([foodDetailSubView isKindOfClass:[FoodHeaderView class]]) {
            FoodHeaderView *fhv = (FoodHeaderView *)foodDetailSubView;
            [fhv reloadWithFoodDetail:self.foodDetail];
            rect.size.height = fhv.frame.size.height;
        }
        else if ([foodDetailSubView isKindOfClass:[FoodParamView class]]) {
            FoodParamView *fpv = (FoodParamView *)foodDetailSubView;
            [fpv reloadWithFoodDetail:self.foodDetail];
            rect.size.height = fpv.frame.size.height;
        }
        else if ([foodDetailSubView isKindOfClass:[FoodCommentView class]]) {
            FoodCommentView *fcv = (FoodCommentView *)foodDetailSubView;
            [fcv reloadWithFoodDetail:self.foodDetail];
            rect.size.height = fcv.frame.size.height;
        }
        else if ([foodDetailSubView isKindOfClass:[FoodImageDetailView class]]) {
            FoodImageDetailView *fidv = (FoodImageDetailView *)foodDetailSubView;
            [fidv reloadWithFoodDetail:self.foodDetail];
            rect.size.height = fidv.webview.scrollView.contentSize.height + 35.f;
        }
        foodDetailSubView.frame = rect;
        [self.contentScrollView addSubview:foodDetailSubView];
        originY = rect.origin.y + rect.size.height + kSubViewGap;
    }
    [self.contentScrollView setContentSize:CGSizeMake(self.contentScrollView.frame.size.width, originY+60)];
}

- (void)requestForFoodDetail
{
    if (nil == self.foodId)
        self.foodId = @"";
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kGetFoodByIdUrl];
    NSMutableDictionary *dict = kCommonParamsDict;
    [dict setObject:self.foodId forKey:@"foodId"];
    [[YFDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:dict
                                                            contentType:@"application/x-www-form-urlencoded"
                                                               delegate:self
                                                                purpose:kGetFoodByIdDownloaderKey];
}

#pragma mark - BaseViewController methods
- (void)extraItemTapped
{
    [self.contentScrollView setContentOffset:CGPointMake(0, -self.contentScrollView.contentInset.top) animated:YES];
}

#pragma mark - UIViewController Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"宝贝详情"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self requestForFoodDetail];
}

- (void)dealloc
{
    [[YFDownloaderManager sharedManager]cancelDownloaderWithDelegate:self purpose:nil];
}

#pragma mark - YFDownloaderDelegate Methods
- (void)downloader:(YFDownloader *)downloader completeWithNSData:(NSData *)data
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [str JSONValue];
    if ([downloader.purpose isEqualToString:kGetFoodByIdDownloaderKey])
    {
        if([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode])
        {
            self.foodDetail = [FoodDetail foodDetailWithDict:[dict objectForKey:@"food"]];
            [self loadSubViews];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if ([message isKindOfClass:[NSNull class]])
            {
                message = @"";
            }
            if(message.length == 0)
                message = @"宝贝详情获取失败";
            [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:message hideDelay:2.f];
        }
    }
}

- (void)downloader:(YFDownloader *)downloader didFinishWithError:(NSString *)message
{
    [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:kNetWorkErrorString hideDelay:2.f];
}
@end
