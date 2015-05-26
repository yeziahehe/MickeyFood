//
//  CourierOrder.m
//  SJFood
//
//  Created by 叶帆 on 15/3/30.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "CourierOrder.h"
#import "OrderList.h"

@implementation CourierOrder

@synthesize togetherId,togetherDate,status,address,customePhone,totalPrice,nickName,orderList,message,reserveTime;

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        for (NSString *key in [dict allKeys]) {
            NSString *value = [dict objectForKey:key];
            if ([key isEqualToString:@"orderList"])
            {
                if (![value isKindOfClass:[NSNull class]])
                {
                    NSArray *valueArray = (NSArray *)value;
                    self.orderList = [NSMutableArray array];
                    for (NSDictionary *valueDict in valueArray)
                    {
                        OrderList *ol = [[OrderList alloc]initWithDict:valueDict];
                        [self.orderList addObject:ol];
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

@end
