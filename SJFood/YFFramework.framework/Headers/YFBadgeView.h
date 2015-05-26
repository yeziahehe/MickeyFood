//
//  YFBadgeView.h
//  SJFood
//
//  Created by 叶帆 on 14/12/8.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

/**
 * YF用在view的固定位显示角标的类
 */
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
    YFBadgeViewAlignmentTopRight = 0,
    YFBadgeViewAlignmentCenterRight
}YFBadgeViewPosition;

@interface YFBadgeView : UIView

@property (nonatomic, copy) NSString *badgeText;
@property (nonatomic, assign) YFBadgeViewPosition badgeAlignment;
/**
 * 角标文字的颜色，默认为白色
 */
@property (nonatomic, strong) UIColor *badgeTextColor;
/**
 * 角标的文字大小，默认为12
 */
@property (nonatomic, strong) UIFont *badgeTextFont;
/**
 * 角标的背景色，默认为MainProjectColor
 */
@property (nonatomic, strong) UIColor *badgeBackgroundColor;

/**
 * 初始化角标的方法
 * @param parentView 添加角标的父View
 * @param alignment  角标的位置
 * @return           YFBadgeView
 */
- (id)initWithParentView:(UIView *)parentView alignment:(YFBadgeViewPosition)alignment;

@end
