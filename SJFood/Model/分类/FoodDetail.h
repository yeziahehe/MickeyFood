//
//  FoodDetail.h
//  SJFood
//
//  Created by 叶帆 on 14/12/21.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

/*
{
    "message": "获取食品成功",
    "status": "success",
    "food": {
        "foodId": 1001001,
        "name": "双汇王中王火腿肠55g*40根",
        "price": 15,
        "discountPrice": 1.2,
        "grade": 4,
        "imgUrl": "http://tp.cdn.di5.net:8880/uploadfile/2014/1210/20141210103440911.jpg",
        "info": null,
        "foodCount": 480,
        "modifyTime": 1418540584000,
        "status": 1,
        "foodFlag": "火腿",
        "tag": 1,
        "isDiscount": 0,
        "categoryId": 1001,
        "primeCost": 0.8,
        "saleNumber": 60,
        "foodSpecial": [
                        {
                            "foodId": 1001001,
                            "specialId": 1,
                            "name": "玉米味",
                            "foodCount": 200
                        },
                        {
                            "foodId": 1001001,
                            "specialId": 2,
                            "name": "香蕉味",
                            "foodCount": 180
                        },
                        {
                            "foodId": 1001001,
                            "specialId": 3,
                            "name": "原味",
                            "foodCount": 100
                        }
                        ]
    }
}
 */

#import <Foundation/Foundation.h>
#import "FoodSpec.h"

@interface FoodDetail : NSObject

@property (nonatomic, copy)NSString *foodId;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *price;
@property (nonatomic, copy)NSString *discountPrice;
@property (nonatomic, copy)NSString *grade;
@property (nonatomic, copy)NSString *imgUrl;
@property (nonatomic, copy)NSString *info;//图文详情
@property (nonatomic, copy)NSString *foodCount;
@property (nonatomic, copy)NSString *isDiscount;
@property (nonatomic, copy)NSString *saleNumber;
@property (nonatomic, copy)NSString *commentNumber;
@property (nonatomic, strong)NSMutableArray *foodSpecial;

- (id)initWithDict:(NSDictionary *)dict;
+ (instancetype)foodDetailWithDict:(NSDictionary *)dict;

@end
