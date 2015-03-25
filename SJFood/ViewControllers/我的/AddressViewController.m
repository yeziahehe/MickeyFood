//
//  AddressViewController.m
//  SJFood
//
//  Created by 叶帆 on 14/12/6.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressTableViewCell.h"
#import "AddressAddViewController.h"
#import "AddressEditViewController.h"
#import "Address.h"

#define kGetAddressDownloaderKey            @"GetAddressDownloaderKey"
#define kSetDefaultAddressDownloaderKey     @"SetDefaultAddressDownloaderKey"

@interface AddressViewController ()
@property (nonatomic, strong) NSMutableArray *addressArray;
@property (nonatomic, strong) Address *addressInfo;
@property (nonatomic, strong) NSString *refreshKey;
@end

@implementation AddressViewController
@synthesize addressTableView,noAddressView;
@synthesize addressArray,addressInfo,refreshKey;

#pragma mark - Private Methods
- (void)loadSubViews
{
    //初始化界面为没有地址
    self.addressTableView.scrollEnabled = NO;
    self.addressArray = [NSMutableArray arrayWithCapacity:0];
    self.addressTableView.tableFooterView = self.noAddressView;
    [self.addressTableView reloadData];
}

- (void)requestForAddressInfo
{
    [[YFProgressHUD sharedProgressHUD] showActivityViewWithMessage:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kGetAddressInfoUrl];
    NSMutableDictionary *dict = kCommonParamsDict;
    [dict setObject:[MemberDataManager sharedManager].loginMember.phone forKey:@"phoneId"];
    [[YFDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:dict
                                                            contentType:@"application/x-www-form-urlencoded"
                                                               delegate:self
                                                                purpose:kGetAddressDownloaderKey];
}

#pragma mark - IBActions Methods
- (IBAction)addAddressButtonClicked:(id)sender
{
    AddressAddViewController *addressAddViewController = [[AddressAddViewController alloc]initWithNibName:@"AddressAddViewController" bundle:nil];
    [self.navigationController pushViewController:addressAddViewController animated:YES];
}

- (void)defaultAddressButtonClicked:(UIButton *)button
{
    //更改默认地址
    //需要将下面的view设置为userEnable
    [[YFProgressHUD sharedProgressHUD] startedNetWorkActivityWithText:@"正在更改默认地址"];
    Address *defaultAddress = [self.addressArray objectAtIndex:button.tag];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kSetDefaultAddressUrl];
    NSMutableDictionary *dict = kCommonParamsDict;
    [dict setObject:[MemberDataManager sharedManager].loginMember.phone forKey:@"phoneId"];
    [dict setObject:defaultAddress.rank forKey:@"rank"];
    [[YFDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:dict
                                                            contentType:@"application/x-www-form-urlencoded"
                                                               delegate:self
                                                                purpose:kSetDefaultAddressDownloaderKey];
}

- (void)editAddressButtonClicked:(UIButton *)button
{
    AddressEditViewController *addressEditViewController = [[AddressEditViewController alloc]initWithNibName:@"AddressEditViewController" bundle:nil];
    addressEditViewController.editAddress = [self.addressArray objectAtIndex:button.tag];
    [self.navigationController pushViewController:addressEditViewController animated:YES];
}

#pragma mark - Notification Methods
- (void)refreshAddressInfoWithNotification:(NSNotification *)notification
{
    [self requestForAddressInfo];
}

#pragma mark - BaseViewController Methods
- (void)rightItemTapped
{
    AddressAddViewController *addressAddViewController = [[AddressAddViewController alloc]initWithNibName:@"AddressAddViewController" bundle:nil];
    [self.navigationController pushViewController:addressAddViewController animated:YES];
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
    [self setNaviTitle:@"地址管理"];
    [self setRightNaviItemWithTitle:nil imageName:@"btn_add_address"];
    self.addressArray = [NSMutableArray arrayWithCapacity:0];
    self.addressTableView.tableFooterView = [UIView new];
    [self requestForAddressInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAddressInfoWithNotification:) name:kRefreshAddressNotification object:nil];
}

- (void)dealloc
{
    [[YFDownloaderManager sharedManager] cancelDownloaderWithDelegate:self purpose:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.addressArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"AddressTableViewCell";
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (nil == cell)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"AddressTableViewCell" owner:self options:nil];
        cell = [nibs lastObject];
    }
    self.addressInfo = [self.addressArray objectAtIndex:indexPath.row];
    if ([self.addressInfo.tag isEqualToString:@"0"]) {
        cell.addressLabel.text = [NSString stringWithFormat:@"%@%@",@"[默认]",self.addressInfo.address];
        cell.defaultAddressButton.selected = YES;
        cell.defaultAddressLabel.text = @"默认地址";
    } else {
        cell.addressLabel.text = self.addressInfo.address;
        cell.defaultAddressButton.selected = NO;
        cell.defaultAddressLabel.text = @"设置为默认地址";
        cell.defaultAddressButton.tag = indexPath.row;
        [cell.defaultAddressButton addTarget:self action:@selector(defaultAddressButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.rank = self.addressInfo.rank;
    cell.nameLabel.text = self.addressInfo.name;
    cell.phoneLabel.text = self.addressInfo.phone;
    cell.editAddressButton.tag = indexPath.row;
    [cell.editAddressButton addTarget:self action:@selector(editAddressButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
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
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [str JSONValue];
    if ([downloader.purpose isEqualToString:kGetAddressDownloaderKey])
    {
        if([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode])
        {
            if ([self.refreshKey isEqualToString:@"0"]) {
                [[YFProgressHUD sharedProgressHUD] showSuccessViewWithMessage:@"更改默认地址成功" hideDelay:2.f];
            } else {
                [[YFProgressHUD sharedProgressHUD] stoppedNetWorkActivity];
            }
            self.addressArray = [NSMutableArray arrayWithCapacity:0];
            NSArray *valueArray = [dict objectForKey:@"receivers"];
            for(NSDictionary *valueDict in valueArray)
            {
                Address *address = [[Address alloc] initWithDict:valueDict];
                [self.addressArray addObject:address];
            }
            if ([self.addressArray count] != 0) {
                self.addressTableView.scrollEnabled = YES;
                self.addressTableView.tableFooterView = [UIView new];
                [self.addressTableView reloadData];
            } else {
                [self loadSubViews];
            }
            self.refreshKey = @"1";
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if ([message isKindOfClass:[NSNull class]])
            {
                message = @"";
            }
            if(message.length == 0)
                message = @"收货地址获取失败";
            [self loadSubViews];
            [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:message hideDelay:2.f];
        }
    }
    else if ([downloader.purpose isEqualToString:kSetDefaultAddressDownloaderKey])
    {
        if([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode])
        {
            self.refreshKey = @"0";
            [self requestForAddressInfo];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if ([message isKindOfClass:[NSNull class]])
            {
                message = @"";
            }
            if(message.length == 0)
                message = @"更改默认地址失败";
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
