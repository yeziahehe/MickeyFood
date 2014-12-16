//
//  CacheManager.m
//  SJFood
//
//  Created by 叶帆 on 14/12/16.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "CacheManager.h"
#import "FoodCategory.h"
#import "FoodCategoryDetail.h"

@implementation CacheManager
@synthesize cacheDict,cachePhone;

#pragma mark - Private Methods
- (NSString *)cacheFilePath
{
    NSString *cacheDirectory = [DOCUMENTS_FOLDER stringByAppendingPathComponent:kUsersCacheDataDir];
    NSFileManager *manager = [NSFileManager defaultManager];
    if(![manager fileExistsAtPath:cacheDirectory])
        [manager createDirectoryAtPath:cacheDirectory withIntermediateDirectories:NO attributes:nil error:nil];
    return [cacheDirectory stringByAppendingPathComponent:self.cachePhone];
}

- (void)cacheUsersData
{
    //保存所有用户信息
    NSData *memberData = [NSKeyedArchiver archivedDataWithRootObject:self.cacheDict];
    NSString *userDataFilePath = [self cacheFilePath];
    [memberData writeToFile:userDataFilePath atomically:NO];
}

#pragma mark - Public Methods
- (void)cacheCategoryWithArray:(NSMutableArray *)array
{
    NSMutableArray *foodCategoryArray = [NSMutableArray array];
    for (FoodCategory *foodCategory in array) {
        NSDictionary *dict = [foodCategory toCacheDictionary];
        [foodCategoryArray addObject:dict];
    }
    [self.cacheDict setObject:foodCategoryArray forKey:kCategoryCacheKey];
    [self cacheUsersData];
}

- (NSMutableArray *)category
{
    NSMutableArray *categoryArray = [self.cacheDict objectForKey:kCategoryCacheKey];
    if (categoryArray)
        return categoryArray;
    return nil;
}

#pragma mark - Notification Methods
- (void)userChangeWithNotification:(NSNotification *)notification
{
    if ([MemberDataManager sharedManager].loginMember.phone == nil || [MemberDataManager sharedManager].loginMember.phone.length == 0)
        self.cachePhone = @"default";
    else
        self.cachePhone = [MemberDataManager sharedManager].loginMember.phone;
    //读取本地用户信息
    NSString *userDataFilePath = [self cacheFilePath];
    //读取本地用户信息
    self.cacheDict = [NSKeyedUnarchiver unarchiveObjectWithFile:userDataFilePath];
    if(nil == self.cacheDict)
        self.cacheDict = [NSMutableDictionary dictionary];
}

#pragma mark - Singleton Methods
- (id)init
{
    if(self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userChangeWithNotification:) name:kUserChangeNotification object:nil];
        [self userChangeWithNotification:nil];
    }
    return self;
}

+ (instancetype)sharedManager
{
    static CacheManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CacheManager alloc] init];
    });
    return manager;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
