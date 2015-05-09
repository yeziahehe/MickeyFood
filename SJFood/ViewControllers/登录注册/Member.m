//
//  Member.m
//  SJFood
//
//  Created by 叶帆 on 14/12/3.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "Member.h"

#define kPhoneKey               @"PhoneKey"
#define kPasswordKey            @"PasswordKey"
#define kTypeKey                @"TypeKey"

@implementation Member

@synthesize phone,password,type;

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

+ (instancetype)memberWithDict:(NSDictionary *)dict
{
    return [[Member alloc] initWithDict:dict];
}

#pragma mark - NSCoding methods
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.phone forKey:kPhoneKey];
    [aCoder encodeObject:self.password forKey:kPasswordKey];
    [aCoder encodeObject:self.type forKey:kTypeKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.phone = [aDecoder decodeObjectForKey:kPhoneKey];
        self.password = [aDecoder decodeObjectForKey:kPasswordKey];
        self.type = [aDecoder decodeObjectForKey:kTypeKey];
    }
    return self;
}

@end
