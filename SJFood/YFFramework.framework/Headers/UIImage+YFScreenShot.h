//
//  UIImage+YFScreenShot.h
//  SJFood
//
//  Created by 叶帆 on 14/12/24.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YFScreenShot)

/**
	按照传入的UIView的实际frame截图
	@param shotView 需要截图的view
	@returns 返回截图之后的image
 */
+ (UIImage *)screenShotForView:(UIView *)shotView;


/**
	按照传入的scrollView的实际contentSize截图
	@param scrollView 需要截图的scrollView
	@returns 返回截图之后的image
 */
+ (UIImage *) screenShotForScrollView:(UIScrollView *)scrollView;

@end
