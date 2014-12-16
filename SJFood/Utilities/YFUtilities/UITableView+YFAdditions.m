//
//  UITableView+YFAdditions.m
//  V2EX
//
//  Created by 叶帆 on 14-9-19.
//  Copyright (c) 2014年 yefan. All rights reserved.
//

#import "UITableView+YFAdditions.h"

@implementation UITableView (YFAdditions)

- (void)zeroSeparatorInset
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([self respondsToSelector:@selector(setLayoutMargins:)])
        self.layoutMargins = UIEdgeInsetsZero;
#endif
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([self respondsToSelector: @selector(setSeparatorInset:)])
        self.separatorInset = UIEdgeInsetsZero;
#endif
}

@end
