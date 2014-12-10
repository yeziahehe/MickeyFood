//
//  MineInfo.h
//  SJFood
//
//  Created by 叶帆 on 14/12/8.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

/*
 {
     "message": "获取数据成功",
     "waitDeliveryOrder": 3,
     "status": "success",
     "waitReceiveOrder": 2,
     "waitRefundOrder": 2,
     "userInfo": {
         "phone": "18762885079",
         "password": "12345678",
         "type": 2,

         "nickname": "叶帆",
         "imgUrl": "http://tupian.qqjay.com/u/2011/0729/e755c434c91fed9f6f73152731788cb3.jpg"
         "lastLoginDate": 1418140800000
     },
     "waitCommentOrder": 4
 }
*/

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface MineInfo : NSObject

@property (nonatomic, copy) UserInfo *userInfo;

@property (nonatomic, copy) NSString *waitDeliveryOrder;
@property (nonatomic, copy) NSString *waitReceiveOrder;
@property (nonatomic, copy) NSString *waitRefundOrder;
@property (nonatomic, copy) NSString *waitCommentOrder;

- (id)initWithDict:(NSDictionary *)dict;
+ (instancetype)mineInfoWithDict:(NSDictionary *)dict;

@end
