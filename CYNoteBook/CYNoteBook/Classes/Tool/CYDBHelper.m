//
//  CYDBHelper.m
//  YinJi
//
//  Created by 李春阳 on 15/12/31.
//  Copyright © 2015年 FutureStar. All rights reserved.
//

#import "CYDBHelper.h"

@interface CYDBHelper()

@property (nonatomic, retain) FMDatabaseQueue *dbQueue;

@end

@implementation CYDBHelper

static CYDBHelper *_instance = nil;

+ (CYDBHelper *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
    });
    return _instance;
}

+ (NSString *)dbPath
{
    NSString *docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    docsdir = [docsdir stringByAppendingPathComponent:@"CYDB"];
    BOOL isDir;
    BOOL exit = [fileManager fileExistsAtPath:docsdir isDirectory:&isDir];
    if (!exit || !isDir) {
        [fileManager createDirectoryAtPath:docsdir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *dbpath = [docsdir stringByAppendingPathComponent:@"cydb.sqlite"];
    return dbpath;
}

- (FMDatabaseQueue *)dbQueue
{
    if (_dbQueue == nil) {
        _dbQueue = [[FMDatabaseQueue alloc] initWithPath:[self.class dbPath]];
    }
    return _dbQueue;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [CYDBHelper shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone
{
    return [CYDBHelper shareInstance];
}

#if ! __has_feature(objc_arc)
- (oneway void)release
{
    
}

- (id)autorelease
{
    return _instance;
}

- (NSUInteger)retainCount
{
    return 1;
}
#endif

@end
