//
//  UIImage+YFUtilities.m
//  SJFood
//
//  Created by 叶帆 on 14/12/10.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "UIImage+YFUtilities.h"

@implementation UIImage (YFUtilities)

+ (CGSize)equalScaleSizeForMaxSize:(CGSize)maxSize actualSize:(CGSize)actualSize
{
    CGFloat picWidth = maxSize.width;
    CGFloat picHeight = maxSize.height;
    
    CGFloat actWidth = actualSize.width;
    CGFloat actHeight = actualSize.height;
    
    if(actualSize.width <= picWidth && actualSize.height <= picHeight)
    {
        actWidth = actualSize.width;
        actHeight = actualSize.height;
    }
    else if(actualSize.width > picWidth && actualSize.height <= picHeight)
    {
        actHeight = actHeight*picWidth/actWidth;
        actWidth = picWidth;
    }
    else if(actualSize.width <= picWidth && actualSize.height > picHeight)
    {
        actWidth = actWidth*picHeight/actHeight;
        actHeight = picHeight;
    }
    else if(actualSize.width > picWidth && actualSize.height > picHeight)
    {
        if((actualSize.width/picWidth) >= (actualSize.height/picHeight))
        {
            actHeight = picWidth/actWidth*actHeight;
            actWidth = picWidth;
        }
        else
        {
            actWidth = picHeight/actHeight*actWidth;
            actHeight = picHeight;
        }
    }
    CGSize euqalScaleSize = CGSizeMake(actWidth, actHeight);
    return euqalScaleSize;
}

- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize {
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}

@end
