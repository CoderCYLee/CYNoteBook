//
//  NoteUtils.m
//  TestNoteBook
//
//  Created by Cyrill on 2017/3/31.
//  Copyright © 2017年 Cyrill. All rights reserved.
//

#import "NoteUtils.h"
#import "NoteDBModel.h"

@implementation NoteUtils

//插入一条笔记到Note表，包括，userId(用户ID),username(用户名)，noteTitle（笔记标题），noteText（笔记内容）;4个字段；
+ (void)addNoteWithNoteTitle:(NSString *)noteTitle noteText:(NSString *)noteText time:(NSString *)time noteLocation:(NSString *)noteLocation todo:(void(^)(BOOL isSuccessful, NSError *error))todo {
    
    NoteDBModel *noteModel = [[NoteDBModel alloc] init];
    noteModel.noteTitle = noteTitle;
    noteModel.noteText = noteText;
    noteModel.noteCreatedTime = time;
    noteModel.noteLocation = noteLocation;
    NSError *error;
    todo([noteModel save], error);
}

+ (void)addNoteWithNoteModel:(NoteDBModel *)noteModel todo:(void(^)(BOOL isSuccessful, NSError *error))todo {
    
    NSError *error;
    todo([noteModel save], error);
}

#pragma mark - 往数据库中删除一条笔记
+ (BOOL)deleteNoteModel:(NoteDBModel *)noteModel {
    
    return [noteModel deleteObject];
}

+ (void)updateNoteWithNoteModel:(NoteDBModel *)noteModel noteTitle:(NSString *)noteTitle noteText:(NSString *)noteText time:(NSString *)time todo:(void(^)(BOOL isSuccessful, NSError *error))todo {
    
    noteModel.noteTitle = noteTitle;
    noteModel.noteText = noteText;
    noteModel.noteCreatedTime = time;
    NSError *error;
    todo([noteModel update], error);
}

+ (NoteDBModel *)findNoteWithNoteId:(NSInteger)noteId {
    int pk = (int)noteId;
    NoteDBModel *noteModel = [NoteDBModel findByPK:pk];
    return noteModel;
}

+ (NSArray *)findAll {
    return [NoteDBModel findAll];
}

@end
