//
//  ImageViewer.m
//  ImageViewer
//
//  Created by 赵睿 on 30/04/2017.
//  Copyright © 2017 赵睿. All rights reserved.
//

#import "ImageViewer.h"

@implementation ImageViewer

-(void)doCommandBySelector:(SEL)selector {
    NSLog(@"ImageViewer call selector %@", NSStringFromSelector(selector));
    [super doCommandBySelector:selector];
}

//-(void)keyDown:(NSEvent *)event {
//    [self interpretKeyEvents:[NSArray arrayWithObjects:event, nil]];
//}

-(void)cancelOperation:(id)sender{
    NSLog(@"cancel from ImageViewer by %@", sender);
    [self close];
}


@end
