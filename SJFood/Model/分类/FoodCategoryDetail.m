//
//  FoodCategoryDetail.m
//  SJFood
//
//  Created by 叶帆 on 14/12/14.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "FoodCategoryDetail.h"

@implementation FoodCategoryDetail
@synthesize category,categoryId,imgUrl;

- (id)initWithDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        for(NSString *key in [dict allKeys])
        {
            NSString *value = [dict objectForKey:key];

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
    return self;
}

- (NSMutableDictionary *)toCacheDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.category forKey:@"category"];
    [dict setValue:self.categoryId forKey:@"categoryId"];
    [dict setValue:self.imgUrl forKey:@"imgUrl"];
    return dict;
}

@end
