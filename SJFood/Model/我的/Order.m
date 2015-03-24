//
//  Order.m
//  SJFood
//
//  Created by 叶帆 on 15/3/24.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "Order.h"
#import "OrderDetails.h"

@implementation Order
@synthesize status,togetherDate,togetherId,smallOrders;

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        for (NSString *key in [dict allKeys]) {
            NSString *value = [dict objectForKey:key];
            if ([key isEqualToString:@"smallOrders"])
            {
                if (![value isKindOfClass:[NSNull class]])
                {
                    NSArray *valueArray = (NSArray *)value;
                    self.smallOrders = [NSMutableArray array];
                    for (NSDictionary *valueDict in valueArray)
                    {
                        OrderDetails *od = [[OrderDetails alloc]initWithDict:valueDict];
                        [self.smallOrders addObject:od];
                    }
                }
            }
            else {
                if([value isKindOfClass:[NSNumber class]])
                    value = [NSString stringWithFormat:@"%@",value];
                else if([value isKindOfClass:[NSNull class]])
                    value = @"";
                @try {
                    [self setValue:value forKey:key];
                }
                @catch (NSException *exception) {
                    NSLog(@"试图添加不存在的key:%@到实例:%@中.",key,NSStringFromClass([self class]));
                }
            }
        }
    }
    return self;
}

+ (instancetype)orderWithDict:(NSDictionary *)dict
{
    return [[Order alloc]initWithDict:dict];
}

@end
