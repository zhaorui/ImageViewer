//
//  ImageView.h
//  ImageViewer
//
//  Created by 赵睿 on 3/5/17.
//  Copyright © 2017年 赵睿. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ImageView : NSImageView

-(void)setAnchorPoint:(CGPoint)anchorPoint;
@property (nonatomic) CGFloat angle;
@property (nonatomic) CGFloat scale;

@end
