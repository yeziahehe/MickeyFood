//
//  UITableViewCell+YFAdditions.h
//  V2EX
//
//  Created by 叶帆 on 14-9-20.
//  Copyright (c) 2014年 yefan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (YFAdditions)

/**
 适配iOS8下tabelview separator zero的问题
 */
- (void)zeroSeparatorInset;

@end
