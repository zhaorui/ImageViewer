//
//  ThumbnailView.m
//  ImageViewer
//
//  Created by 赵睿 on 2/5/17.
//  Copyright © 2017年 赵睿. All rights reserved.
//

#import "ThumbnailView.h"

@implementation ThumbnailView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    if (self.selected) {
        [[NSColor selectedControlColor] set];
        NSRectFill(dirtyRect);
    }
}

-(void)setSelected:(BOOL)selected {
    if (_selected == selected) {
        return;
    }
    
    selected = _selected;
    [self setNeedsDisplay:YES];
}

-(void)mouseEntered:(NSEvent *)event {
    
}

-(void)mouseExited:(NSEvent *)event {
    
}


@end
