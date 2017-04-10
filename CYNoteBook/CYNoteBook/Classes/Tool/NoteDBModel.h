//
//  NoteDBModel.h
//  TestNoteBook
//
//  Created by Cyrill on 2017/3/31.
//  Copyright © 2017年 Cyrill. All rights reserved.
//

#import "CYDBModel.h"

@interface NoteDBModel : CYDBModel

@property (nonatomic, copy) NSString *noteTitle; // 日记标题
@property (nonatomic, copy) NSString *noteText; // 日记内容
@property (nonatomic, copy) NSString *noteCreatedTime; // 日记创建时间

@property (nonatomic, copy) NSString *noteLocation;

@property (nonatomic, assign) NSInteger noteId;

@property (nonatomic, strong) NSData *images;
@property (nonatomic, strong) NSData *videos;

@end
