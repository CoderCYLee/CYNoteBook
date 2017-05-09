//
//  CYEditorTextView.h
//  TestNoteBook
//
//  Created by Cyrill on 2017/4/6.
//  Copyright © 2017年 Cyrill. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYEditorTextView : UITextView

@property (nonatomic, strong) NSMutableArray *imagesArray;

@property (nonatomic, strong) NSArray *pathArr;

@property (nonatomic, assign) BOOL isAdded;

@end
