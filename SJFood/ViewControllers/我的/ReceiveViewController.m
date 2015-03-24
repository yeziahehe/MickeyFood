//
//  ReceiveViewController.m
//  SJFood
//
//  Created by 叶帆 on 14/12/6.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "ReceiveViewController.h"
#import "Order.h"
#import "OrderTableViewCell.h"
#import "OrderDetails.h"

#define kGetAllOrderDownloadKey     @"GetAllOrderDownloadKey"

@interface ReceiveViewController ()
@property (nonatomic, strong) NSMutableArray *orderArray;
@property (nonatomic, strong) Order *order;
@end

@implementation ReceiveViewController
@synthesize receiveTableView,noOrderView;
@synthesize order,orderArray;

#pragma mark - Private Methods
- (void)loadSubViews
{
    //初始化界面为没有地址
    self.orderArray = [NSMutableArray arrayWithCapacity:0];
    self.receiveTableView.tableFooterView = self.noOrderView;
    [self.receiveTableView reloadData];
}

- (void)requestForReceiveOrder
{
    [[YFProgressHUD sharedProgressHUD] showActivityViewWithMessage:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kGetOrderByStatusUrl];
    NSMutableDictionary *dict = kCommonParamsDict;
    [dict setObject:[MemberDataManager sharedManager].loginMember.phone forKey:@"phoneId"];
    [dict setObject:@"2" forKey:@"status"];
    [[YFDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:dict
                                                            contentType:@"application/x-www-form-urlencoded"
                                                               delegate:self
                                                                purpose:kGetAllOrderDownloadKey];
}

#pragma mark - IBAction Methods
- (void)receiveButtonClicked:(UIButton *)button
{
    [[YFProgressHUD sharedProgressHUD]showWithMessage:@"成功催了小哥" customView:nil hideDelay:2.f];
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
    [self setNaviTitle:@"待收货订单"];
    self.orderArray = [NSMutableArray arrayWithCapacity:0];
    self.receiveTableView.tableFooterView = [UIView new];
    [self requestForReceiveOrder];
}

- (void)dealloc
{
    [[YFDownloaderManager sharedManager] cancelDownloaderWithDelegate:self purpose:nil];
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.orderArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"OrderTableViewCell";
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (nil == cell)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"OrderTableViewCell" owner:self options:nil];
        cell = [nibs lastObject];
    }
    self.order = [self.orderArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.orderDateLabel.text = self.order.togetherDate;
    
    cell.orderStatusLabel.text = @"正在派送";
    [cell.orderStatusChangeButton setTitle:@"催催小哥" forState:UIControlStateNormal];
    [cell.orderStatusChangeButton addTarget:self action:@selector(receiveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *totalPrice = @"0.00";
    for (OrderDetails *od in self.order.smallOrders) {
        if ([od.isDiscount isEqualToString:@"0"]) {
            totalPrice = [NSString stringWithFormat:@"%.2f",[totalPrice floatValue] + [od.orderCount integerValue] * [od.price floatValue]];
        } else {
            totalPrice = [NSString stringWithFormat:@"%.2f",[totalPrice floatValue] + [od.orderCount integerValue] * [od.discountPrice floatValue]];
        }
    }
    cell.orderTotalPriceLabel.text = [NSString stringWithFormat:@"￥%@",totalPrice];
    
    [cell reloadData:self.order.smallOrders];
    CGRect rect = cell.orderDetailTableView.frame;
    rect.size.height = cell.orderDetailTableView.contentSize.height;
    rect.size.width = ScreenWidth;
    cell.orderDetailTableView.frame = rect;
    CGRect cellFrame = cell.frame;
    cellFrame.size.height = cellFrame.size.height - 80 + rect.size.height;
    cell.frame = cellFrame;
    
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:self.receiveTableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
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
    if ([downloader.purpose isEqualToString:kGetAllOrderDownloadKey])
    {
        if([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode])
        {
            [[YFProgressHUD sharedProgressHUD] stoppedNetWorkActivity];
            self.orderArray = [NSMutableArray arrayWithCapacity:0];
            self.receiveTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            NSArray *valueArray = [dict objectForKey:@"orderList"];
            for(NSDictionary *valueDict in valueArray)
            {
                Order *orders = [[Order alloc] initWithDict:valueDict];
                [self.orderArray addObject:orders];
            }
            if ([self.orderArray count] != 0) {
                self.receiveTableView.tableFooterView = [UIView new];
                [self.receiveTableView reloadData];
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
                message = @"待收货订单获取失败";
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
