//
//  ImageViewerWindowController.h
//  ImageViewer
//
//  Created by 赵睿 on 26/4/17.
//  Copyright © 2017年 赵睿. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ImageViewerWindowController : NSWindowController

@property (strong) NSMutableArray *thumbnails;
@property (nonatomic) BOOL collectionsDisplay;

@end
