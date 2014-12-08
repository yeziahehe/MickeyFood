//
//  UserView.m
//  SJFood
//
//  Created by 叶帆 on 14/12/5.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "UserView.h"

@implementation UserView
@synthesize iconImageView;

#pragma mark - Public Methods
- (void)reloadWithUserInfo:(MineInfo *)mineInfo
{
    self.loginButton.enabled = NO;
    [self.loginButton setTitle:mineInfo.userInfo.nickname forState:UIControlStateNormal];
    //头像
    self.iconImageView.cacheDir = kUserIconCacheDir;
    [self.iconImageView aysnLoadImageWithUrl:mineInfo.userInfo.imgUrl placeHolder:@"icon_user_image_defult.png"];
    
//    YFBadgeView *badgeView = [[YFBadgeView alloc]initWithParentView:self alignment:YFBadgeViewAlignmentTopRight];
//    badgeView.badgeText = @"1";
}

#pragma mark - IBAction Methods
- (IBAction)loginButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowLoginViewNotification object:nil];
}

- (IBAction)deleveryButtonClicked:(id)sender {
    if ([self showLoginViewController]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowUserInfoViewNotification object:@"DeliveryViewController"];
    }
}

- (IBAction)receiveButtonClicked:(id)sender {
    if ([self showLoginViewController]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowUserInfoViewNotification object:@"ReceiveViewController"];
    }
}

- (IBAction)commentButtonClicked:(id)sender {
    if ([self showLoginViewController]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowUserInfoViewNotification object:@"CommentViewController"];
    }
}

- (IBAction)refundButtonClicked:(id)sender {
    if ([self showLoginViewController]) {
        if ([self showLoginViewController]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kShowUserInfoViewNotification object:@"RefundViewController"];
        }
    }
}

#pragma mark - UIView methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.loginButton.enabled = YES;
    self.iconImageView.layer.cornerRadius = 37.f;
    self.iconImageView.layer.borderWidth =  4.f;
    self.iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.iconImageView.layer.masksToBounds = YES;
}

@end
