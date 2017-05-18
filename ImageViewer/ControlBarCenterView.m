//
//  ControlBarCenterView.m
//  ImageViewer
//
//  Created by 赵睿 on 18/05/2017.
//  Copyright © 2017 赵睿. All rights reserved.
//

#import "ControlBarCenterView.h"

@implementation ControlBarCenterView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
}

- (void)update {
    CGFloat container_width = self.frame.size.width;
    CGFloat btn_width = 48;
    CGFloat tail_btn_width = 100;
    
    // Calculate the total button count, include the last button "原图"
    NSInteger count = 0;
    for (NSButton* btn in self.subviews) {
        if (!btn.isHidden) {
            count++;
        }
    }
    
    CGFloat padding = (container_width - btn_width * (count - 1) - tail_btn_width) / ( count * 2);
    
    NSInteger next_x = padding;
    for (NSButton* btn in self.subviews) {
        if (!btn.isHidden) {
            [btn setFrameOrigin:NSMakePoint(next_x, btn.frame.origin.y)];
            next_x += btn_width + 2*padding;
        }
    }
    
    
}

@end
