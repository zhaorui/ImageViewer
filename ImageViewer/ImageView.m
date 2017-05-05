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
    const float angle = [[self.layer valueForKeyPath:@"transform.rotation"] floatValue];
    
    self.lastPoint = [self convertPoint:[event locationInWindow] fromView:nil];
    self.lastPoint = NSMakePoint(self.lastPoint.x * cosf(-angle) - self.lastPoint.y * sinf(-angle),
                                 self.lastPoint.y * cosf(-angle) + self.lastPoint.x * sinf(-angle));

    //self.lastPoint = [self.layer convertPoint:self.lastPoint fromLayer:self.superview.layer];
}

-(void)mouseDragged:(NSEvent *)event {
    const float angle = [[self.layer valueForKeyPath:@"transform.rotation"] floatValue];
    const float scale = [[self.layer valueForKeyPath:@"transform.scale.x"] floatValue];
    
    //cur_loc = [self.layer convertPoint:[event locationInWindow] fromLayer:self.superview.layer];
    
    NSPoint cur_loc = [self convertPoint:[event locationInWindow] fromView:nil];
    cur_loc = NSMakePoint(cur_loc.x * cosf(-angle) - cur_loc.y * sinf(-angle),
                          cur_loc.y * cosf(-angle) + cur_loc.x * sinf(-angle));
    
    CGFloat dx = (cur_loc.x - self.lastPoint.x)/scale;
    CGFloat dy = (cur_loc.y - self.lastPoint.y)/scale;
    self.layer.transform = CATransform3DTranslate(self.layer.transform, dx, dy, 0);
    
    self.lastPoint = cur_loc;
    
    //self.frame = NSMakeRect(self.frame.origin.x+dx, self.frame.origin.y + dy, self.frame.size.width,self.frame.size.height);
}

-(void)setAnchorPoint:(CGPoint)anchorPoint {
    
    if (self.layer.anchorPoint.x == anchorPoint.x &&
        self.layer.anchorPoint.y == anchorPoint.y) {
        return;
    }
    
    CGRect oldFrame = self.layer.frame;
    self.layer.anchorPoint = anchorPoint;
    self.layer.frame = oldFrame;
}

-(void)viewDidMoveToWindow {

}


-(NSView *)hitTest:(NSPoint)point {
    const float angle = [[self.layer valueForKeyPath:@"transform.rotation"] floatValue];
    const float scale_x = [[self.layer valueForKeyPath:@"transform.scale.x"] floatValue];
    
    const float dx = [[self.layer valueForKeyPath:@"transform.translation.x"] floatValue];
    const float dy = [[self.layer valueForKeyPath:@"transform.translation.y"] floatValue];
    
    //revert point to CATranformIdentity status frame
    //1. covert to anchor point coordinate
    NSPoint a_point;
    a_point.x = point.x - dx - self.layer.position.x;
    a_point.y = point.y - dy - self.layer.position.y;
    
    //2. revert rotation
    a_point.x = a_point.x * cosf(-angle) - a_point.y * sinf(-angle);
    a_point.y = a_point.y * cosf(-angle) + a_point.x * sinf(-angle);
    
    //3. revert scale
    a_point.x /= scale_x;
    a_point.y /= scale_x;
    
    //4. revert back to window coordinate
    a_point.x += self.layer.position.x;
    a_point.y += self.layer.position.y;
    
    if (NSPointInRect(a_point, self.frame)) {
        NSLog(@"clicked");
        return self;
    } else {
        return nil;
    }
}

@end
