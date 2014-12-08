//
//  UserInfoSubView.m
//  SJFood
//
//  Created by 叶帆 on 14/12/5.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "UserInfoSubView.h"

@implementation UserInfoSubView

#pragma mark - Public Methods
- (BOOL)showLoginViewController
{
    if ([[MemberDataManager sharedManager] isLogin])
    {
        return YES;
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowLoginViewNotification object:nil];
        return NO;
    }
}

- (void)reloadWithUserInfo:(MineInfo *)mineInfo
{
}

#pragma mark - UIVIew Methods
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

@end
