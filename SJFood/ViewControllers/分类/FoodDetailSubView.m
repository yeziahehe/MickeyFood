//
//  FoodDetailSubView.m
//  SJFood
//
//  Created by 叶帆 on 14/12/21.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "FoodDetailSubView.h"

@implementation FoodDetailSubView

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

- (void)reloadWithFoodDetail:(FoodDetail *)foodDetail
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
