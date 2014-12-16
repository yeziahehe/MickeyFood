//
//  FoodCategory.h
//  SJFood
//
//  Created by 叶帆 on 14/12/14.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

/*
 {
     "categoryId": 1,
     "category": "肉干肉脯",
     "imgUrl": null,
     "parentId": 0,
     "tag": 1,
     "child": [
               {
                   "categoryId": 3,
                   "category": "火腿肠",
                   "imgUrl": null,
                   "parentId": 1,
                   "tag": 1,
                   "child": null
               }
               ]
 },
 {
     "categoryId": 2,
     "category": "坚果炒货",
     "imgUrl": null,
     "parentId": 0,
     "tag": 1,
     "child": null
 }
 */

#import <Foundation/Foundation.h>
#import "FoodCategoryDetail.h"

@interface FoodCategory : NSObject

@property (nonatomic, strong) NSString *category;//一级分类名称
@property (nonatomic, strong) NSMutableArray *child;//二级分类数组

- (id)initWithDict:(NSDictionary *)dict;
+ (instancetype)foodCategoryWithDict:(NSDictionary *)dict;

@end
