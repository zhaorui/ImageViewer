//
//  NavigateView.h
//  ImageViewer
//
//  Created by 赵睿 on 06/05/2017.
//  Copyright © 2017 赵睿. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol NavigateViewDelegate <NSObject>

-(void)mouseEnteredNavigateView;
-(void)mouseExitedNavigateView;

@end

@interface NavigateView : NSControl

@property (nullable,assign) IBOutlet id<NavigateViewDelegate> delegate;

@end
