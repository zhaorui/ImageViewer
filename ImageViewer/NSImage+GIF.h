//
//  NSImage+GIF.h
//  ImageViewer
//
//  Created by 赵睿 on 19/05/2017.
//  Copyright © 2017 赵睿. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (GIF)
- (BOOL)isGifImage;
- (BOOL)saveAnimatedGIFToFile:(NSString*)filepath;
@end
