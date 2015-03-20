//
//  FoodComment.h
//  SJFood
//
//  Created by 叶帆 on 15/3/20.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

/*
 {
 "message": "获取评论成功！",
 "status": "success",
 "foodComments": [
    {
        "foodId": 1001001,
        "comment": "火腿真的很好吃诶，赞一个",
        "date": 1419264000000,
        "grade": 5,
        "imgUrl": "http://i2.hdslb.com/u_user/29bfc5f6bfd4fd305a6736a4205b8564.jpg",
        "nickName": "小未",
        "phone": "18896554880",
        "tag": null
    }
    ]
 }
 */

#import <Foundation/Foundation.h>

@interface FoodComment : NSObject
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *imgUrl;

- (id)initWithDict:(NSDictionary *)dict;

@end
