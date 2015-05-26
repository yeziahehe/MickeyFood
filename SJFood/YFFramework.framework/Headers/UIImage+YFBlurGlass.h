//
//  UIImage+YFBlurGlass.h
//  V2EX
//
//  Created by 叶帆 on 14-9-21.
//  Copyright (c) 2014年 yefan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YFBlurGlass)

/**
 创建类似ios7 中的毛玻璃底，同步创建模糊的底图
 @param image 需要变模糊的原图
 @param blur 模糊程度，最小0，最大1，超出这个范围默认使用 0.5
 @returns 模糊处理后的返回图片
 */
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;


/**
 创建类似ios7 中的毛玻璃底，异步创建模糊的底图
 @param originImage 需要变模糊的原图
 @param level 模糊程度，最小0，最大1，超出这个范围默认使用 0.5
 */
+ (void)blurOriginImage:(UIImage *)originImage
              blurLevel:(CGFloat)level
             completion:(void(^)(UIImage *image))completion;

@end
