//
//  ImageView.m
//  ImageViewer
//
//  Created by 赵睿 on 3/5/17.
//  Copyright © 2017年 赵睿. All rights reserved.
//

#import "ImageView.h"


@interface ImageView ()

@property (nonatomic) NSPoint lastPoint;


@end

@implementation ImageView


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
}

-(void)mouseDown:(NSEvent *)event {
    self.lastPoint = [self convertPoint:[event locationInWindow] fromView:nil];
}

-(void)mouseDragged:(NSEvent *)event {
    NSPoint cur_loc = [self convertPoint:[event locationInWindow] fromView:nil];
    CGFloat dx = cur_loc.x - self.lastPoint.x;
    CGFloat dy = cur_loc.y - self.lastPoint.y;
    self.frame = NSMakeRect(self.frame.origin.x+dx, self.frame.origin.y + dy, self.frame.size.width,self.frame.size.height);
}

-(void)setAnchorPoint:(CGPoint)anchorPoint {
    self.layer.anchorPoint = anchorPoint;

    
}

-(void)viewDidMoveToWindow {
    self.angle = 0;
    self.scale = 1.0;
}


@end
