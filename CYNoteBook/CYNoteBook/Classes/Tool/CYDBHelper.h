//
//  CYDBHelper.h
//  YinJi
//
//  Created by 李春阳 on 15/12/31.
//  Copyright © 2015年 FutureStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface CYDBHelper : NSObject

@property (nonatomic, retain, readonly) FMDatabaseQueue *dbQueue;

+ (CYDBHelper *)shareInstance;

+ (NSString *)dbPath;

@end
