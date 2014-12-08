//
//  UserInfo.h
//  SJFood
//
//  Created by 叶帆 on 14/12/8.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

/*
{
    "phone": "18762885079",
    "password": "12345678",
    "type": 2,
    "address1": "苏州大学本部女生大院",
    "address2": "苏州大学东区五号楼",
    "address3": null,
    "address4": null,
    "nickname": "叶帆",
    "imgUrl": "http://tupian.qqjay.com/u/2011/0729/e755c434c91fed9f6f73152731788cb3.jpg"
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
@property (nonatomic, copy) NSString *address1;
@property (nonatomic, copy) NSString *address2;
@property (nonatomic, copy) NSString *address3;
@property (nonatomic, copy) NSString *address4;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) RoleType roleType;

- (id)initWithDict:(NSDictionary *)dict;

@end
