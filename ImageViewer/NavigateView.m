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


-(instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect] ) {
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

-(void)mouseEntered:(NSEvent *)event {
    [self.delegate mouseEnteredNavigateView];
}

-(void)mouseExited:(NSEvent *)event {
    [self.delegate mouseExitedNavigateView];
}

-(void)awakeFromNib {
    NSInteger ret = [super sendActionOn:NSEventMaskMouseEntered|NSEventMaskMouseExited|NSEventTypeLeftMouseUp];
    NSLog(@"%ld", (long)ret);
}

-(void)viewDidMoveToWindow {
    [super sendActionOn:NSEventMaskMouseEntered|NSEventMaskMouseExited|NSEventTypeLeftMouseUp];
}


@end
