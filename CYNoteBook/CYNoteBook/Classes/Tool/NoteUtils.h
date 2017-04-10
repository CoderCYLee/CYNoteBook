//
//  NoteUtils.h
//  TestNoteBook
//
//  Created by Cyrill on 2017/3/31.
//  Copyright © 2017年 Cyrill. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NoteDBModel;

@interface NoteUtils : NSObject

// add
+ (void)addNoteWithNoteTitle:(NSString *)noteTitle noteText:(NSString *)noteText time:(NSString *)time noteLocation:(NSString *)noteLocation todo:(void(^)(BOOL isSuccessful, NSError *error))todo;

+ (void)addNoteWithNoteModel:(NoteDBModel *)noteModel todo:(void(^)(BOOL isSuccessful, NSError *error))todo;

// delete
+ (BOOL)deleteNoteModel:(NoteDBModel *)noteModel;

// update
+ (void)updateNoteWithNoteModel:(NoteDBModel *)noteModel noteTitle:(NSString *)noteTitle noteText:(NSString *)noteText time:(NSString *)time todo:(void(^)(BOOL isSuccessful, NSError *error))todo;

// search
+ (NoteDBModel *)findNoteWithNoteId:(NSInteger)noteId;

+ (NSArray *)findAll;

@end
