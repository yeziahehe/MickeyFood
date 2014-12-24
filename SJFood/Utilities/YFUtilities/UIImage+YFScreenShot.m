//
//  UIImage+YFScreenShot.m
//  SJFood
//
//  Created by 叶帆 on 14/12/24.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "UIImage+YFScreenShot.h"

@implementation UIImage (YFScreenShot)

+ (UIImage *)screenShotForView:(UIView *)shotView
{
    UIGraphicsBeginImageContext(shotView.frame.size);
    [shotView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *shareImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return shareImage;
}

+ (UIImage *) screenShotForScrollView:(UIScrollView *)scrollView
{
    UIImage* image = nil;
    
    UIGraphicsBeginImageContext(scrollView.contentSize);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    return image;
}

@end
