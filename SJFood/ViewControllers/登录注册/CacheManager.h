//
//  CacheManager.h
//  SJFood
//
//  Created by 叶帆 on 14/12/16.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCategoryCacheKey               @"CategoryCacheKey"

/**
 * 该类用于管理本地缓存
 */
@interface CacheManager : NSObject

@property (nonatomic, copy) NSString *cachePhone;
@property (nonatomic, strong) NSMutableDictionary *cacheDict;

+ (instancetype)sharedManager;

/**
 * 缓存分类信息
 * @param array 服务端返回的数据
 */
- (void)cacheCategoryWithArray:(NSMutableArray *)array;
/**
 * 获取缓存的分类信息
 * @return 分类model
 */
- (NSMutableArray *)category;

@end
