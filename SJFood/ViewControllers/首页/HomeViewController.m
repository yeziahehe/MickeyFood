//
//  HomeViewController.m
//  SJFood
//
//  Created by 叶帆 on 14/11/27.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeSubView.h"
#import "SearchHistoryViewController.h"
#import "FoodViewController.h"
#import "HomeModuleView.h"

#define kHomeMapFileName        @"HomeMap"
#define kSubViewGap             0.f
#define kGetMainNewsDownloadKey @"GetMainNewsDownloadKey"

@interface HomeViewController ()
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *subViewArray;
@property (strong, nonatomic) NSMutableArray *newsListArray;
@end

@implementation HomeViewController

@synthesize contentScrollView,subViewArray,newsListArray;
@synthesize searchBar;

#pragma mark - Private Methods
- (void)loadSearchBar
{
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    [self.searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.searchBar sizeToFit];
    [self.searchBar setPlaceholder:@"搜索美食"];
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    UITextField *searchField = [self.searchBar valueForKey:@"_searchField"];
    // Change search bar text color
    searchField.textColor = [UIColor whiteColor];
    // Change the search bar placeholder text color
    [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    // Change the search icon
    UIImage *image = [UIImage imageNamed: @"icon_search.png"];
    UIImageView *iView = [[UIImageView alloc] initWithImage:image];
    iView.frame = CGRectMake(0, 0, 16, 16);
    searchField.leftView  = iView;
    self.navigationItem.titleView = self.searchBar;
}

- (void)loadSubViews
{
    for (UIView *subView in self.contentScrollView.subviews)
    {
        if ([subView isKindOfClass:[HomeSubView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:kHomeMapFileName ofType:@"plist"];
    self.subViewArray = [NSMutableArray arrayWithContentsOfFile:path];
    
    //加载每个子模块
    CGFloat originY = 0.f;
    [self.contentScrollView layoutIfNeeded];
    for (NSString *classString in self.subViewArray) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:classString owner:self options:nil];
        HomeSubView *homeSubView = [nibs lastObject];
        CGRect rect = homeSubView.frame;
        rect.size.width = ScreenWidth;
        rect.origin.y = originY;
        rect.origin.x = 0.0f;
        if ([homeSubView isKindOfClass:[ImagesContainView class]]) {
            ImagesContainView *icv = (ImagesContainView *)homeSubView;
            //rect.size.height = icv.frame.size.height/320 * ScreenWidth;
            //rect.size.height = ScreenHeight - 49.f - 64.f - 276.f*ScreenWidth/320.f;
            if (self.newsListArray.count > 0) {
                [icv reloadWithProductAds:self.newsListArray];
            }
        }
        else if ([homeSubView isKindOfClass:[HomeModuleView class]]) {
            HomeModuleView *hmv = (HomeModuleView *)homeSubView;
            rect.size.height = hmv.frame.size.height/320 * ScreenWidth;
        }
        homeSubView.frame = rect;
        [self.contentScrollView addSubview:homeSubView];
        originY = rect.origin.y + rect.size.height + kSubViewGap;
    }
    [self.contentScrollView setContentSize:CGSizeMake(ScreenWidth, originY)];
}

- (void)requestForNews
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kGetMainImageUrl];
    [[YFDownloaderManager sharedManager] requestDataByGetWithURLString:url
                                                              delegate:self
                                                               purpose:kGetMainNewsDownloadKey];
}

#pragma mark - NSNotification Methods
- (void)foodSearchWithNotification:(NSNotification *)notification
{
    FoodViewController *foodViewController = [[FoodViewController alloc] initWithNibName:@"FoodViewController" bundle:nil];
    [foodViewController requestForFoodSearchWithCategoryId:nil foodTag:notification.object sortId:@"0" page:@"0"];
    [self.navigationController pushViewController:foodViewController animated:YES];
}

#pragma mark - UIViewController Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self requestForNews];
    [self loadSearchBar];
    [self loadSubViews];
    [self setRightNaviItemWithTitle:nil imageName:@"icon_message.png"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foodSearchWithNotification:) name:kFoodSearchNotification object:nil];
}


#pragma mark - UISearchBar Delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    SearchHistoryViewController *searchHistoryViewController = [[SearchHistoryViewController alloc] initWithNibName:@"SearchHistoryViewController" bundle:nil];
    [self presentViewController:searchHistoryViewController animated:NO completion:nil];
    return NO;
}

#pragma mark - ImagesContainViewDelegate Methods
- (void)didTappedWithProductAd:(AdModel *)productAd
{
    //点击事件
}

#pragma mark - YFDownloaderDelegate Methods
- (void)downloader:(YFDownloader *)downloader completeWithNSData:(NSData *)data
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [str JSONValue];
    if ([downloader.purpose isEqualToString:kGetMainNewsDownloadKey])
    {
        if([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode])
        {
            self.newsListArray = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *valueArray = [dict objectForKey:@"newsList"];
            if (valueArray.count > 0) {
                for (NSDictionary *valueDict in valueArray) {
                    AdModel *ad = [[AdModel alloc]initWithDict:valueDict];
                    [self.newsListArray addObject:ad];
                }
            }
            [self loadSubViews];
        }
    }
    else
    {
        NSString *message = [dict objectForKey:kMessageKey];
        if ([message isKindOfClass:[NSNull class]])
        {
            message = @"";
        }
        if(message.length == 0)
            message = @"首页新闻获取失败";
    }
}

- (void)downloader:(YFDownloader *)downloader didFinishWithError:(NSString *)message
{
    [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:kNetWorkErrorString hideDelay:2.f];
}

@end
