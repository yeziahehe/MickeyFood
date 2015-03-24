//
//  AllOrderViewController.m
//  SJFood
//
//  Created by 叶帆 on 14/12/6.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "AllOrderViewController.h"
#import "OrderTableViewCell.h"
#import "Order.h"
#import "OrderDetails.h"

#define kGetAllOrderDownloadKey     @"GetAllOrderDownloadKey"

@interface AllOrderViewController ()
@property (nonatomic, strong) NSMutableArray *orderArray;
@property (nonatomic, strong) Order *order;
@end

@implementation AllOrderViewController
@synthesize allOrderTableView,noOrderView;
@synthesize order,orderArray;

#pragma mark - Private Methods
- (void)loadSubViews
{
    //初始化界面为没有地址
    self.orderArray = [NSMutableArray arrayWithCapacity:0];
    self.allOrderTableView.tableFooterView = self.noOrderView;
    [self.allOrderTableView reloadData];
}

- (void)requestForAllOrder
{
    [[YFProgressHUD sharedProgressHUD] showActivityViewWithMessage:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kGetOrderByStatusUrl];
    NSMutableDictionary *dict = kCommonParamsDict;
    [dict setObject:[MemberDataManager sharedManager].loginMember.phone forKey:@"phoneId"];
    [[YFDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:dict
                                                            contentType:@"application/x-www-form-urlencoded"
                                                               delegate:self
                                                                purpose:kGetAllOrderDownloadKey];
}

#pragma mark - IBAction Methods
- (void)deliveryButtonClicked:(UIButton *)button
{
    [[YFProgressHUD sharedProgressHUD]showWithMessage:@"提醒发货成功" customView:nil hideDelay:2.f];
}

- (void)receiveButtonClicked:(UIButton *)button
{
    [[YFProgressHUD sharedProgressHUD]showWithMessage:@"成功催了小哥" customView:nil hideDelay:2.f];
}

- (void)commentButtonClicked:(UIButton *)button
{
    
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
    [self setNaviTitle:@"全部订单"];
    self.orderArray = [NSMutableArray arrayWithCapacity:0];
    self.allOrderTableView.tableFooterView = [UIView new];
    [self requestForAllOrder];
    
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
    switch ([self.order.status integerValue]) {
        case 1:
        {
            cell.orderStatusLabel.text = @"尚未发货";
            [cell.orderStatusChangeButton setTitle:@"提醒发货" forState:UIControlStateNormal];
            [cell.orderStatusChangeButton addTarget:self action:@selector(deliveryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
            
        case 2:
        {
            cell.orderStatusLabel.text = @"正在派送";
            [cell.orderStatusChangeButton setTitle:@"催催小哥" forState:UIControlStateNormal];
            [cell.orderStatusChangeButton addTarget:self action:@selector(receiveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
            
        case 3:
        {
            cell.orderStatusLabel.text = @"交易完成";
            OrderDetails *od = [self.order.smallOrders firstObject];
            if ([od.isRemarked isEqualToString:@"0"]) {
                [cell.orderStatusChangeButton setTitle:@"评价订单" forState:UIControlStateNormal];
                [cell.orderStatusChangeButton addTarget:self action:@selector(commentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                [cell.orderStatusChangeButton setTitle:@"已评价" forState:UIControlStateNormal];
                cell.orderTotalPriceLabel.userInteractionEnabled = NO;
            }
        }
            
        default:
            break;
    }
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
    UITableViewCell *cell = [self tableView:self.allOrderTableView cellForRowAtIndexPath:indexPath];
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
            self.allOrderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            NSArray *valueArray = [dict objectForKey:@"orderList"];
            for(NSDictionary *valueDict in valueArray)
            {
                Order *orders = [[Order alloc] initWithDict:valueDict];
                [self.orderArray addObject:orders];
            }
            if ([self.orderArray count] != 0) {
                self.allOrderTableView.tableFooterView = [UIView new];
                [self.allOrderTableView reloadData];
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
                message = @"订单获取失败";
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
