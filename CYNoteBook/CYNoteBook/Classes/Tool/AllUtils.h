//
//  AllUtils.h
//  TestNoteBook
//
//  Created by Cyrill on 2017/3/31.
//  Copyright © 2017年 Cyrill. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllUtils : NSObject

+ (NSString *)getDateFromString:(NSString *)date;

+ (NSString *)getDate;

+ (UIAlertController *)showPromptDialog:(NSString *)title andMessage:(NSString *)message OKButton:(NSString *)OKButtonTitle OKButtonAction:(void (^)(UIAlertAction *action))OKButtonHandler cancelButton:(NSString *)cancelButtonTitle cancelButtonAction:(void (^)(UIAlertAction *action))cancelButtonHandler contextViewController:(UIViewController*)contextViewController;

@end
