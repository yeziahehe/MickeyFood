//
//  OrderDetails.h
//  SJFood
//
//  Created by 叶帆 on 15/3/24.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

/*
 {
    "togetherDate": "2015-03-23",
    "name": "收尾火腿 加数据加的累死了",
    "isRemarked": 0,
    "imageUrl": "http://tp.cdn.di5.net:8880/uploadfile/2014/1210/20141210103440911.jpg",
    "orderCount": 1,
    "status": 2,
    "isDiscount": 0,
    "orderId": 1426617669760,
    "price": 100
 }
 */

#import <Foundation/Foundation.h>

@interface OrderDetails : NSObject

@property (nonatomic, copy)NSString *name;//商品名称
@property (nonatomic, copy)NSString *imageUrl;//商品图片
@property (nonatomic, copy)NSString *orderCount;//购买数量
@property (nonatomic, copy)NSString *status;//商品的状态
@property (nonatomic, copy)NSString *isDiscount;//是否折扣
@property (nonatomic, copy)NSString *price;//价钱
@property (nonatomic, copy)NSString *discountPrice;//打折价格
@property (nonatomic, copy)NSString *orderId;//订单的id
@property (nonatomic, copy)NSString *isRemarked;//是否评价完成

- (id)initWithDict:(NSDictionary *)dict;

@end
