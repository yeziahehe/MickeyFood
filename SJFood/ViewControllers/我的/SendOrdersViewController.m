//
//  SendOrdersViewController.m
//  SJFood
//
//  Created by 叶帆 on 15/3/27.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "SendOrdersViewController.h"
#import "SendOrder.h"
#import "SendOrderTableViewCell.h"
#import "SelectCourierViewController.h"

#define kSendOrderDownloaderKey         @"SendOrderDownloaderKey"

@interface SendOrdersViewController ()
@property (nonatomic, strong) NSMutableArray *sendOrderArray;
@property (nonatomic, strong) NSString *isSelected;
@property (nonatomic, strong) SendOrder *sendOrder;
@end

@implementation SendOrdersViewController
@synthesize sendOrderTableView,notSelectButton,selectedButton,noOrderView;
@synthesize sendOrderArray,isSelected,sendOrder;


#pragma mark - Private Methods
- (void)loadSubViews
{
    self.sendOrderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.sendOrderTableView reloadData];
}

- (void)requestForSendOrder
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kSendOrderUrl];
    NSMutableDictionary *dict = kCommonParamsDict;
    [dict setObject:self.isSelected forKey:@"isSelected"];
    [[YFDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:dict
                                                            contentType:@"application/x-www-form-urlencoded"
                                                               delegate:self
                                                                purpose:kSendOrderDownloaderKey];
}

#pragma mark - IBAction Methods
- (IBAction)notSelectButtonClicked:(id)sender {
    if (!self.notSelectButton.selected) {
        self.notSelectButton.selected = YES;
        self.selectedButton.selected = NO;
        self.isSelected = @"0";
        [[YFProgressHUD sharedProgressHUD] showActivityViewWithMessage:@"加载中..."];
        [self requestForSendOrder];
    }
}

- (IBAction)selectButtonClicked:(id)sender {
    if (!self.selectedButton.selected) {
        self.notSelectButton.selected = NO;
        self.selectedButton.selected = YES;
        self.isSelected = @"1";
        [[YFProgressHUD sharedProgressHUD] showActivityViewWithMessage:@"加载中..."];
        [self requestForSendOrder];
    }
}

- (void)sendOrderButtonClicked:(UIButton *)button
{
    SelectCourierViewController *selectCourierViewController = [[SelectCourierViewController alloc]initWithNibName:@"SelectCourierViewController" bundle:nil];
    CGPoint buttonPosition = [button convertPoint:CGPointZero toView:self.sendOrderTableView];
    NSIndexPath *indexPath = [self.sendOrderTableView indexPathForRowAtPoint:buttonPosition];
    SendOrder *sd = [self.sendOrderArray objectAtIndex:indexPath.row];
    if ([self.isSelected isEqualToString:@"1"]) {
        selectCourierViewController.courierName = sd.adminName;
    }
    selectCourierViewController.togetherId = sd.togetherId;
    [self.navigationController pushViewController:selectCourierViewController animated:YES];
}

- (void)refreshSendOrder
{
    [self requestForSendOrder];
}

#pragma mark - Notification Methods
- (void)selectCourierNotification:(NSNotification *)notification
{
    [[YFProgressHUD sharedProgressHUD] showSuccessViewWithMessage:@"选择快递员成功，请去已派单中查看" hideDelay:2.f];
    [self requestForSendOrder];
}

#pragma mark - BaseViewController Methods
- (void)extraItemTapped
{
    [self.sendOrderTableView setContentOffset:CGPointMake(0, -self.sendOrderTableView.contentInset.top) animated:YES];
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
    [self setNaviTitle:@"选单"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.notSelectButton.selected = YES;
    self.isSelected = @"0";
    [self requestForSendOrder];
    [self.sendOrderTableView addHeaderWithTarget:self action:@selector(refreshSendOrder) dateKey:@"SendOrderScrollView"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectCourierNotification:) name:kSelectCourierNotification object:nil];
}

- (void)dealloc
{
    [[YFDownloaderManager sharedManager] cancelDownloaderWithDelegate:self purpose:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sendOrderArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"SendOrderTableViewCell";
    SendOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (nil == cell)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"SendOrderTableViewCell" owner:self options:nil];
        cell = [nibs lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.sendOrder = [self.sendOrderArray objectAtIndex:indexPath.row];
    cell.togetherIdLabel.text = self.sendOrder.togetherId;
    cell.orderDateLabel.text = self.sendOrder.togetherDate;
    cell.addressLabel.text = self.sendOrder.address;
    if ([self.sendOrder.isDiscount isEqualToString:@"1"]) {
        cell.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.sendOrder.discountPrice floatValue]];
    } else {
        cell.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.sendOrder.price floatValue]];
    }
    if ([self.isSelected isEqualToString:@"1"]) {
        [cell.sendOrderButton setTitle:@"更换小哥" forState:UIControlStateNormal];
        cell.CourierNameLabel.text = self.sendOrder.adminName;
    } else if ([self.isSelected isEqualToString:@"0"]) {
        [cell.sendOrderButton setTitle:@"选择小哥" forState:UIControlStateNormal];
        cell.CourierNameLabel.text = @"未选择";
    }
    [cell.sendOrderButton addTarget:self action:@selector(sendOrderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105.f;
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
    if ([downloader.purpose isEqualToString:kSendOrderDownloaderKey])
    {
        [[YFProgressHUD sharedProgressHUD] stoppedNetWorkActivity];
        if([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode])
        {
            [self.sendOrderTableView headerEndRefreshing];
            [self.sendOrderTableView setContentOffset:CGPointMake(0, -self.sendOrderTableView.contentInset.top) animated:NO];
            self.sendOrderArray = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *valueArray = [dict objectForKey:@"orderList"];
            if (valueArray.count == 0) {
                self.sendOrderTableView.tableFooterView = self.noOrderView;
            }
            else {
                for (NSDictionary *valueDict in valueArray) {
                    SendOrder *so = [[SendOrder alloc]initWithDict:valueDict];
                    [self.sendOrderArray addObject:so];
                }
                self.sendOrderTableView.tableFooterView = [UIView new];
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
             [self.sendOrderTableView headerEndRefreshing];
            [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:message hideDelay:2.f];
        }
    }
}

- (void)downloader:(YFDownloader *)downloader didFinishWithError:(NSString *)message
{
    [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:kNetWorkErrorString hideDelay:2.f];
}


@end
