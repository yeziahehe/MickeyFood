//
//  SelectCourierViewController.m
//  SJFood
//
//  Created by 叶帆 on 15/3/28.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "SelectCourierViewController.h"
#import "UserInfo.h"

#define kGetCourierDownloaderKey            @"GetCourierDownloaderKey"
#define kSetCourierDownloaderKey            @"SetCourierDownloaderKey"

@interface SelectCourierViewController ()
@property (nonatomic, strong)NSMutableArray *courierArray;
@property (nonatomic, strong)NSString *adminPhone;
@end

@implementation SelectCourierViewController
@synthesize selectCourierTableView,noCourierView,courierName,courierArray,adminPhone,togetherId;

#pragma mark - Private Methods
- (void)requestForGetCourier
{
    [[YFProgressHUD sharedProgressHUD] showActivityViewWithMessage:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kGetCourierUrl];
    NSMutableDictionary *dict = kCommonParamsDict;
    [[YFDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:dict
                                                            contentType:@"application/x-www-form-urlencoded"
                                                               delegate:self
                                                                purpose:kGetCourierDownloaderKey];
}

#pragma mark - BaseViewController Methods
- (void)rightItemTapped
{
    if (self.adminPhone == nil) {
        [[YFProgressHUD sharedProgressHUD]showWithMessage:@"请选择快递员" customView:nil hideDelay:2.f];
    } else {
        [[YFProgressHUD sharedProgressHUD] showActivityViewWithMessage:@"选择中..."];
        NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kSetCourierUrl];
        NSMutableDictionary *dict = kCommonParamsDict;
        [dict setObject:self.adminPhone forKey:@"adminPhone"];
        [dict setObject:self.togetherId forKey:@"togetherId"];
        [[YFDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:dict
                                                            contentType:@"application/x-www-form-urlencoded"
                                                               delegate:self
                                                                purpose:kSetCourierDownloaderKey];
    }
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
    [self setNaviTitle:@"选择快递员"];
    [self setRightNaviItemWithTitle:@"确定" imageName:nil];
    [self requestForGetCourier];
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.courierArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"TableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentity];
    }
    UserInfo *userInfo = [self.courierArray objectAtIndex:indexPath.row];
    cell.textLabel.text = userInfo.nickname;
    cell.detailTextLabel.text = userInfo.phone;
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserInfo *userInfo = [self.courierArray objectAtIndex:indexPath.row];
    self.adminPhone = userInfo.phone;
}

#pragma mark - YFDownloaderDelegate Methods
- (void)downloader:(YFDownloader *)downloader completeWithNSData:(NSData *)data
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [str JSONValue];
    if ([downloader.purpose isEqualToString:kGetCourierDownloaderKey])
    {
        if([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode])
        {
            [[YFProgressHUD sharedProgressHUD] stoppedNetWorkActivity];
            self.courierArray = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *valueArray = [dict objectForKey:@"deliverAdmins"];
            if (valueArray.count == 0) {
                self.selectCourierTableView.tableFooterView = self.noCourierView;
            }
            else {
                for (NSDictionary *valueDict in valueArray) {
                    UserInfo *ui = [[UserInfo alloc]initWithDict:valueDict];
                    [self.courierArray addObject:ui];
                }
                self.selectCourierTableView.tableFooterView = [UIView new];
            }
            [self.selectCourierTableView reloadData];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if ([message isKindOfClass:[NSNull class]])
            {
                message = @"";
            }
            if(message.length == 0)
                message = @"获取快递员信息失败";
            [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:message hideDelay:2.f];
        }
    }
    if ([downloader.purpose isEqualToString:kSetCourierDownloaderKey])
    {
        if([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode])
        {
            [[YFProgressHUD sharedProgressHUD] showSuccessViewWithMessage:@"选择快递员成功，请去已派单中查看" hideDelay:2.f];
            [[NSNotificationCenter defaultCenter] postNotificationName:kSelectCourierNotification object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if ([message isKindOfClass:[NSNull class]])
            {
                message = @"";
            }
            if(message.length == 0)
                message = @"选择快递员失败";
            [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:message hideDelay:2.f];
        }
    }
}

- (void)downloader:(YFDownloader *)downloader didFinishWithError:(NSString *)message
{
    [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:kNetWorkErrorString hideDelay:2.f];
}

@end
