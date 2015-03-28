//
//  SendOrder.h
//  SJFood
//
//  Created by 叶帆 on 15/3/28.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

/*
 {
    "togetherId": "142747062464218896554880",
    "togetherDate": 1427385600000,
    "address": "三江学院铁心桥主校区123",
    "userPhone": null,
    "adminPhone": null,
    "price": 200,
    "discountPrice": null,
    "isDiscount": 0
 },
 */

#import <Foundation/Foundation.h>

@interface SendOrder : NSObject

@property (nonatomic, strong)NSString *togetherId;//订单号
@property (nonatomic, strong)NSString *togetherDate;//订单日期
@property (nonatomic, strong)NSString *address;//地址
@property (nonatomic, strong)NSString *adminName;//快递员名字
@property (nonatomic, strong)NSString *price;//订单总价格
@property (nonatomic, strong)NSString *discountPrice;//订单折扣价
@property (nonatomic, strong)NSString *isDiscount;//订单是否有折扣

- (id)initWithDict:(NSDictionary *)dict;

@end
