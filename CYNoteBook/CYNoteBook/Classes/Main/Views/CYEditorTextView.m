//
//  CYEditorTextView.m
//  TestNoteBook
//
//  Created by Cyrill on 2017/4/6.
//  Copyright © 2017年 Cyrill. All rights reserved.
//

#import "CYEditorTextView.h"
#import "CYEditorTextAttachmentOverlayView.h"

@interface CYEditorTextView ()

@property (nonatomic, strong) NSMutableArray *pathArray;

@end

@implementation CYEditorTextView

- (void)setImagesArray:(NSMutableArray *)imagesArray {
    _imagesArray = imagesArray;
    
//    CGFloat finHeight = [self caculateFinalHeight:nil];
    
//    CGFloat margin = _imagesArray.count <= 1 ? 0 : 170 ;
//    CGFloat margin = 150;
    
//    self.textContainer.exclusionPaths = @[path];
    

    if (_isAdded) {
        return;
    }
    
    [_imagesArray enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL * _Nonnull stop) {
    
//        CGRect rect =  CGRectMake(0, finHeight, self.bounds.size.width, margin);
//        UIBezierPath * path = [UIBezierPath bezierPathWithRect:rect];
//        [self.pathArray addObject:path];
        
        @autoreleasepool {
            CYEditorTextAttachmentOverlayView *overlayView = [[CYEditorTextAttachmentOverlayView alloc] initWithFrame:CGRectMake([self caretRectForPosition:self.selectedTextRange.start].origin.x+8, [self caretRectForPosition:self.selectedTextRange.start].origin.y, 222, 150)];
            overlayView.imageView.image = image;
            [self addSubview:overlayView];
            
            [self updateExclusionPaths:overlayView];
        }
    }];
    
//    self.textContainer.exclusionPaths = self.pathArray;
    
    NSLog(@"%f, %f", [self caretRectForPosition:self.selectedTextRange.start].origin.x, [self caretRectForPosition:self.selectedTextRange.start].origin.y);
    
}

- (void)setPathArr:(NSArray *)pathArr {
    _pathArr = pathArr;
    
    self.textContainer.exclusionPaths = pathArr;
    
    [self.imagesArray enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL * _Nonnull stop) {
        
        @autoreleasepool {
            
            UIBezierPath *path = pathArr[idx];
            
            CGRect ovalFrame = [self convertRect:path.bounds fromView:self];
            
            CYEditorTextAttachmentOverlayView *overlayView = [[CYEditorTextAttachmentOverlayView alloc] initWithFrame:ovalFrame];
            overlayView.imageView.image = image;
            [self addSubview:overlayView];
            
        }
    }];
}

- (CGFloat)caculateHeightWithText:(NSString *)string {
    
    CGFloat width = self.bounds.size.width;
    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self.text];
    self.attributedText = attrStr;
//    NSRange range = NSMakeRange(0, attrStr.length);
//    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
    
    
    return [self heightWithString:self.text Font:self.font withLabelWidth:width];
}

- (CGFloat)heightWithString:(NSString *)string Font:(UIFont *)font withLabelWidth:(CGFloat)width {
    
    CGFloat height = 0;
    
    if (string.length == 0) {
        
        height = 0;
        
    } else {
        
        // 字体
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:18.f]};
        if (font) {
            
            attribute = @{NSFontAttributeName: font};
        }
        
        // 尺寸
        CGSize retSize = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                            options:NSStringDrawingUsesFontLeading|
                          NSStringDrawingUsesLineFragmentOrigin
                                         attributes:attribute
                                            context:nil].size;
        
        height = retSize.height;
    }
    
    NSLog(@"%f", height);
    
    return height;
}


- (CGFloat)caculateFinalHeight:(NSMutableArray *)array {
    
    CGFloat textHeight = [self caculateHeightWithText:self.text];
    textHeight += 150 * self.pathArray.count;
    
    return textHeight;
}

- (NSMutableArray *)pathArray
{
    if (!_pathArray) {
        _pathArray = [[NSMutableArray alloc] init];
    }
    return _pathArray;
}

- (void)updateExclusionPaths:(UIView *)iv
{
    CGRect ovalFrame = [self convertRect:iv.bounds fromView:iv];
    
    // Since text container does not know about the inset, we must shift the frame to container coordinates
    ovalFrame.origin.x -= self.textContainerInset.left;
    ovalFrame.origin.y -= self.textContainerInset.top;
    
    // Simply set the exclusion path
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithRect: ovalFrame];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.textContainer.exclusionPaths];
    [arr addObject:ovalPath];
    self.textContainer.exclusionPaths = arr;
}

- (void)ddd {
    CGFloat cursorPosition;
    if (self.selectedTextRange) {
        cursorPosition = [self caretRectForPosition:self.selectedTextRange.start].origin.y;
    } else {
        cursorPosition = 0;
    }
    
}

/*
CGFloat cursorPosition;
if (textView.selectedTextRange) {
    cursorPosition = [textView caretRectForPosition:textView.selectedTextRange.start].origin.y;
} else {
    cursorPosition = 0;
}
CGRect cursorRowFrame = CGRectMake(0, cursorPosition, kScreenWidth, kMinTextViewHeight);
CGRect textViewFrame = [self.tableView convertRect:cursorRowFrame fromView:textView];

[self.tableView scrollRectToVisible:textViewFrame animated:YES];
*/

- (void)updateClippy:(UIView *)iv
{
    // Zero length selection hide clippy
    NSRange selectedRange = self.selectedRange;
    
    
    // Find last rect of selection
    NSRange glyphRange = [self.layoutManager glyphRangeForCharacterRange:selectedRange actualCharacterRange:NULL];
    __block CGRect lastRect;
    [self.layoutManager enumerateEnclosingRectsForGlyphRange:glyphRange withinSelectedGlyphRange:glyphRange inTextContainer:self.textContainer usingBlock:^(CGRect rect, BOOL *stop) {
        lastRect = rect;
    }];
    
    
    // Position clippy at bottom-right of selection
    CGPoint clippyCenter;
    clippyCenter.x = CGRectGetMaxX(lastRect) + self.textContainerInset.left;
    clippyCenter.y = CGRectGetMaxY(lastRect) + self.textContainerInset.top;
    
    clippyCenter = [self convertPoint:clippyCenter toView:self.superview];
    clippyCenter.x += iv.bounds.size.width / 2;
    clippyCenter.y += iv.bounds.size.height / 2;
    
    iv.hidden = NO;
    iv.center = clippyCenter;
}

@end
