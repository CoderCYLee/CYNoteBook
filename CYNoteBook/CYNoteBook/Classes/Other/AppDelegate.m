//
//  AppDelegate.m
//  TestNoteBook
//
//  Created by Cyrill on 2017/3/31.
//  Copyright © 2017年 Cyrill. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "LockView.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface AppDelegate ()

@property (nonatomic, strong) LockView *lockView;
@property (nonatomic, strong) UIVisualEffectView *coverView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSLog(@"\n ===> 程序开始 !");
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    
    MainViewController *mainVC = [[MainViewController alloc] init];
    self.window.rootViewController = mainVC;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
    NSLog(@"\n ===> 程序暂行 !");
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"\n ===> 程序进入后台 !");
    
    [self.window addSubview:self.lockView];
    [self.window addSubview:self.coverView];
    
    
    
    
}

- (void)touchID {
    LAContext *_context = [[LAContext alloc] init];
    NSError *error;
    //Whether the device support touch ID? ---if it's yes,support!Otherwise,the system version is lower than iOS8.
    if([_context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        
        NSLog(@"Yeah,Support touch ID");
        
        //if return yes,whether your fingerprint correct.
        [_context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请输入指纹进入" reply:^(BOOL success, NSError * _Nullable error) {
            if (success)
            {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        self.lockView.alpha = 0;
                        self.lockView.transform = CGAffineTransformMakeScale(1.5, 1.5);
                        
                    } completion:^(BOOL finished) {
                        [self.lockView removeFromSuperview];
                    }];
                });
                
            }
            else
            {
                
                NSLog(@"fail");
            }
        }];
    }
    else
    {
        
        
        NSLog(@"Sorry,The device doesn't support touch ID");
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"\n ===> 程序进入前台 !");
    
    [self.coverView removeFromSuperview];
    self.coverView = nil;
    
    [self touchID];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"\n ===> 程序重新激活 !");
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"\n ===> 程序意外暂行 !");
    
}

- (LockView *)lockView
{
    if (!_lockView) {
        _lockView = [[[NSBundle mainBundle] loadNibNamed:@"LockView" owner:self options:nil] firstObject];
        _lockView.frame = self.window.bounds;
        
//        _lockView = [[LockView alloc] initWithFrame:self.window.bounds];
//        _lockView.backgroundColor = [UIColor redColor];
        [_lockView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(go)]];
    }
    return _lockView;
}

- (UIVisualEffectView *)coverView
{
    if (!_coverView) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _coverView = [[UIVisualEffectView alloc] initWithFrame:self.window.bounds];
        _coverView.effect = blur;
    }
    return _coverView;
}


- (void)go {
    [self.lockView removeFromSuperview];
    self.lockView = nil;
}


@end
