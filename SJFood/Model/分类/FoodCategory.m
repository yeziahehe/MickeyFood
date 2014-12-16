//
//  FoodCategory.m
//  SJFood
//
//  Created by 叶帆 on 14/12/14.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "FoodCategory.h"

@implementation FoodCategory
@synthesize category,child;

- (id)initWithDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        for(NSString *key in [dict allKeys])
        {
            NSString *value = [dict objectForKey:key];
            if ([key isEqualToString:@"child"])
            {
                if (![value isKindOfClass:[NSNull class]])
                {
                    NSArray *valueArray = (NSArray *)value;
                    self.child = [NSMutableArray array];
                    for (NSDictionary *valueDict in valueArray)
                    {
                        FoodCategoryDetail *fcd = [[FoodCategoryDetail alloc]initWithDict:valueDict];
                        [self.child addObject:fcd];
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

+ (instancetype)foodCategoryWithDict:(NSDictionary *)dict
{
    return [[FoodCategory alloc] initWithDict:dict];
}

- (NSMutableDictionary *)toCacheDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray *array = [NSMutableArray array];
    for (FoodCategoryDetail *foodCategoryDetail in self.child) {
        [array addObject:[foodCategoryDetail toCacheDictionary]];
    }
    [dict setValue:self.category forKey:@"category"];
    [dict setValue:array forKey:@"child"];
    return dict;
}

@end
