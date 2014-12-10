//
//  UIImage+YFUtilities.h
//  SJFood
//
//  Created by 叶帆 on 14/12/10.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YFUtilities)

/**
 将实际图片的尺寸等比缩小到提供的最大尺寸内，如果实际尺寸小于最大尺寸，返回实际尺寸
 @param maxSize 获取图片的最大尺寸
 @param actualSize 图片的实际尺寸
 @return 同比缩小的尺寸，如果图片的整体都小雨最大尺寸，返回图片实际尺寸，如果大于，则同比缩小
 */
+ (CGSize)equalScaleSizeForMaxSize:(CGSize)maxSize actualSize:(CGSize)actualSize;

/**
 同比缩小图片的size，如果不足targetSize，png填充，返回的图片大小: targetSize
 @param targetSize 目标尺寸
 @return targetSize大小的图片
 */
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;

@end
