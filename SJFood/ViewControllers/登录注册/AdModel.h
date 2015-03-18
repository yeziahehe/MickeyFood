//
//  AdModel.h
//  SJFood
//
//  Created by 叶帆 on 15/3/18.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdModel : NSObject

@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *newsId;

- (id)initWithDict:(NSDictionary *)dict;

@end
