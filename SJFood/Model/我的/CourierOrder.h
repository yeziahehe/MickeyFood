//
//  CourierOrder.h
//  SJFood
//
//  Created by 叶帆 on 15/3/30.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

/*
 {
 "totalPrice": 3.6,
 "status": 1,
 "nickName": "张梦杰",
 "togetherDate": "2015-03-30",
 "orderList": [
    {
        "specialName": "玉米味",
        "discountPrice": 1.1,
        "isDiscount": 1,
        "foodName": "双汇火腿肠",
        "price": 1.1,
        "orderCount": 6,
        "status": 1
    },
    {
        "foodName": "泡面搭档",
        "status": 1,
        "specialName": "原味",
        "price": 3,
        "discountPrice": 2.5,
        "isDiscount": 1,
        "orderCount": 6
    }
 ],
 "customePhone": "15151883572",
 "togetherId": "142769182061015151883572",
 "address": "三江学院铁心桥主校区3-153"
 }
 */

#import <Foundation/Foundation.h>

@interface CourierOrder : NSObject

@property (nonatomic, copy)NSString *togetherId;//订单号
@property (nonatomic, copy)NSString *togetherDate;//下单日期
@property (nonatomic, copy)NSString *status;//订单状态
@property (nonatomic, copy)NSString *address;//送货地址
@property (nonatomic, copy)NSString *customePhone;//收货人手机号
@property (nonatomic, copy)NSString *totalPrice;//总价
@property (nonatomic, copy)NSString *nickName;//收货人姓名
@property (nonatomic, copy)NSString *message;//备注
@property (nonatomic, copy)NSString *reserveTime;//送达时间
@property (nonatomic, strong)NSMutableArray *orderList;//订单中商品的详情

- (id)initWithDict:(NSDictionary *)dict;

@end
