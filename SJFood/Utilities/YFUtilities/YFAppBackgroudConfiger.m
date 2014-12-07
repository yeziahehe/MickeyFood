//
//  YFAppBackgroudConfiger.m
//  SJFood
//
//  Created by 叶帆 on 14/12/7.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "YFAppBackgroudConfiger.h"

@implementation YFAppBackgroudConfiger

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

+ (void)preventFilesFromBeingBackedupToiCloudWithSystemVersion:(NSString *)currSysVer
{
    NSString *reqSysVer = @"5.1";
    if ([currSysVer compare:reqSysVer options:NSNumericSearch] == NSOrderedAscending)
        return;
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *fileList = [manager subpathsOfDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] error:nil];
    //    for (NSString *s in fileList){
    //        NSLog(@"document folder files:%@",s);
    //    }
    
    for(NSString *path in fileList)
    {
        NSURL *fileUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"],path]];
        [self addSkipBackupAttributeToItemAtURL:fileUrl];
    }
}

+ (double)calculateCacheSizeWithCacheDirs:(NSArray *)dirs
{
    double totalSize = 0;
    
    NSFileManager*  fileManager = [NSFileManager defaultManager];
    for(NSString *cacheDir in dirs)
    {
        NSDirectoryEnumerator* e = [fileManager enumeratorAtPath:[self imagesCacheDirectoryWithName:cacheDir]];
        
        NSString *file;
        
        while ((file = [e nextObject]))
        {
            
            NSDictionary *attributes = [e fileAttributes];
            
            NSNumber *fileSize = [attributes objectForKey:NSFileSize];
            
            totalSize += [fileSize longLongValue];
        }
    }
    NSLog(@"whole cache size: %f",totalSize);
    return totalSize;
}

+ (BOOL)clearCachedWithCacheDirs:(NSArray *)dirs
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSError *err = nil;
    
    for(NSString *dir in dirs)
    {
        if([manager fileExistsAtPath:[self imagesCacheDirectoryWithName:dir]])
            [manager removeItemAtPath:[self imagesCacheDirectoryWithName:dir] error:&err];
    }
    if(err == nil)
        return YES;
    return NO;
}

+ (NSString *)imagesCacheDirectoryWithName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths lastObject];
    return [documentDirectory stringByAppendingPathComponent:name];
}

+ (void)clearAllCachesWhenBiggerThanSize:(double)size
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *fileList = [manager subpathsOfDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] error:nil];
    //    for (NSString *s in fileList){
    //        NSLog(@"document folder files:%@",s);
    //    }
    
    double totalSize = 0;
    
    for(NSString *path in fileList)
    {
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"],path];
        
        if([manager fileExistsAtPath:filePath])
        {
            NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
            unsigned long long length = [fileAttributes fileSize];
            totalSize += length;
        }
    }
    if(totalSize > size)
    {
        for(NSString *path in fileList)
        {
            NSString *filePath = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"],path];
            if([manager fileExistsAtPath:filePath])
            {
                [manager removeItemAtPath:filePath error:nil];
            }
        }
    }
}

@end
