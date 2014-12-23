//
//  FoodSpec.h
//  SJFood
//
//  Created by 叶帆 on 14/12/23.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodSpec : NSObject

@property (nonatomic, copy)NSString *specialId;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *foodCount;

- (id)initWithDict:(NSDictionary *)dict;

@end
