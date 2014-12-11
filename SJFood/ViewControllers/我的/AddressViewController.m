//
//  AddressViewController.m
//  SJFood
//
//  Created by 叶帆 on 14/12/6.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressTableViewCell.h"
#import "DefaultAddressTableViewCell.h"
#import "Address.h"

#define kGetAddressDownloaderKey            @"GetAddressDownloaderKey"

@interface AddressViewController ()
@property (nonatomic, strong) NSMutableArray *addressArray;
@property (nonatomic, strong) Address *addressInfo;
@end

@implementation AddressViewController
@synthesize addressTableView,noAddressView;
@synthesize addressArray,addressInfo;

#pragma mark - Private Methods
- (void)loadSubViews
{
    //初始化界面为没有地址
    self.addressArray = [NSMutableArray arrayWithCapacity:0];
    self.addressTableView.tableFooterView = self.noAddressView;
    [self.addressTableView reloadData];
}

- (void)requestForAddressInfo
{
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
- (IBAction)addAddressButtonClicked:(id)sender {
    
}

#pragma mark - BaseViewController Methods
- (void)rightItemTapped
{
    
}

#pragma mark - UIViewController Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"地址管理"];
    [self setRightNaviItemWithTitle:nil imageName:@"btn_add_address"];
    [self loadSubViews];
    [self requestForAddressInfo];
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.addressArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.addressInfo = [self.addressArray objectAtIndex:indexPath.row];
    if ([self.addressInfo.tag isEqualToString:@"0"]) {
        static NSString *cellIdentity = @"DefaultAddressTableViewCell";
        DefaultAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
        if (nil == cell)
        {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"DefaultAddressTableViewCell" owner:self options:nil];
            cell = [nibs lastObject];
        }
        cell.rank = self.addressInfo.rank;
        cell.nameLabel.text = self.addressInfo.name;
        cell.phoneLabel.text = self.addressInfo.phone;
        cell.addressLabel.text = [NSString stringWithFormat:@"%@%@",@"[默认]",self.addressInfo.address];
        
        return cell;
    }
    static NSString *cellIdentity = @"AddressTableViewCell";
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (nil == cell)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"AddressTableViewCell" owner:self options:nil];
        cell = [nibs lastObject];
    }
    cell.rank = self.addressInfo.rank;
    cell.nameLabel.text = self.addressInfo.name;
    cell.phoneLabel.text = self.addressInfo.phone;
    cell.addressLabel.text = self.addressInfo.address;
    
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68.f;
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
            NSArray *valueArray = [dict objectForKey:@"receivers"];
            for(NSDictionary *valueDict in valueArray)
            {
                Address *address = [[Address alloc] initWithDict:valueDict];
                [self.addressArray addObject:address];
            }
            if ([self.addressArray count] != 0) {
                self.addressTableView.tableFooterView = [UIView new];
                [self.addressTableView reloadData];
            } else {
                [self loadSubViews];
            }
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
            message = @"收货地址获取失败";
        [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:message hideDelay:2.f];
    }
}

- (void)downloader:(YFDownloader *)downloader didFinishWithError:(NSString *)message
{
    [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:kNetWorkErrorString hideDelay:2.f];
}

@end
