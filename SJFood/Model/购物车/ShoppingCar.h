//
//  ShoppingCar.h
//  SJFood
//
//  Created by 叶帆 on 15/3/8.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

/**
 {
 "message": "获取购物车订单成功",
 "status": "failure",
 "orderList": [
    {
        "orderId": 10010001,
        "name": "双汇王中王火腿肠55g*40根",
        "phone": "18896554880",
        "status": 1,
        "price": 180,
        "discountPrice": 14.400001,
        "isDiscount": 1,
        "orderCount": 12,
        "tag": 1,
        "foodSpecial": 1,
        "foodId": 1001001,
        "imageUrl": "http://tp.cdn.di5.net:8880/uploadfile/2014/1210/20141210103440911.jpg",
        "specialName": "玉米味",
        "foodCount": 200
    },
    {
        "orderId": 10010002,
        "name": "双汇王中王火腿肠55g*40根",
        "phone": "18896554880",
        "status": 1,
        "price": 300,
        "discountPrice": 24,
        "isDiscount": 1,
        "orderCount": 20,
        "tag": 1,
        "foodSpecial": null,
        "foodId": 1001001,
        "imageUrl": "http://tp.cdn.di5.net:8880/uploadfile/2014/1210/20141210103440911.jpg",
        "specialName": null
        "foodCount": 200
    }
 ]
 }
 */

#import <Foundation/Foundation.h>

@interface ShoppingCar : NSObject

@property (nonatomic, copy) NSString *orderId;//购物车每条记录的id
@property (nonatomic, copy) NSString *name;//商品名称
@property (nonatomic, copy) NSString *price;//商品价格
@property (nonatomic, copy) NSString *discountPrice;//折扣价格
@property (nonatomic, copy) NSString *isDiscount;//是否打折
@property (nonatomic, strong) NSString *orderCount;//商品数量(允许修改)
@property (nonatomic, copy) NSString *specialName;//规格
@property (nonatomic, copy) NSString *imageUrl;//商品照片
@property (nonatomic, copy) NSString *foodCount;//商品余量

- (id)initWithDict:(NSDictionary *)dict;
+ (instancetype)shoppingCarWithDict:(NSDictionary *)dict;

@end
