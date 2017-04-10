//
//  AppDelegate.h
//  TestNoteBook
//
//  Created by Cyrill on 2017/3/31.
//  Copyright © 2017年 Cyrill. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign, getter=isLock) BOOL lock;

@end

