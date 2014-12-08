//
//  UserInfoViewController.m
//  SJFood
//
//  Created by 叶帆 on 14/12/2.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserView.h"
#import "OrderInfoView.h"
#import "UserEditView.h"
#import "UserSettingView.h"
#import "MineInfo.h"

#define kUserInfoDownloaderKey          @"UserInfoDownloaderKey"
#define kUserInfoMapFileName            @"UserInfoMap"
#define kSubViewGap                     15.f

@interface UserInfoViewController ()
@property (nonatomic, strong) NSMutableArray *subViewArray;
@property (nonatomic, strong) MineInfo *mineInfo;
@end

@implementation UserInfoViewController
@synthesize contentScrollView;
@synthesize subViewArray,mineInfo;

#pragma mark - Private Methods
- (void)loadSubViews
{
    for (UIView *subView in self.contentScrollView.subviews)
    {
        if ([subView isKindOfClass:[UserInfoSubView class]]) {
            [subView removeFromSuperview];
        }
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:kUserInfoMapFileName ofType:@"plist"];
    self.subViewArray = [NSMutableArray arrayWithContentsOfFile:path];
    
    //加载每个子模块
    CGFloat originY = kSubViewGap;
    for (NSString *classString in self.subViewArray) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:classString owner:self options:nil];
        UserInfoSubView *userInfoSubView = [nibs lastObject];
        //to do userInfoSubView Delegate
        CGRect rect = userInfoSubView.frame;
        rect.origin.y = originY;
        rect.origin.x = (self.contentScrollView.frame.size.width-rect.size.width)/2;
        if ([userInfoSubView isKindOfClass:[UserView class]]) {
            UserView *uv = (UserView *)userInfoSubView;
            if ([[MemberDataManager sharedManager] isLogin]) {
                [uv reloadWithUserInfo:self.mineInfo];
            }
            rect = uv.frame;
        }
        else if ([userInfoSubView isKindOfClass:[OrderInfoView class]]) {
            OrderInfoView *oiv = (OrderInfoView *)userInfoSubView;
            if ([[MemberDataManager sharedManager] isLogin]) {
                [oiv reloadWithUserInfo:self.mineInfo];
            }
            rect.size.height = oiv.orderInfoTableView.contentSize.height;
        }
        else if ([userInfoSubView isKindOfClass:[UserEditView class]]) {
            UserEditView *uev = (UserEditView *)userInfoSubView;
            if ([[MemberDataManager sharedManager] isLogin]) {
                [uev reloadWithUserInfo:self.mineInfo];
            }
            rect.size.height = uev.userEditTableView.contentSize.height;
        }
        else if ([userInfoSubView isKindOfClass:[UserSettingView class]]) {
            UserSettingView *usv = (UserSettingView *)userInfoSubView;
            if ([[MemberDataManager sharedManager] isLogin]) {
                [usv reloadWithUserInfo:self.mineInfo];
            }
            rect.size.height = usv.userSettingTableView.contentSize.height;
        }
        userInfoSubView.frame = rect;
        [self.contentScrollView addSubview:userInfoSubView];
        originY = rect.origin.y + rect.size.height + kSubViewGap;
    }
    [self.contentScrollView setContentSize:CGSizeMake(self.contentScrollView.frame.size.width, originY)];
}

#pragma mark - Public Methods
- (void)requestForUserInfo:(NSString *)phone
{
    if (nil == phone)
        phone = @"";
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kUserInfoUrl];
    NSMutableDictionary *dict = kCommonParamsDict;
    [dict setObject:phone forKey:@"phone"];
    [[YFDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:dict
                                                            contentType:@"application/x-www-form-urlencoded"
                                                               delegate:self
                                                                purpose:kUserInfoDownloaderKey];
}

#pragma mark - Notification Methods
- (void)showUserInfoViewResponseWithNotification:(NSNotification *)notification
{
    if (notification) {
        NSString *moduleClassName = notification.object;
        id moduleViewController = [[NSClassFromString(moduleClassName) alloc] init];
        [self.navigationController pushViewController:moduleViewController animated:YES];
    }
}

- (void)userChangeWithNotification:(NSNotification *)notification
{
    if ([[MemberDataManager sharedManager] isLogin])
    {
        [self requestForUserInfo:[MemberDataManager sharedManager].loginMember.phone];
    } else {
        [self loadSubViews];
    }
}

#pragma mark - BaseViewController methods
- (void)extraItemTapped
{
    [self.contentScrollView setContentOffset:CGPointMake(0, -self.contentScrollView.contentInset.top) animated:YES];
}

#pragma mark - UIViewController View
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"我的"];
    if ([[MemberDataManager sharedManager] isLogin]) {
        //to do 先加载缓存
        [self requestForUserInfo:[MemberDataManager sharedManager].loginMember.phone];
    } else {
        [self loadSubViews];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showUserInfoViewResponseWithNotification:) name:kShowUserInfoViewNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userChangeWithNotification:) name:kUserChangeNotification object:nil];
}

- (void)dealloc
{
    [[YFDownloaderManager sharedManager]cancelDownloaderWithDelegate:self purpose:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - YFDownloaderDelegate Methods
- (void)downloader:(YFDownloader *)downloader completeWithNSData:(NSData *)data
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([downloader.purpose isEqualToString:kUserInfoDownloaderKey])
    {
        NSDictionary *dict = [str JSONValue];
        if([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode])
        {
            self.mineInfo = [MineInfo mineInfoWithDict:dict];
            //to do 缓存
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
                message = @"刷新个人信息失败";
            [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:message hideDelay:2.f];
        }
    }
}

- (void)downloader:(YFDownloader *)downloader didFinishWithError:(NSString *)message
{
    [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:kNetWorkErrorString hideDelay:2.f];
}

@end
