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
#import "FoodDetailViewController.h"

#define kFoodSearchDownloaderKey        @"FoodSearchDownloaderKey"
#define kLastIdInit             @"0"

@interface FoodViewController ()
@property (nonatomic, strong)UISearchBar *searchBar;
@property (nonatomic, strong)NSString *foodTag;
@property (nonatomic, strong)NSMutableArray *foodArray;
@property (nonatomic, strong)FoodSelect *food;
@property (nonatomic, strong)NSString *lastestId;
@property (nonatomic, strong)NSString *sort;
@end

@implementation FoodViewController
@synthesize sortByAllButton,sortByPriceButton,sortBySaleButton,foodTableView;
@synthesize searchBar,categoryId,foodTag,foodArray,food,lastestId,sort,messageFooterView,loadMessageLabel;

#pragma mark - Private Methods
- (void)loadSubViews
{
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
    self.lastestId = page;
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kFoodSearchUrl];
    NSMutableDictionary *dict = kCommonParamsDict;
    [dict setObject:category forKey:@"categoryId"];
    [dict setObject:tag forKey:@"foodTag"];
    [dict setObject:sortId forKey:@"sortId"];
    [dict setObject:page forKey:@"page"];
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
        [self.foodTableView removeFooter];
        self.foodTableView.tableFooterView = [UIView new];
        [self.foodTableView addFooterWithTarget:self action:@selector(refreshFooter)];
        self.foodArray = [NSMutableArray arrayWithCapacity:0];
        self.sort = @"0";
        self.sortByAllButton.selected = YES;
        self.sortByPriceButton.selected = NO;
        self.sortBySaleButton.selected = NO;
        [[YFProgressHUD sharedProgressHUD] showActivityViewWithMessage:@"加载中..."];
        [self requestForFoodSearchWithCategoryId:self.categoryId foodTag:self.foodTag sortId:self.sort page:kLastIdInit];
    }
}

- (IBAction)sortByPriceButtonClicked:(id)sender {
    if (!self.sortByPriceButton.selected)
    {
        [self.foodTableView removeFooter];
        self.foodTableView.tableFooterView = [UIView new];
        [self.foodTableView addFooterWithTarget:self action:@selector(refreshFooter)];
        self.foodArray = [NSMutableArray arrayWithCapacity:0];
        self.sort = @"2";
        self.sortByAllButton.selected = NO;
        self.sortByPriceButton.selected = YES;
        self.sortBySaleButton.selected = NO;
        [[YFProgressHUD sharedProgressHUD] showActivityViewWithMessage:@"加载中..."];
        [self requestForFoodSearchWithCategoryId:self.categoryId foodTag:self.foodTag sortId:self.sort page:kLastIdInit];
    }
}

- (IBAction)sortBySaleButtonClicked:(id)sender {
    if (!self.sortBySaleButton.selected)
    {
        [self.foodTableView removeFooter];
        self.foodTableView.tableFooterView = [UIView new];
        [self.foodTableView addFooterWithTarget:self action:@selector(refreshFooter)];
        self.foodArray = [NSMutableArray arrayWithCapacity:0];
        self.sort = @"1";
        self.sortByAllButton.selected = NO;
        self.sortByPriceButton.selected = NO;
        self.sortBySaleButton.selected = YES;
        [[YFProgressHUD sharedProgressHUD] showActivityViewWithMessage:@"加载中..."];
        [self requestForFoodSearchWithCategoryId:self.categoryId foodTag:self.foodTag sortId:self.sort page:kLastIdInit];
    }
}

- (void)refreshFooter
{
    NSString *more = kLastIdInit;
    if (self.foodArray.count != 0) {
        more = self.lastestId;
    }
    [self requestForFoodSearchWithCategoryId:self.categoryId foodTag:self.foodTag sortId:self.sort page:more];
}

#pragma mark - NSNotification Methods
- (void)foodSearchWithNotification:(NSNotification *)notification
{
    self.categoryId = nil;
    self.foodTag = notification.object;
    [self.foodTableView removeFooter];
    self.foodTableView.tableFooterView = [UIView new];
    [self.foodTableView addFooterWithTarget:self action:@selector(refreshFooter)];
    self.foodArray = [NSMutableArray arrayWithCapacity:0];
    self.sort = @"0";
    self.sortByAllButton.selected = YES;
    self.sortByPriceButton.selected = NO;
    self.sortBySaleButton.selected = NO;
    [[YFProgressHUD sharedProgressHUD] showActivityViewWithMessage:@"加载中..."];
    [self requestForFoodSearchWithCategoryId:self.categoryId foodTag:self.foodTag sortId:self.sort page:kLastIdInit];
}

#pragma mark - BaseViewController Methods
- (void)extraItemTapped
{
    [self.foodTableView setContentOffset:CGPointMake(0, -self.foodTableView.contentInset.top) animated:YES];
}

#pragma mark - UIViewController Methods
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [[YFProgressHUD sharedProgressHUD] stoppedNetWorkActivity];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[self transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: kMainBlackColor};
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];//导航条的颜色
        self.navigationController.navigationBar.tintColor = kMainProjColor;//左侧返回按钮，文字的颜色
    } completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviSearchTitle];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.lastestId = kLastIdInit;
    self.foodArray = [NSMutableArray arrayWithCapacity:0];
    self.foodTableView.tableFooterView = [UIView new];
    [self.foodTableView addFooterWithTarget:self action:@selector(refreshFooter)];
    self.sortByAllButton.selected = YES;
    self.sort = @"0";
    [[YFProgressHUD sharedProgressHUD] showActivityViewWithMessage:@"加载中..."];
    if (self.categoryId != nil)
        [self requestForFoodSearchWithCategoryId:self.categoryId foodTag:self.foodTag sortId:self.sort page:kLastIdInit];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foodSearchWithNotification:) name:kFoodSearchNotification object:nil];
}

- (void)dealloc
{
    [[YFDownloaderManager sharedManager] cancelDownloaderWithDelegate:self purpose:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    FoodDetailViewController *foodDetailViewController = [[FoodDetailViewController alloc] initWithNibName:@"FoodDetailViewController" bundle:nil];
    FoodSelect *foods = [self.foodArray objectAtIndex:indexPath.row];
    foodDetailViewController.foodId = foods.foodId;
    [self.navigationController pushViewController:foodDetailViewController animated:YES];
}

#pragma mark - YFDownloaderDelegate Methods
- (void)downloader:(YFDownloader *)downloader completeWithNSData:(NSData *)data
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [str JSONValue];
    if ([downloader.purpose isEqualToString:kFoodSearchDownloaderKey])
    {
        [self.foodTableView footerEndRefreshing];
        [[YFProgressHUD sharedProgressHUD] stoppedNetWorkActivity];
        if([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode])
        {
            NSMutableArray *valueArray = [dict objectForKey:@"foods"];
            
            if ([self.lastestId isEqualToString:kLastIdInit])
            {
                //第一次加载
                [self.foodTableView setContentOffset:CGPointMake(0, -self.foodTableView.contentInset.top) animated:NO];
                if (valueArray.count == 0)
                {
                    [self.foodTableView removeFooter];
                    self.loadMessageLabel.text = @"暂无食品信息";
                    self.foodTableView.tableFooterView = self.messageFooterView;
                }
                else
                {
                    for (NSDictionary *valueDict in valueArray) {
                        FoodSelect *fs = [[FoodSelect alloc]initWithDict:valueDict];
                        [self.foodArray addObject:fs];
                    }
                    self.lastestId = @"1";
                }
            }
            else
            {
                //下拉获取更多
                if (valueArray.count == 0)
                {
                    [self.foodTableView removeFooter];
                    self.loadMessageLabel.text = @"已加载全部食品";
                    self.foodTableView.tableFooterView = self.messageFooterView;
                }
                else
                {
                    for (NSDictionary *valueDict in valueArray) {
                        FoodSelect *fs = [[FoodSelect alloc]initWithDict:valueDict];
                        [self.foodArray addObject:fs];
                    }
                    NSString *previousId = [NSString stringWithFormat:@"%ld",[self.lastestId integerValue] + 1];
                    self.lastestId = previousId;
                }
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
