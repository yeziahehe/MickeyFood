//
//  FoodViewController.m
//  SJFood
//
//  Created by 叶帆 on 14/12/17.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "FoodViewController.h"
#import "SearchHistoryViewController.h"
#import "FoodTableViewCell.h"
#import "FoodSelect.h"

#define kFoodSearchDownloaderKey        @"FoodSearchDownloaderKey"

@interface FoodViewController ()
@property (nonatomic, strong)UISearchBar *searchBar;
@property (nonatomic, strong)NSString *foodTag;
@property (nonatomic, strong)NSMutableArray *foodArray;
@property (nonatomic, strong)FoodSelect *food;
@end

@implementation FoodViewController
@synthesize sortByAllButton,sortByPriceButton,sortBySaleButton,foodTableView;
@synthesize searchBar,categoryId,foodTag,foodArray,food;

#pragma mark - Private Methods
- (void)loadSubViews
{
    self.foodTableView.tableFooterView = [UIView new];
    [self.foodTableView reloadData];
}

- (void)setNaviSearchTitle
{
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    [self.searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.searchBar sizeToFit];
    [self.searchBar setPlaceholder:@"搜索美食"];
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.navigationItem.titleView = self.searchBar;
}

- (void)requestForFoodSearchWithCategoryId:(NSString *)category foodTag:(NSString *)tag sortId:(NSString *)sortId page:(NSString *)page
{
    if (category == nil)
        category = @"";
    if (tag == nil)
        tag = @"";
    if (sortId == nil)
        sortId = @"0";
    if (page == nil)
        page = @"0";
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kFoodSearchUrl];
    NSMutableDictionary *dict = kCommonParamsDict;
    [dict setObject:category forKey:@"categoryId"];
    [dict setObject:tag forKey:@"foodTag"];
    [dict setObject:sortId forKey:@"sortId"];
    [dict setObject:page forKey:@"page"];
    [[YFProgressHUD sharedProgressHUD] showActivityViewWithMessage:@"加载中..."];
    [[YFDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:dict
                                                            contentType:@"application/x-www-form-urlencoded"
                                                               delegate:self
                                                                purpose:kFoodSearchDownloaderKey];
}

#pragma mark - IBAction Methods
- (IBAction)sortByAllButtonClicked:(id)sender {
    if (!self.sortByAllButton.selected)
    {
        self.sortByAllButton.selected = YES;
        self.sortByPriceButton.selected = NO;
        self.sortBySaleButton.selected = NO;
        [self requestForFoodSearchWithCategoryId:self.categoryId foodTag:self.foodTag sortId:@"0" page:@"0"];
    }
}

- (IBAction)sortByPriceButtonClicked:(id)sender {
    if (!self.sortByPriceButton.selected)
    {
        self.sortByAllButton.selected = NO;
        self.sortByPriceButton.selected = YES;
        self.sortBySaleButton.selected = NO;
        [self requestForFoodSearchWithCategoryId:self.categoryId foodTag:self.foodTag sortId:@"2" page:@"0"];
    }
}

- (IBAction)sortBySaleButtonClicked:(id)sender {
    if (!self.sortBySaleButton.selected)
    {
        self.sortByAllButton.selected = NO;
        self.sortByPriceButton.selected = NO;
        self.sortBySaleButton.selected = YES;
        [self requestForFoodSearchWithCategoryId:self.categoryId foodTag:self.foodTag sortId:@"1" page:@"0"];
    }
}

#pragma mark - UIViewController Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviSearchTitle];
    self.sortByAllButton.selected = YES;
    [self requestForFoodSearchWithCategoryId:self.categoryId foodTag:self.foodTag sortId:@"0" page:@"0"];
}

#pragma mark - UISearchBar Delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    SearchHistoryViewController *searchHistoryViewController = [[SearchHistoryViewController alloc] initWithNibName:@"SearchHistoryViewController" bundle:nil];
    [self presentViewController:searchHistoryViewController animated:NO completion:nil];
    return NO;
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.foodArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"FoodTableViewCell";
    FoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (nil == cell)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"FoodTableViewCell" owner:self options:nil];
        cell = [nibs lastObject];
    }
    self.food = [self.foodArray objectAtIndex:indexPath.row];
    cell.iconImageView.cacheDir = kFoodIconCacheDir;
    [cell.iconImageView aysnLoadImageWithUrl:self.food.imgUrl placeHolder:@"loading_square.png"];
    cell.foodTitleLabel.text = self.food.name;
    cell.saleNumLabel.text = [NSString stringWithFormat:@"%@人付款",self.food.saleNumber];
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.food.price floatValue]];
    if ([self.food.isDiscount isEqualToString:@"1"]) {
        cell.priceLabel.textColor = kLightTextColor;
        cell.discountPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.food.discountPrice floatValue]];
        cell.discountPriceLabel.hidden = NO;
        cell.discountImage.hidden = NO;
        cell.discountTagImage.hidden = NO;
    }
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - YFDownloaderDelegate Methods
- (void)downloader:(YFDownloader *)downloader completeWithNSData:(NSData *)data
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [str JSONValue];
    if ([downloader.purpose isEqualToString:kFoodSearchDownloaderKey])
    {
        if([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode])
        {
            [[YFProgressHUD sharedProgressHUD] stoppedNetWorkActivity];
            self.foodArray = [NSMutableArray arrayWithCapacity:0];
            NSArray *valueArray = [dict objectForKey:@"foods"];
            for (NSDictionary *valueDict in valueArray) {
                FoodSelect *fs = [[FoodSelect alloc]initWithDict:valueDict];
                [self.foodArray addObject:fs];
            }
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
                message = @"加载失败";
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
