//
//  FoodCategoryDetail.h
//  SJFood
//
//  Created by 叶帆 on 14/12/14.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodCategoryDetail : NSObject

@property (nonatomic, strong) NSString *categoryId;//三级页面的id
@property (nonatomic, strong) NSString *category;//二级页面的名称
@property (nonatomic, strong) NSString *imgUrl;//二级页面的图片

- (id)initWithDict:(NSDictionary *)dict;

@end
