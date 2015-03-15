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
#import "MyAccountViewController.h"

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
        CGRect rect = userInfoSubView.frame;
        rect.origin.y = originY;
        rect.origin.x = 0.0f;
        if ([userInfoSubView isKindOfClass:[UserView class]]) {
            UserView *uv = (UserView *)userInfoSubView;
            if ([[MemberDataManager sharedManager] isLogin]) {
                [uv reloadWithUserInfo:self.mineInfo];
            }
            rect = uv.frame;
            rect.size.width = ScreenWidth;
        }
        else if ([userInfoSubView isKindOfClass:[OrderInfoView class]]) {
            OrderInfoView *oiv = (OrderInfoView *)userInfoSubView;
//            if ([[MemberDataManager sharedManager] isLogin]) {
//                [oiv reloadWithUserInfo:self.mineInfo];
//            }
            rect.size.height = oiv.orderInfoTableView.contentSize.height;
            rect.size.width = ScreenWidth;
        }
        else if ([userInfoSubView isKindOfClass:[UserEditView class]]) {
            UserEditView *uev = (UserEditView *)userInfoSubView;
//            if ([[MemberDataManager sharedManager] isLogin]) {
//                [uev reloadWithUserInfo:self.mineInfo];
//            }
            rect.size.height = uev.userEditTableView.contentSize.height;
            rect.size.width = ScreenWidth;
        }
        else if ([userInfoSubView isKindOfClass:[UserSettingView class]]) {
            UserSettingView *usv = (UserSettingView *)userInfoSubView;
//            if ([[MemberDataManager sharedManager] isLogin]) {
//                [usv reloadWithUserInfo:self.mineInfo];
//            }
            rect.size.height = usv.userSettingTableView.contentSize.height;
            rect.size.width = ScreenWidth;
        }
        userInfoSubView.frame = rect;
        [self.contentScrollView addSubview:userInfoSubView];
        originY = rect.origin.y + rect.size.height + kSubViewGap;
    }
    [self.contentScrollView setContentSize:CGSizeMake(self.contentScrollView.frame.size.width, originY)];
}

- (void)refreshUserInfo
{
    [[MemberDataManager sharedManager] requestForUserInfo:[MemberDataManager sharedManager].loginMember.phone];
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
    [self extraItemTapped];
    [self.contentScrollView removeHeader];
    if ([[MemberDataManager sharedManager] isLogin])
    {
        [self.contentScrollView addHeaderWithTarget:self action:@selector(refreshUserInfo) dateKey:@"userInfoScrollView"];
        [[MemberDataManager sharedManager] requestForUserInfo:[MemberDataManager sharedManager].loginMember.phone];
    } else {
        [self loadSubViews];
    }
}

- (void)refreshUserInfoWithNotification:(NSNotification *)notification
{
    [[MemberDataManager sharedManager] requestForUserInfo:[MemberDataManager sharedManager].loginMember.phone];
}

- (void)userInfoResponseWithNotification:(NSNotification *)notification
{
    if (notification.object) {
        [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:@"个人信息获取失败" hideDelay:2.f];
    } else {
        self.mineInfo = [MemberDataManager sharedManager].mineInfo;
        [self.contentScrollView headerEndRefreshing];
        [self loadSubViews];
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshAccoutNotification object:nil];
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
    [self loadSubViews];
    [self.contentScrollView addHeaderWithTarget:self action:@selector(refreshUserInfo) dateKey:@"userInfoScrollView"];
    if ([[MemberDataManager sharedManager] isLogin]) {
        [[MemberDataManager sharedManager] requestForUserInfo:[MemberDataManager sharedManager].loginMember.phone];
    } else {
        [self.contentScrollView removeHeader];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showUserInfoViewResponseWithNotification:) name:kShowUserInfoViewNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userChangeWithNotification:) name:kUserChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserInfoWithNotification:) name:kRefreshUserInfoNotificaiton object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoResponseWithNotification:) name:kUserInfoResponseNotification object:nil];
}

- (void)dealloc
{
    [[YFDownloaderManager sharedManager]cancelDownloaderWithDelegate:self purpose:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
