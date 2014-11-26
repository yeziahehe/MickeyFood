//
//  UIView+YFUtilities.m
//  V2EX
//
//  Created by 叶帆 on 14-9-18.
//  Copyright (c) 2014年 yefan. All rights reserved.
//

#import "UIView+YFUtilities.h"

@implementation UIView (YFUtilities)

-(void)addGrayGradientShadow
{
	// 0.8 is a good feeling shadowOpacity
	self.layer.shadowOpacity = 0.8f;
	
	// The Width and the Height of the shadow rect
	CGFloat rectWidth = 10.f;
	CGFloat rectHeight = self.frame.size.height;
	
	// Creat the path of the shadow
	CGMutablePathRef shadowPath = CGPathCreateMutable();
	// Move to the (0, 0) point
	CGPathMoveToPoint(shadowPath, NULL, 0.0, 0.0);
	// Add the Left and right rect
	CGPathAddRect(shadowPath, NULL, CGRectMake(0.0-rectWidth, 0.0, rectWidth, rectHeight));
	CGPathAddRect(shadowPath, NULL, CGRectMake(self.frame.size.width+rectWidth, 0.0, rectWidth, rectHeight));
	
	self.layer.shadowPath = shadowPath;
	CGPathRelease(shadowPath);
	// Since the default color of the shadow is black, we do not need to set it now
	self.layer.shadowColor = [UIColor redColor].CGColor;
	
	self.layer.shadowOffset = CGSizeMake(0, 0);
	// This is very important, the shadowRadius decides the feel of the shadow
	self.layer.shadowRadius = 0;
}

- (void)addAnimationWithType:(NSString *)type subtype:(NSString *)subtype
{
    CATransition *transtion = [CATransition animation];
    transtion.duration = 0.5f;
    transtion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transtion.type = type;
    transtion.subtype = subtype;
    [self.layer addAnimation:transtion forKey:nil];
}

@end
