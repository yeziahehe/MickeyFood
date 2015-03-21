//
//  YFCommonMethods.h
//  V2EX
//
//  Created by 叶帆 on 14-10-10.
//  Copyright (c) 2014年 yefan. All rights reserved.
//

/*
 该类集中了一些通用的方法，这些方法不适合加入到category中，集中到该类中统一管理
 该类中的方法会不定期更新
 */

#import <Foundation/Foundation.h>

@interface YFCommonMethods : NSObject

/**
 该方法用于计算UITextView更新text之后的contentSize.height
 ios7 and later
 
 @param textView 更新text之后需要计算高度的textView
 @returns 返回实际内容高度
 */
+ (CGFloat)measureHeightOfUITextView:(UITextView *)textView;

/**
 该方法用于UILabel根据文字的高度动态变化的函数
 ios7 and later
 
 @param textLabel 需要计算高度的UILabel
 @return 返回实际内容高度
 */
+ (CGFloat)measureHeightOfUILabel:(UILabel *)textLabel;

/**
 *  base64编码
 *  文字或图片转成二进制data之后进行base64编码，lineLength传0即可
 *  @param imgData    需要编码的数据流
 *  @param lineLength 传0即可
 *
 *  @return 编码后的base64字符串
 */
+ (NSString *) base64StringFromData:(NSData *)imgData length:(NSInteger)lineLength;

@end
