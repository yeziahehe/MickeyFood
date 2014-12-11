//
//  Address.h
//  SJFood
//
//  Created by 叶帆 on 14/12/11.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

/**
 "rank": "1418132374967",
 "phoneId": "18896554880",
 "phone": "188966554880",
 "name": "xiaowei",
 "address": "hubei",
 "tag": 0
 */

#import <Foundation/Foundation.h>

@interface Address : NSObject

@property (nonatomic, copy) NSString *rank;//唯一标示符
@property (nonatomic, copy) NSString *phone;//收货人手机号码
@property (nonatomic, copy) NSString *name;//收货人姓名
@property (nonatomic, copy) NSString *address;//收货人地址
@property (nonatomic, copy) NSString *tag;//默认地址标识 0-默认 1-非默认

- (id)initWithDict:(NSDictionary *)dict;

@end
