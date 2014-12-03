//
//  Member.h
//  SJFood
//
//  Created by 叶帆 on 14/12/3.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Member : NSObject<NSCoding>

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *password;

- (id)initWithDict:(NSDictionary *)dict;
+ (instancetype)memberWithDict:(NSDictionary *)dict;

@end
