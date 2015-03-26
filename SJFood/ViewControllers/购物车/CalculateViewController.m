//
//  CalculateViewController.m
//  SJFood
//
//  Created by 叶帆 on 15/3/25.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "CalculateViewController.h"
#import "CalculateSubView.h"
#import "Address.h"
#import "AddressChooseView.h"
#import "CalculateDetailView.h"
#import "AddressAddViewController.h"
#import "AddressListViewController.h"

#define kCalculateInfoMapFileName           @"CalculateInfoMap"
#define kGetAddressDownloaderKey            @"GetAddressDownloaderKey"
#define kSubViewGap                         15.f

@interface CalculateViewController ()
@property (nonatomic, strong) NSMutableArray *subViewArray;
@property (nonatomic, strong) NSMutableArray *addressArray;
@end

@implementation CalculateViewController
@synthesize contentScrollView;
@synthesize totalPriceLabel;
@synthesize subViewArray,addressArray,orderListArray,orderCodeArray,totalPrice;

#pragma mark - Private Methods
- (void)loadSubViews:(Address *)address
{
    self.totalPriceLabel.text = self.totalPrice;
    for (UIView *subView in self.contentScrollView.subviews)
    {
        if ([subView isKindOfClass:[CalculateSubView class]])
        {
            [subView removeFromSuperview];
        }
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:kCalculateInfoMapFileName ofType:@"plist"];
    self.subViewArray = [NSMutableArray arrayWithContentsOfFile:path];
    
    CGFloat originY = 0.f;
    for (NSString *classString in self.subViewArray) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:classString owner:self options:nil];
        CalculateSubView *calculateSubView = [nibs lastObject];
        CGRect rect = calculateSubView.frame;
        rect.origin.y = originY;
        rect.origin.x = 0.0f;
        if ([calculateSubView isKindOfClass:[AddressChooseView class]]) {
            AddressChooseView *acv = (AddressChooseView *)calculateSubView;
            [acv reloadData:address];
            [[NSNotificationCenter defaultCenter]postNotificationName:kReloadRefreshAddressNotification object:self.addressArray];
            rect = acv.frame;
            rect.size.width = ScreenWidth;
        }
        else if ([calculateSubView isKindOfClass:[CalculateDetailView class]]) {
            CalculateDetailView *cdv = (CalculateDetailView *)calculateSubView;
            cdv.totalPrice = self.totalPrice;
            [cdv reloadData:self.orderListArray];
            rect.size.height = cdv.orderListTableView.contentSize.height + 36.f;
            rect.size.width = ScreenWidth;
        }
        calculateSubView.frame = rect;
        [self.contentScrollView addSubview:calculateSubView];
        originY = rect.origin.y + rect.size.height + kSubViewGap;
    }
    [self.contentScrollView setContentSize:CGSizeMake(self.contentScrollView.frame.size.width, originY)];
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

- (Address *)loadDefualtAddress
{
    //找到默认地址
    for (Address *address in self.addressArray) {
        if ([address.tag isEqualToString:@"0"]) {
            return address;
        }
    }
    return nil;
}

- (void)tipToAddAddress
{
    //提示添加地址
    if (IsIos8) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:@"未添加默认地址，去添加？"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action) {
                                                    [self.navigationController popViewControllerAnimated:YES];
                                                }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action) {
                                                    AddressAddViewController *addressAddViewController = [[AddressAddViewController alloc]initWithNibName:@"AddressAddViewController" bundle:nil];
                                                    [self.navigationController pushViewController:addressAddViewController animated:YES];
                                                }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"未添加默认地址，去添加？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

#pragma mark - IBAction Methods
- (IBAction)confirmButtonClicked:(id)sender {
    
}

#pragma mark - Notification Methods
- (void)refreshAddressInfoWithNotification:(NSNotification *)notification
{
    [self requestForAddressInfo];
}

- (void)addressViewShowNotification:(NSNotification *)notification
{
    AddressListViewController *addressListViewController = [[AddressListViewController alloc]initWithNibName:@"AddressListViewController" bundle:nil];
    addressListViewController.addressArray = self.addressArray;
    addressListViewController.selectedAddress = notification.object;
    [self.navigationController pushViewController:addressListViewController animated:YES];
}

- (void)selectAddressNotification:(NSNotification *)notification
{
    [self loadSubViews:notification.object];
}

#pragma mark - BaseViewController methods
- (void)extraItemTapped
{
    [self.contentScrollView setContentOffset:CGPointMake(0, -self.contentScrollView.contentInset.top) animated:YES];
}

#pragma mark - UIViewController Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"确认订单"];
    [self requestForAddressInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAddressInfoWithNotification:) name:kRefreshAddressNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressViewShowNotification:) name:kAddressViewShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectAddressNotification:) name:kSelectAddressNotification object:nil];
}

- (void)dealloc
{
    [[YFDownloaderManager sharedManager]cancelDownloaderWithDelegate:self purpose:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - AlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        AddressAddViewController *addressAddViewController = [[AddressAddViewController alloc]initWithNibName:@"AddressAddViewController" bundle:nil];
        [self.navigationController pushViewController:addressAddViewController animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
            [[YFProgressHUD sharedProgressHUD] stoppedNetWorkActivity];
            self.addressArray = [NSMutableArray arrayWithCapacity:0];
            NSArray *valueArray = [dict objectForKey:@"receivers"];
            for(NSDictionary *valueDict in valueArray)
            {
                Address *address = [[Address alloc] initWithDict:valueDict];
                [self.addressArray addObject:address];
            }
            if (self.addressArray.count > 0) {
                //找到默认地址
                [self loadSubViews:[self loadDefualtAddress]];
            } else {
                //提示添加地址
                [self tipToAddAddress];
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
}

- (void)downloader:(YFDownloader *)downloader didFinishWithError:(NSString *)message
{
    [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:kNetWorkErrorString hideDelay:2.f];
}

@end
