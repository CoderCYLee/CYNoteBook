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
    
    CGFloat finHeight = [self caculateFinalHeight:nil];
    
//    CGFloat margin = _imagesArray.count <= 1 ? 0 : 170 ;
    CGFloat margin = 150;
    
//    self.textContainer.exclusionPaths = @[path];
    
    [_imagesArray enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL * _Nonnull stop) {
    
        CGRect rect =  CGRectMake(0, finHeight, self.bounds.size.width, margin);
        UIBezierPath * path = [UIBezierPath bezierPathWithRect:rect];
        [self.pathArray addObject:path];
        
        CYEditorTextAttachmentOverlayView *overlayView = [[CYEditorTextAttachmentOverlayView alloc] initWithFrame:CGRectMake(8, finHeight, 222, 150)];
        overlayView.imageView.image = image;
        [self addSubview:overlayView];
        
    }];
    
    self.textContainer.exclusionPaths = self.pathArray;
    
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

@end
