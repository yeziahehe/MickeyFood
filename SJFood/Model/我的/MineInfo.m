//
//  MineInfo.m
//  SJFood
//
//  Created by 叶帆 on 14/12/8.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "MineInfo.h"

@implementation MineInfo
@synthesize userInfo,waitDeliveryOrder,waitReceiveOrder,waitCommentOrder,waitRefundOrder;

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        for (NSString *key in [dict allKeys]) {
            NSString *value = [dict objectForKey:key];
            if ([key isEqualToString:@"userInfo"]) {
                if(![value isKindOfClass:[NSNull class]])
                {
                    NSDictionary *valueDict = (NSDictionary *)value;
                    userInfo = [[UserInfo alloc] initWithDict:valueDict];
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

+ (instancetype)mineInfoWithDict:(NSDictionary *)dict
{
    return [[MineInfo alloc] initWithDict:dict];
}

@end
