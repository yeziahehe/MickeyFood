//
//  OrderList.h
//  SJFood
//
//  Created by 叶帆 on 15/3/30.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

/*
 {
 "foodName": "泡面搭档",
 "status": 1,
 "specialName": "原味",
 "price": 3,
 "discountPrice": 2.5,
 "isDiscount": 1,
 "orderCount": 6
 }
 */

#import <Foundation/Foundation.h>

@interface OrderList : NSObject

@property(nonatomic, copy) NSString *foodName;//食品名称
@property(nonatomic, copy) NSString *specialName;//食品口味
@property(nonatomic, copy) NSString *orderCount;//食品数量
@property(nonatomic, copy) NSString *isDiscount;//是否打折
@property(nonatomic, copy) NSString *price;//价格
@property(nonatomic, copy) NSString *discountPrice;//折扣价格

- (id)initWithDict:(NSDictionary *)dict;

@end
