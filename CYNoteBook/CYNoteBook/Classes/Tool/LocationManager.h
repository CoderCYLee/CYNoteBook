//
//  LocationManager.h
//  TestNoteBook
//
//  Created by Cyrill on 2017/4/2.
//  Copyright © 2017年 Cyrill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationManager : NSObject

// Methods
+ (instancetype)shareInstance;
- (void)findCurrentLocation;
- (void)searchHintResultsWithKeyWord:(NSString *)keyWord;

- (void)startUpdatingLocation;

- (void)stopUpdatingLocation;

// Properties
@property (copy, nonatomic) NSString* address;
@property (strong, nonatomic) NSArray *searchHintResults;

@property (nonatomic, copy) void(^addressBlock)(NSString *address);

@end
