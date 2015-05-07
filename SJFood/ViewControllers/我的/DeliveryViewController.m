//
//  DeliveryViewController.m
//  SJFood
//
//  Created by 叶帆 on 14/12/6.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "DeliveryViewController.h"
#import "Order.h"
#import "OrderTableViewCell.h"
#import "OrderDetails.h"

#define kGetAllOrderDownloadKey     @"GetAllOrderDownloadKey"

@interface DeliveryViewController ()
@property (nonatomic, strong) NSMutableArray *orderArray;
@property (nonatomic, strong) Order *order;
@end

@implementation DeliveryViewController
@synthesize deliveryTableView,noOrderView;
@synthesize order,orderArray;

#pragma mark - Private Methods
- (void)loadSubViews
{
    //初始化界面为没有地址
    self.deliveryTableView.scrollEnabled = NO;
    self.orderArray = [NSMutableArray arrayWithCapacity:0];
    self.deliveryTableView.tableFooterView = self.noOrderView;
    [self.deliveryTableView reloadData];
}

- (void)requestForDeliveryOrder
{
    [[YFProgressHUD sharedProgressHUD] showActivityViewWithMessage:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kGetOrderByStatusUrl];
    NSMutableDictionary *dict = kCommonParamsDict;
    [dict setObject:[MemberDataManager sharedManager].loginMember.phone forKey:@"phoneId"];
    [dict setObject:@"1" forKey:@"status"];
    [[YFDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:dict
                                                            contentType:@"application/x-www-form-urlencoded"
                                                               delegate:self
                                                                purpose:kGetAllOrderDownloadKey];
}

#pragma mark - IBAction Methods
- (void)deliveryButtonClicked:(UIButton *)button
{
    //[[YFProgressHUD sharedProgressHUD]showWithMessage:@"提醒发货成功" customView:nil hideDelay:2.f];
    //待发货情况下，用户可以手动取消订单
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
    [self setNaviTitle:@"待发货订单"];
    self.orderArray = [NSMutableArray arrayWithCapacity:0];
    self.deliveryTableView.tableFooterView = [UIView new];
    [self requestForDeliveryOrder];
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

    cell.orderStatusLabel.text = @"尚未发货";
    [cell.orderStatusChangeButton setTitle:@"取消订单" forState:UIControlStateNormal];
    [cell.orderStatusChangeButton addTarget:self action:@selector(deliveryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
 
            
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
    UITableViewCell *cell = [self tableView:self.deliveryTableView cellForRowAtIndexPath:indexPath];
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
            self.deliveryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            NSArray *valueArray = [dict objectForKey:@"orderList"];
            for(NSDictionary *valueDict in valueArray)
            {
                Order *orders = [[Order alloc] initWithDict:valueDict];
                [self.orderArray addObject:orders];
            }
            if ([self.orderArray count] != 0) {
                self.deliveryTableView.tableFooterView = [UIView new];
                [self.deliveryTableView reloadData];
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
                message = @"待发货订单获取失败";
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
