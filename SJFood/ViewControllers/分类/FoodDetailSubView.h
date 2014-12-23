//
//  FoodDetailSubView.h
//  SJFood
//
//  Created by 叶帆 on 14/12/21.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodDetail.h"

@interface FoodDetailSubView : UIView

/**
 * 每个子UIView用来判断是否登录的方法
 */
- (BOOL)showLoginViewController;
- (void)reloadWithFoodDetail:(FoodDetail *)foodDetail;

@end
