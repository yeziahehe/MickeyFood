//
//  FoodDetail.m
//  SJFood
//
//  Created by 叶帆 on 14/12/21.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "FoodDetail.h"

@implementation FoodDetail
@synthesize foodId,name,price,discountPrice,grade,imgUrl,info,foodCount,isDiscount,saleNumber,foodSpecial,commentNumber;

- (id)initWithDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        for(NSString *key in [dict allKeys])
        {
            NSString *value = [dict objectForKey:key];
            if ([key isEqualToString:@"foodSpecial"])
            {
                if (![value isKindOfClass:[NSNull class]])
                {
                    NSArray *valueArray = (NSArray *)value;
                    self.foodSpecial = [NSMutableArray array];
                    for (NSDictionary *valueDict in valueArray)
                    {
                        FoodSpec *fs = [[FoodSpec alloc]initWithDict:valueDict];
                        [self.foodSpecial addObject:fs];
                    }
                }
            }
            else
            {
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

+ (instancetype)foodDetailWithDict:(NSDictionary *)dict
{
    return [[FoodDetail alloc]initWithDict:dict];
}

@end
