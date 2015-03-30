//
//  CourierOrdersViewController.m
//  SJFood
//
//  Created by 叶帆 on 15/3/27.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "CourierOrdersViewController.h"
#import "CourierTableViewCell.h"
#import "CourierOrder.h"

#define kCourierOrderDownloaderKey      @"CourierOrderDownloaderKey"

@interface CourierOrdersViewController ()
@property (nonatomic, strong) NSMutableArray *courierOrdersArray;
@property (nonatomic, strong) CourierOrder *courierOrder;
@end

@implementation CourierOrdersViewController
@synthesize courierOrdersTableView,courierOrdersArray,noOrderView,courierOrder;

#pragma mark - Private Methods
- (void)loadSubViews
{
    //初始化界面为没有订单
    self.courierOrdersTableView.scrollEnabled = NO;
    self.courierOrdersArray = [NSMutableArray arrayWithCapacity:0];
    self.courierOrdersTableView.tableFooterView = self.noOrderView;
    [self.courierOrdersTableView reloadData];
}

- (void)requestForCourierOrder
{
    [[YFProgressHUD sharedProgressHUD] showActivityViewWithMessage:@"加载中"];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kGetCourierOrderUrl];
    NSMutableDictionary *dict = kCommonParamsDict;
    [dict setObject:[MemberDataManager sharedManager].loginMember.phone forKey:@"phoneId"];
    [[YFDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:dict
                                                            contentType:@"application/x-www-form-urlencoded"
                                                               delegate:self
                                                                purpose:kCourierOrderDownloaderKey];
}

#pragma mark - IBAction Methods
- (void)changeToDeliveryButtonClicked:(UIButton *)button
{
    
}

- (void)changeToReceiveButtonClicked:(UIButton *)button
{
    
}

#pragma mark - Notification Methods
- (void)refreshNotification:(NSNotification *)notification
{
    [self requestForCourierOrder];
}

- (void)refreshCourierOrder
{
    [self requestForCourierOrder];
}

#pragma mark - BaseViewController Methods
- (void)extraItemTapped
{
    [self.courierOrdersTableView setContentOffset:CGPointMake(0, -self.courierOrdersTableView.contentInset.top) animated:YES];
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
    [self setNaviTitle:@"派单"];
    self.courierOrdersArray = [NSMutableArray arrayWithCapacity:0];
    self.courierOrdersTableView.tableFooterView = [UIView new];
    [self requestForCourierOrder];
    [self.courierOrdersTableView addHeaderWithTarget:self action:@selector(refreshCourierOrder) dateKey:@"CourierOrderScrollView"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNotification:) name:kChangeOrderStatusNotification object:nil];
}

- (void)dealloc
{
    [[YFDownloaderManager sharedManager] cancelDownloaderWithDelegate:self purpose:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.courierOrdersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"CourierTableViewCell";
    CourierTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (nil == cell)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"CourierTableViewCell" owner:self options:nil];
        cell = [nibs lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.courierOrder = [self.courierOrdersArray objectAtIndex:indexPath.row];
    cell.orderIdLabel.text = self.courierOrder.togetherId;
    cell.dateLabel.text = self.courierOrder.togetherDate;
    cell.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.courierOrder.totalPrice floatValue]];
    cell.phoneLabel.text = self.courierOrder.customePhone;
    cell.nameLabel.text = self.courierOrder.nickName;
    cell.addressLabel.text = self.courierOrder.address;
    switch ([self.courierOrder.status integerValue]) {
        case 1:
        {
            cell.statusLabel.text = @"尚未发货";
            [cell.changeStatusButton setTitle:@"派送" forState:UIControlStateNormal];
            [cell.changeStatusButton addTarget:self action:@selector(changeToDeliveryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
            
        case 2:
        {
            cell.statusLabel.text = @"正在派送";
            [cell.changeStatusButton setTitle:@"确认送达" forState:UIControlStateNormal];
            [cell.changeStatusButton addTarget:self action:@selector(changeToReceiveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
            
        default:
            break;
    }
    
    [cell reloadData:self.courierOrder.orderList];
    CGRect rect = cell.orderDetailTableView.frame;
    rect.size.height = cell.orderDetailTableView.contentSize.height;
    rect.size.width = ScreenWidth;
    cell.orderDetailTableView.frame = rect;
    CGRect cellFrame = cell.frame;
    cellFrame.size.height = cellFrame.size.height - 45.f + rect.size.height;
    cell.frame = cellFrame;
    
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:self.courierOrdersTableView cellForRowAtIndexPath:indexPath];
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
    if ([downloader.purpose isEqualToString:kCourierOrderDownloaderKey])
    {
        if([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode])
        {
            [[YFProgressHUD sharedProgressHUD] stoppedNetWorkActivity];
            [self.courierOrdersTableView headerEndRefreshing];
            self.courierOrdersArray = [NSMutableArray arrayWithCapacity:0];
            self.courierOrdersTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            NSArray *valueArray = [dict objectForKey:@"orderList"];
            for(NSDictionary *valueDict in valueArray)
            {
                CourierOrder *orders = [[CourierOrder alloc] initWithDict:valueDict];
                [self.courierOrdersArray addObject:orders];
            }
            if ([self.courierOrdersArray count] != 0) {
                self.courierOrdersTableView.tableFooterView = [UIView new];
                [self.courierOrdersTableView reloadData];
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
            [self.courierOrdersTableView headerEndRefreshing];
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
