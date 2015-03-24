//
//  Order.h
//  SJFood
//
//  Created by 叶帆 on 15/3/24.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

/*
 {
 "message": "获取订单成功",
 "status": "success",
 "orderList": [
    {
        "status": 2,
        "togetherId": 1234,
        "togetherDate": "2015-03-23"
        "smallOrders": [
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
            },
            {
                "price": 1.5,
                "orderCount": 2,
                "isRemarked": 0,
                "imageUrl": "http://tp.cdn.di5.net:8880/uploadfile/2014/1210/20141210103440911.jpg",
                "name": "双汇王中王火腿肠55g*40根",
                "orderId": 1426600702219,
                "discountPrice": 1.2,
                "togetherDate": "2015-03-23",
                "isDiscount": 1,
                "status": 2
            },

        ],
    },
    {
        "togetherDate": "2015-03-23",
        "togetherId": 123456,
        "status": 2
        "smallOrders": [
            {
                "orderId": 1426617669760,
                "isDiscount": 0,
                "name": "收尾火腿 加数据加的累死了",
                "imageUrl": "http://tp.cdn.di5.net:8880/uploadfile/2014/1210/20141210103440911.jpg",
                "togetherDate": "2015-03-23",
                "price": 100,
                "status": 2,
                "orderCount": 1,
                "isRemarked": 0
            },
 
        ],
    }
    ]
 }
 */

#import <Foundation/Foundation.h>

@interface Order : NSObject

@property (nonatomic, copy)NSString *status;//订单状态
@property (nonatomic, copy)NSString *togetherId;//订单的id
@property (nonatomic, copy)NSString *togetherDate;//订单下单时间
@property (nonatomic, strong)NSMutableArray *smallOrders;//订单中商品的详情

- (id)initWithDict:(NSDictionary *)dict;
+ (instancetype)orderWithDict:(NSDictionary *)dict;

@end
