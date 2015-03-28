//
//  SendOrdersViewController.m
//  SJFood
//
//  Created by 叶帆 on 15/3/27.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "SendOrdersViewController.h"

#define kSendOrderDownloaderKey         @"SendOrderDownloaderKey"

@interface SendOrdersViewController ()
@property (nonatomic, strong) NSMutableArray *sendOrderArray;
@property (nonatomic, strong) NSString *isSelected;
@end

@implementation SendOrdersViewController
@synthesize sendOrderTableView,notSelectButton,selectedButton,noOrderView;
@synthesize sendOrderArray,isSelected;


#pragma mark - Private Methods
- (void)loadSubViews
{
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

#pragma mark - BaseViewController Methods
- (void)extraItemTapped
{
    [self.sendOrderTableView setContentOffset:CGPointMake(0, -self.sendOrderTableView.contentInset.top) animated:YES];
}

#pragma mark - UIViewController Methods
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
    self.notSelectButton.selected = YES;
    self.isSelected = @"0";
    [self requestForSendOrder];
}

- (void)dealloc
{
    [[YFDownloaderManager sharedManager] cancelDownloaderWithDelegate:self purpose:nil];
}

@end
