//
//  UIView+YFUtilities.h
//  V2EX
//
//  Created by 叶帆 on 14-9-18.
//  Copyright (c) 2014年 yefan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YFUtilities)

//两侧外阴影
-(void)addGrayGradientShadow;

/**
 view中加入CAAnimation
 @param type    动画类型- kCATransitionPush
 @param subtype 动画子类型 - kCATransitionFromTop
 
 以下是基本的四种效果
 kCATransitionPush   推入效果
 kCATransitionMoveIn 移入效果
 kCATransitionReveal 截开效果
 kCATransitionFade   渐入渐出效果
 
 其他的效果目前未加入
 加入需要添加 #import <QuartzCore/QuartzCore.h>
 
 动画子类型的效果
 kCATransitionFromRight  右边进入
 kCATransitionFromLeft   左边进入
 kCATransitionFromTop    上面进入
 kCATransitionFromBottom 下面进入
 */
- (void)addAnimationWithType:(NSString *)type subtype:(NSString *)subtype;

@end
