//
//  UserInfo.h
//  SJFood
//
//  Created by 叶帆 on 14/12/8.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

/*
     "userInfo": {
     "phone": "18762885079",
     "password": "12345678",
     "type": 2,
     
     "nickname": "叶帆",
     "imgUrl": "http://tupian.qqjay.com/u/2011/0729/e755c434c91fed9f6f73152731788cb3.jpg"
     "lastLoginDate": 1418140800000
 }
*/

#import <Foundation/Foundation.h>

typedef enum {
    kRoleUser = 0,
    kRoleAdmin
}RoleType;

@interface UserInfo : NSObject

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) RoleType roleType;

- (id)initWithDict:(NSDictionary *)dict;

@end
