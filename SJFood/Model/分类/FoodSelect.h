//
//  FoodSelect.h
//  SJFood
//
//  Created by 叶帆 on 14/12/18.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//
/*
 {
 "message": "获取食品成功",
 "foods": [
     {
        "foodId": 1001003,
        "name": "新式火腿",
        "price": 10,
        "discountPrice": null,
        "grade": 3.7,
        "imgUrl": null,
        "info": null,
        "modifyTime": 1418730688000,
        "status": 1,
        "foodCount": 90,
        "foodFlag": null,
        "tag": 1,
        "isDiscount": 1,
        "categoryId": 1001,
        "primeCost": null,
        "saleNumber": 20
     }
    ]
 }
 */

#import <Foundation/Foundation.h>

@interface FoodSelect : NSObject

@property (nonatomic, copy)NSString *foodId;//食品编号
@property (nonatomic, copy)NSString *name;//食品名称
@property (nonatomic, copy)NSString *price;//价钱
@property (nonatomic, copy)NSString *discountPrice;//折扣价（可空）
@property (nonatomic, copy)NSString *imgUrl;//食品图片
@property (nonatomic, copy)NSString *isDiscount;//是否是折扣价 0-否 1-是
@property (nonatomic, copy)NSString *saleNumber;//销量

- (id)initWithDict:(NSDictionary *)dict;
+ (instancetype)foodSelectWithDict:(NSDictionary *)dict;

@end
