//
//  ShoppingCarViewController.m
//  SJFood
//
//  Created by 叶帆 on 15/2/2.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "ShoppingCarViewController.h"
#import "ShoppingCarTableViewCell.h"
#import "ShoppingCar.h"

#define kGetShoppingCarDownloadKey          @"GetShoppingCarDownloadKey"
#define kSelecteButtonClickedNotification       @"SelecteButtonClickedNotification"

@interface ShoppingCarViewController ()
@property (nonatomic, strong) NSMutableArray *shoppingCarArray;
@property (nonatomic, strong) ShoppingCar *shoppingCarInfo;
@property (nonatomic, strong) NSMutableArray *shoppingCarCodeArray;
@property (nonatomic, strong) NSMutableArray *selectStatusArray;
@property (nonatomic, strong) NSString *tag;//0-未选择，1-全选，2-选择部分
@property (nonatomic, strong) NSString *totalPrice;
@end

@implementation ShoppingCarViewController
@synthesize shoppingCarTableView;
@synthesize noFoodView,calculateFoodView;
@synthesize totalPriceLabel;
@synthesize shoppingCarArray,shoppingCarInfo,shoppingCarCodeArray,selectStatusArray,tag,totalPrice,totalPriceButton;

#pragma mark - Public Methods
- (void)loadSubViews
{
    //初始化界面为购物车中没有商品
    self.shoppingCarArray = [NSMutableArray arrayWithCapacity:0];
    self.shoppingCarTableView.tableFooterView = self.noFoodView;
    self.shoppingCarTableView.scrollEnabled = NO;
    self.calculateFoodView.hidden = YES;
    [self setNaviTitle:@"购物车"];
    [self.shoppingCarTableView reloadData];
}

- (void)requestForShoppingCar
{
    [[YFProgressHUD sharedProgressHUD] showActivityViewWithMessage:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kGetOrderUrl];
    NSMutableDictionary *dict = kCommonParamsDict;
    [dict setObject:[MemberDataManager sharedManager].loginMember.phone forKey:@"phoneId"];
    [[YFDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:dict
                                                            contentType:@"application/x-www-form-urlencoded"
                                                               delegate:self
                                                                purpose:kGetShoppingCarDownloadKey];
}

#pragma mark - IBActions Methods
- (IBAction)addFoodButtonClicked:(id)sender
{
    //跳转到商品界面
    self.tabBarController.selectedIndex = 0;
}

- (void)selectButtonClicked:(UIButton *)button
{
    button.selected = !button.selected;
    //ShoppingCarTableViewCell *cell = (ShoppingCarTableViewCell *)[[[button superview]superview]superview];
    CGPoint buttonPosition = [button convertPoint:CGPointZero toView:self.shoppingCarTableView];
    NSIndexPath *indexPath = [self.shoppingCarTableView indexPathForRowAtPoint:buttonPosition];
    ShoppingCarTableViewCell *cell = (ShoppingCarTableViewCell *)[self.shoppingCarTableView cellForRowAtIndexPath:indexPath];
    ShoppingCar *sc = [self.shoppingCarArray objectAtIndex:indexPath.row];
    if (button.selected) {
        [self.shoppingCarCodeArray addObject:sc.orderId];
        self.totalPrice = [NSString stringWithFormat:@"%.2f",[self.totalPrice floatValue]+[cell.priceLabel.text floatValue]];
        [self.selectStatusArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
    } else {
        [self.shoppingCarCodeArray removeObject:sc.orderId];
        self.totalPrice = [NSString stringWithFormat:@"%.2f",[self.totalPrice floatValue]-[cell.priceLabel.text floatValue]];
        [self.selectStatusArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
    }
    if (self.shoppingCarCodeArray.count == self.shoppingCarArray.count) {
        self.tag = @"1";
    } else if (self.shoppingCarCodeArray.count == 0) {
        self.tag = @"0";
    } else {
        self.tag = @"2";
    }
    [self.shoppingCarTableView reloadData];
    [self.shoppingCarTableView layoutIfNeeded];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSelecteButtonClickedNotification object:nil];
}

- (void)editButtonClicked:(UIButton *)button
{
    
}

- (IBAction)allSelectButtonClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.tag = @"1";
        [self.shoppingCarCodeArray removeAllObjects];
        [self.selectStatusArray removeAllObjects];
        self.totalPrice = @"0.00";
        for (int i = 0; i < self.shoppingCarArray.count; i++) {
            ShoppingCar *sc = [self.shoppingCarArray objectAtIndex:i];
            [self.shoppingCarCodeArray addObject:sc.orderId];
            [self.selectStatusArray addObject:@"1"];
            if ([sc.isDiscount isEqualToString:@"1"]) {
                self.totalPrice = [NSString stringWithFormat:@"%.2f",[self.totalPrice floatValue]+[sc.discountPrice floatValue]];
            } else {
                self.totalPrice = [NSString stringWithFormat:@"%.2f",[self.totalPrice floatValue]+[sc.price floatValue]];
            }
        }
    } else {
        self.tag = @"0";
        [self.shoppingCarCodeArray removeAllObjects];
        [self.selectStatusArray removeAllObjects];
        for (int i = 0; i < self.shoppingCarArray.count; i++) {
            [self.selectStatusArray addObject:@"0"];
        }
        self.totalPrice = @"0.00";
    }
    [self.shoppingCarTableView reloadData];
    [self.shoppingCarTableView layoutIfNeeded];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSelecteButtonClickedNotification object:nil];
}


#pragma mark - Notification Methods
- (void)refreshShoppingCarWithNotification:(NSNotification *)notification
{
    [self requestForShoppingCar];
}

- (void)selectedState
{
    self.totalPriceLabel.text = [NSString stringWithFormat:@"%.2f",[self.totalPrice floatValue]];
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
    [self setRightNaviItemWithTitle:@"编辑全部" imageName:nil];
    self.shoppingCarArray = [NSMutableArray arrayWithCapacity:0];
    self.shoppingCarTableView.tableFooterView = [UIView new];
    if ([[MemberDataManager sharedManager] isLogin]) {
        self.totalPrice = @"0.00";
        self.totalPriceButton.selected = NO;
        [self requestForShoppingCar];
    } else {
        [self loadSubViews];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshShoppingCarWithNotification:) name:kRefreshShoppingCarNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedState) name:kSelecteButtonClickedNotification object:nil];
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

    self.shoppingCarInfo = [self.shoppingCarArray objectAtIndex:indexPath.row];
    if ([self.shoppingCarInfo.isDiscount isEqualToString:@"1"]) {
        //无折扣
        cell.discountLine.hidden = NO;
        cell.discountPriceLabel.hidden = NO;
        cell.discountPriceLabel.text = [NSString stringWithFormat:@"%.2f",[self.shoppingCarInfo.price floatValue]];
        cell.priceLabel.text = [NSString stringWithFormat:@"%.2f",[self.shoppingCarInfo.discountPrice floatValue]];
    } else {
        cell.priceLabel.text = [NSString stringWithFormat:@"%.2f",[self.shoppingCarInfo.price floatValue]];
    }
    cell.foodImageView.cacheDir = kUserIconCacheDir;
    [cell.foodImageView aysnLoadImageWithUrl:self.shoppingCarInfo.imageUrl placeHolder:@"loading_square.png"];
    cell.foodNameLabel.text = self.shoppingCarInfo.name;
    cell.foodSpecalLabel.text = self.shoppingCarInfo.specialName;
    cell.orderId = self.shoppingCarInfo.orderId;
    cell.numberLabel.text = [NSString stringWithFormat:@"x%@",self.shoppingCarInfo.orderCount];
    if ([self.tag isEqualToString:@"1"]) {
        cell.selectButton.selected = YES;
        self.totalPriceButton.selected = YES;
    } else if ([self.tag isEqualToString:@"0"]) {
        cell.selectButton.selected = NO;
        self.totalPriceButton.selected = NO;
    } else if ([self.tag isEqualToString:@"2"]) {
        self.totalPriceButton.selected = NO;
        if ([[self.selectStatusArray objectAtIndex:indexPath.row] isEqualToString:@"1"]) {
            cell.selectButton.selected = YES;
        } else {
            cell.selectButton.selected = NO;
        }
    }
    [cell.selectButton addTarget:self action:@selector(selectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.editButton addTarget:self action:@selector(editButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - YFDownloaderDelegate Methods
- (void)downloader:(YFDownloader *)downloader completeWithNSData:(NSData *)data
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [str JSONValue];
    if ([downloader.purpose isEqualToString:kGetShoppingCarDownloadKey])
    {
        if([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode])
        {

            [[YFProgressHUD sharedProgressHUD] stoppedNetWorkActivity];
            self.tag = @"0";
            self.totalPrice = @"0.00";
            self.totalPriceLabel.text = @"0.00";
            self.shoppingCarArray = [NSMutableArray arrayWithCapacity:0];
            self.shoppingCarCodeArray = [NSMutableArray arrayWithCapacity:0];
            self.selectStatusArray = [NSMutableArray arrayWithCapacity:0];
            NSArray *valueArray = [dict objectForKey:@"orderList"];
            for(NSDictionary *valueDict in valueArray)
            {
                ShoppingCar *shoppingCar = [[ShoppingCar alloc] initWithDict:valueDict];
                [self.shoppingCarArray addObject:shoppingCar];
                [self.selectStatusArray addObject:@"0"];
            }
            if ([self.shoppingCarArray count] != 0) {
                self.shoppingCarTableView.tableFooterView = [UIView new];
                self.calculateFoodView.hidden = NO;
                self.shoppingCarTableView.scrollEnabled = YES;
                [self setNaviTitle:[NSString stringWithFormat:@"购物车(%lu)",(unsigned long)self.shoppingCarArray.count]];
                [self.shoppingCarTableView reloadData];
            } else {
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
                message = @"购物车信息获取失败";
            [self loadSubViews];
            [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:message hideDelay:2.f];
        }
    }
}

- (void)downloader:(YFDownloader *)downloader didFinishWithError:(NSString *)message
{
    [self loadSubViews];
    [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:kNetWorkErrorString hideDelay:2.f];
}

@end
