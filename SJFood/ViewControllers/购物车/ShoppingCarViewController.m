//
//  ShoppingCarViewController.m
//  SJFood
//
//  Created by 叶帆 on 15/2/2.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "ShoppingCarViewController.h"
#import "ShoppingCarTableViewCell.h"

#define kGetShoppingCarDownloadKey      @"GetShoppingCarDownloadKey"

@interface ShoppingCarViewController ()
@property (nonatomic, strong) NSMutableArray *shoppingCarArray;
@end

@implementation ShoppingCarViewController
@synthesize shoppingCarTableView;
@synthesize noFoodView;
@synthesize shoppingCarArray;

#pragma mark - Private Methods
- (void)loadSubViews
{
    //初始化界面为购物车中没有商品
    self.shoppingCarArray = [NSMutableArray arrayWithCapacity:0];
    self.shoppingCarTableView.tableFooterView = self.noFoodView;
    [self.shoppingCarTableView reloadData];
}

- (void)requestForShoppingCar
{
    //网络请求
    [self loadSubViews];
}

#pragma mark - IBActions Methods
- (IBAction)addFoodButtonClicked:(id)sender
{
    //跳转到商品界面
    self.tabBarController.selectedIndex = 0;
}

#pragma mark - Notification Methods
- (void)refreshShoppingCarWithNotification:(NSNotification *)notification
{
    [self requestForShoppingCar];
}

#pragma mark - UIViewController Methods
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [[YFProgressHUD sharedProgressHUD] stoppedNetWorkActivity];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"购物车"];
    self.shoppingCarArray = [NSMutableArray arrayWithCapacity:0];
    self.shoppingCarTableView.tableFooterView = [UIView new];
    [self requestForShoppingCar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshShoppingCarWithNotification:) name:kRefreshShoppingCarNotification object:nil];
}

- (void)dealloc
{
    [[YFDownloaderManager sharedManager] cancelDownloaderWithDelegate:self purpose:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.shoppingCarArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"ShoppingCarTableViewCell";
    ShoppingCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (nil == cell)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"ShoppingCarTableViewCell" owner:self options:nil];
        cell = [nibs lastObject];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 128.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - YFDownloaderDelegate Methods
- (void)downloader:(YFDownloader *)downloader completeWithNSData:(NSData *)data
{
    
}

- (void)downloader:(YFDownloader *)downloader didFinishWithError:(NSString *)message
{
    [self loadSubViews];
    [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:kNetWorkErrorString hideDelay:2.f];
}

@end
