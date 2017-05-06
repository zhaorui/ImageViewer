//
//  NavigateView.m
//  ImageViewer
//
//  Created by 赵睿 on 06/05/2017.
//  Copyright © 2017 赵睿. All rights reserved.
//

#import "NavigateView.h"

@interface NavigateView ()

@property (nonatomic,getter=isMouseInside) BOOL mouseInside;

@end

@implementation NavigateView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

-(void)mouseEntered:(NSEvent *)event {
    self.subviews.firstObject.hidden = NO;
}

-(void)mouseExited:(NSEvent *)event {
    self.subviews.firstObject.hidden = YES;
}


@end
