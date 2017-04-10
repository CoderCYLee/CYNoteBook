//
//  AllUtils.m
//  TestNoteBook
//
//  Created by Cyrill on 2017/3/31.
//  Copyright © 2017年 Cyrill. All rights reserved.
//

#import "AllUtils.h"

@implementation AllUtils

#pragma mark - 获取日期
+ (NSString *)getDateFromString:(NSString *)date{
    
    NSString * str = date;
    NSMutableString * reverseString = [NSMutableString string];
    for(int i = 0 ; i < str.length; i ++){
        
        //倒序读取字符并且存到可变数组数组中
        unichar c = [str characterAtIndex:str.length- i -1];
        [reverseString appendFormat:@"%c",c];
    }
    str = reverseString;
    //  NSLog(@"%@",str);//date已经逆转；
    NSString *b = [str substringFromIndex:8];//截取后8位；
    NSString * str2 = b;
    NSMutableString * reverseString2 = [NSMutableString string];
    for(int i = 0 ; i < str2.length; i ++){
        
        //倒序读取字符并且存到可变数组数组中
        unichar c = [str2 characterAtIndex:str2.length- i -1];
        [reverseString2 appendFormat:@"%c",c];
    }
    str2 = reverseString2;
    //  NSLog(@"%@",str2);//date转换完毕
    return str2;
}

+ (NSString *)getDate {
    NSDate *datenow = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeStr = [formatter stringFromDate:datenow];
    return timeStr;
}

#pragma mark - 弹出提示对话框
+ (UIAlertController *)showPromptDialog:(NSString *)title andMessage:(NSString *)message OKButton:(NSString *)OKButtonTitle OKButtonAction:(void (^)(UIAlertAction *action))OKButtonHandler cancelButton:(NSString *)cancelButtonTitle cancelButtonAction:(void (^)(UIAlertAction *action))cancelButtonHandler contextViewController:(UIViewController *)contextViewController{
    
    //尝试使用新的弹出对话框；
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:OKButtonTitle style:UIAlertActionStyleDefault handler:OKButtonHandler]];
    
    if ([cancelButtonTitle isEqualToString:@""]) {
        
        //表示不需要“取消”按钮；
    }else{
        
        //需要“取消”按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleDefault handler:cancelButtonHandler]];
    }
    //弹出提示框；
    [contextViewController presentViewController:alertController animated:true completion:nil];
    return alertController;
}


@end
