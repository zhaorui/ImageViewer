//
//  ThumbnailView.m
//  ImageViewer
//
//  Created by 赵睿 on 2/5/17.
//  Copyright © 2017年 赵睿. All rights reserved.
//

#import "ThumbnailView.h"

@implementation ThumbnailView

-(void)setSelected:(BOOL)selected {
    _selected = selected;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    if (self.selected) {
        [[NSColor selectedControlColor] set];
        NSRectFill(dirtyRect);
    }
}



@end
