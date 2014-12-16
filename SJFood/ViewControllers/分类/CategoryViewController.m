//
//  CategoryViewController.m
//  SJFood
//
//  Created by 叶帆 on 14/12/14.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "CategoryViewController.h"
#import "FoodCategory.h"
#import "CategorySubView.h"
#import "CategoryTableView.h"
#import "CategoryCollectionView.h"

#define kGetFoodCategoryDownloaderKey       @"GetFoodCategoryDownloaderKey"

@interface CategoryViewController ()
@property (nonatomic, strong) NSMutableArray *categoryTableArray;
@property (nonatomic, strong) NSMutableArray *categoryCollectionArray;
@property (nonatomic, assign) CGFloat originX;
@end

@implementation CategoryViewController
@synthesize categoryTableArray,categoryCollectionArray;

#pragma mark - Private Methods
- (void)loadSubViews
{
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[CategorySubView class]]) {
            [subView removeFromSuperview];
        }
    }
    //加载UITableView
    CategoryTableView *ctv = [[[NSBundle mainBundle] loadNibNamed:@"CategoryTableView" owner:self options:nil] lastObject];
    CGRect rect = ctv.frame;
    rect.origin.y = 64.0f;
    rect.origin.x = 0.0f;
    [ctv reloadWithCategory:self.categoryTableArray];
    ctv.frame = rect;
    self.originX = ctv.frame.size.width;
    [self.view addSubview:ctv];
    
    //加载UITableView
    FoodCategory *fd = [self.categoryTableArray objectAtIndex:0];
    self.categoryCollectionArray = [NSMutableArray arrayWithArray:fd.child];
    CategoryCollectionView *ccv = [[[NSBundle mainBundle] loadNibNamed:@"CategoryCollectionView" owner:self options:nil] lastObject];
    rect = ccv.frame;
    rect.origin.y = 64.f;
    rect.origin.x = self.originX;
    [ccv reloadWithCategory:self.categoryCollectionArray];
    ccv.frame = rect;
    [self.view addSubview:ccv];
}

- (void)requestForGetFoodCategory
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kGetFoodCategoryUrl];
    [[YFDownloaderManager sharedManager] requestDataByGetWithURLString:url
                                                              delegate:self
                                                               purpose:kGetFoodCategoryDownloaderKey];
}

#pragma mark - Notification Methods
- (void)categoryTableViewSelected:(NSNotification *)notification
{
    NSNumber *number = [notification object];
    NSInteger index = [number integerValue];
    FoodCategory *fd = [self.categoryTableArray objectAtIndex:index];
    self.categoryCollectionArray = [NSMutableArray arrayWithArray:fd.child];
    // load collection view
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[CategoryCollectionView class]]) {
            [subView removeFromSuperview];
        }
    }
    //加载UITableView
    CategoryCollectionView *ccv = [[[NSBundle mainBundle] loadNibNamed:@"CategoryCollectionView" owner:self options:nil] lastObject];
    CGRect rect = ccv.frame;
    rect.origin.y = 64.f;
    rect.origin.x = self.originX;
    [ccv reloadWithCategory:self.categoryCollectionArray];
    ccv.frame = rect;
    [self.view addSubview:ccv];
}

#pragma mark - UIViewController Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self requestForGetFoodCategory];
    self.categoryTableArray = [NSMutableArray arrayWithCapacity:0];
    if ([[CacheManager sharedManager] category]) {
        for (NSDictionary *valueDict in [[CacheManager sharedManager] category]) {
            FoodCategory *fc = [[FoodCategory alloc]initWithDict:valueDict];
            [self.categoryTableArray addObject:fc];
        }
        [self loadSubViews];
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryTableViewSelected:) name:kCategoryTableViewSelectedNotificaition object:nil];
}

- (void)dealloc
{
    [[YFDownloaderManager sharedManager] cancelDownloaderWithDelegate:self purpose:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - YFDownloaderDelegate Methods
- (void)downloader:(YFDownloader *)downloader completeWithNSData:(NSData *)data
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [str JSONValue];
    if ([downloader.purpose isEqualToString:kGetFoodCategoryDownloaderKey])
    {
        if([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode])
        {
            self.categoryTableArray = [NSMutableArray arrayWithCapacity:0];
            NSArray *valueArray = [dict objectForKey:@"foodFirstCategory"];
            for (NSDictionary *valueDict in valueArray) {
                FoodCategory *fc = [[FoodCategory alloc]initWithDict:valueDict];
                [self.categoryTableArray addObject:fc];
            }
            [[CacheManager sharedManager] cacheCategoryWithArray:self.categoryTableArray];
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
                message = @"获取挑食信息失败";
            [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:message hideDelay:2.f];
        }
    }
}

- (void)downloader:(YFDownloader *)downloader didFinishWithError:(NSString *)message
{
    NSLog(@"%@",message);
    [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:kNetWorkErrorString hideDelay:2.f];
}


@end
