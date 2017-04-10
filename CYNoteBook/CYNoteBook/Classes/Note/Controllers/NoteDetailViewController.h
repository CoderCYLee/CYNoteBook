//
//  NoteDetailViewController.h
//  TestNoteBook
//
//  Created by Cyrill on 2017/3/31.
//  Copyright © 2017年 Cyrill. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NoteDBModel;

@interface NoteDetailViewController : UIViewController

@property (nonatomic, strong) NoteDBModel *model;

@end
