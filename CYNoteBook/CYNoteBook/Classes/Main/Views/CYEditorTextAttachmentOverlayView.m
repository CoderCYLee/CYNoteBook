//
//  CYEditorTextAttachmentOverlayView.m
//  TestNoteBook
//
//  Created by Cyrill on 2017/4/6.
//  Copyright © 2017年 Cyrill. All rights reserved.
//

#import "CYEditorTextAttachmentOverlayView.h"

@implementation CYEditorTextAttachmentOverlayView



- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
    }
    return _imageView;
}

@end
