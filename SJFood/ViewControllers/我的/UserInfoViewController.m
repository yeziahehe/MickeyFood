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
#import "SettingView.h"

#define kUserInfoMapFileName            @"UserInfoMap"
#define kSubViewGap                     15.f

@interface UserInfoViewController ()

@property (nonatomic, strong) NSMutableArray *subViewArray;

@end

@implementation UserInfoViewController
@synthesize contentScrollView;
@synthesize subViewArray;

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
            rect = uv.frame;
        }
        else if ([userInfoSubView isKindOfClass:[OrderInfoView class]]) {
            OrderInfoView *oiv = (OrderInfoView *)userInfoSubView;
            rect.size.height = oiv.orderInfoTableView.contentSize.height;
        }
        else if ([userInfoSubView isKindOfClass:[UserEditView class]]) {
            UserEditView *uev = (UserEditView *)userInfoSubView;
            rect.size.height = uev.userEditTableView.contentSize.height;
        }
        else if ([userInfoSubView isKindOfClass:[SettingView class]]) {
            SettingView *sv = (SettingView *)userInfoSubView;
            rect.size.height = sv.settingTableView.contentSize.height;
        }
        userInfoSubView.frame = rect;
        [self.contentScrollView addSubview:userInfoSubView];
        originY = rect.origin.y + rect.size.height + kSubViewGap;
    }
    [self.contentScrollView setContentSize:CGSizeMake(self.contentScrollView.frame.size.width, originY)];
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
}

@end
