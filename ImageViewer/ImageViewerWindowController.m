//
//  ImageViewerWindowController.m
//  ImageViewer
//
//  Created by 赵睿 on 26/4/17.
//  Copyright © 2017年 赵睿. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ImageViewerWindowController.h"
#import "ImageView.h"
#import "ThumbnailViewController.h"
#import "ThumbnailView.h"
#import "NavigateView.h"
#import "ControlBarCenterView.h"
#import "NSImage+GIF.h"


//MARK: - NSAnimationDelegate
@interface ImageViewerWindowController (Animation) <NSAnimationDelegate>


@end

@implementation ImageViewerWindowController (Animation)

-(void)animationDidEnd:(NSAnimation *)animation {
    //self.collectionsDisplay = !self.collectionsDisplay;
}

@end


@interface ImageViewerWindowController ()

@property (strong) IBOutlet NSArrayController *arrayController;
@property (weak) IBOutlet NSCollectionView *collectionView;
@property (weak) IBOutlet NSScrollView *collectionBorderedView;
@property (weak) IBOutlet ImageView *displayView;
@property (weak) IBOutlet NSBox *controlBar;
@property (weak) IBOutlet NSView *animationView;
@property (weak) IBOutlet NavigateView *prevView;
@property (weak) IBOutlet NavigateView *nextView;
@property (weak) IBOutlet ControlBarCenterView *controlbar_center_view;


@end


static void * ImageViewerWindowControllerContext = "ImageViewerWindowController";

@implementation ImageViewerWindowController

-(NSString *)windowNibName {
    return @"ImageViewerWindowController";
}

- (void)windowDidLoad {
    [super windowDidLoad];
    [NSMenu setMenuBarVisible:NO];
    self.window.styleMask |= NSWindowStyleMaskFullSizeContentView;
    [self.window setFrame:[[NSScreen mainScreen] frame] display:YES];
    [self.window setLevel:NSScreenSaverWindowLevel];
    [self.window makeKeyWindow];
    [self.window setTitleVisibility:NSWindowTitleHidden];
    self.window.titlebarAppearsTransparent = true;
    self.window.movable = false;
    self.window.backgroundColor = [NSColor blackColor];
    

    ThumbnailViewController *thumbnail = [[ThumbnailViewController alloc] initWithNibName:@"ThumbnailViewController"
                                                                                   bundle:nil];
    self.collectionView.itemPrototype = thumbnail;
    
    [self.arrayController addObserver:self forKeyPath:@"selectionIndex"
                              options:NSKeyValueObservingOptionNew
                              context:ImageViewerWindowControllerContext];

    
    [self.arrayController addObjects: self.images.pictures];
    self.collectionView.selectionIndexes = [NSIndexSet indexSetWithIndex:self.images.selected_index];
    self.collectionsDisplay = YES;
    
    self.displayView.layer.transform = CATransform3DIdentity;
    [self.prevView addTrackingRect:self.prevView.bounds owner:self.prevView userData:nil assumeInside:NO];
    [self.nextView addTrackingRect:self.nextView.bounds owner:self.nextView userData:nil assumeInside:NO];
    [self.controlbar_center_view update];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == ImageViewerWindowControllerContext && [keyPath isEqualToString:@"selectionIndex"] && object == self.arrayController) {
        
        NSLog(@"change: %@", change);
        
        if ([self.arrayController.arrangedObjects count] == 0 ) {
            NSLog(@"Sometimes KVO observe that arrayController's array is empty, while we change the selctionIndex");
            return;
        }
        
        
        self.displayView.image = [self.images.pictures[self.arrayController.selectionIndex] objectForKey:@"image"];
        
        
        NSRect displayRect = NSMakeRect(0, 120, self.window.frame.size.width, self.window.frame.size.height-120);
        
        if (self.displayView.image.size.width > displayRect.size.width ||
            self.displayView.image.size.height > displayRect.size.height) {
            CGFloat ratio = MAX(self.displayView.image.size.width / displayRect.size.width,
                                self.displayView.image.size.height / displayRect.size.height);
            
            CGFloat x = NSMidX(displayRect) - self.displayView.image.size.width/ratio/2;
            CGFloat y = NSMidY(displayRect) - self.displayView.image.size.height/ratio/2;
            
            self.displayView.frame = NSMakeRect(x, y, self.displayView.image.size.width / ratio, self.displayView.image.size.height / ratio);
            
        } else {
            CGFloat x = NSMidX(displayRect) - self.displayView.image.size.width/2;
            CGFloat y = NSMidY(displayRect) - self.displayView.image.size.height/2;
            self.displayView.frame = NSMakeRect(x, y, self.displayView.image.size.width, self.displayView.image.size.height);
        }

    }
}



- (IBAction)toggleCollectionView:(NSButton *)sender {
    
    NSRect start_frame = self.animationView.frame;
    NSRect end_frame;
    
    
    if (self.collectionsDisplay) {
        end_frame = NSMakeRect(0, -120, self.animationView.frame.size.width, self.animationView.frame.size.height);
    } else {
        end_frame = NSMakeRect(0, 0, self.animationView.frame.size.width, self.animationView.frame.size.height);
    }
    
    NSLog(@"start: %@", NSStringFromRect(start_frame));
    NSLog(@"end: %@", NSStringFromRect(end_frame));
    
    NSDictionary *animate_setting = @{NSViewAnimationTargetKey:self.animationView,
                                          NSViewAnimationStartFrameKey: [NSValue valueWithRect:start_frame],
                                          NSViewAnimationEndFrameKey: [NSValue valueWithRect:end_frame]};
    
    NSViewAnimation *animation = [[NSViewAnimation alloc] initWithViewAnimations:@[animate_setting]];
    animation.duration = 0.3;
    animation.delegate = self;
    [animation setAnimationBlockingMode:NSAnimationNonblockingThreaded];
    [animation startAnimation];
    
    sender.image = self.collectionsDisplay?[NSImage imageNamed:@"list_show"]:[NSImage imageNamed:@"list_hide"];
    self.collectionsDisplay = !self.collectionsDisplay;
}

- (IBAction)clockwiseRotate:(NSButton *)sender {
    const CGFloat angle = -M_PI_2;
    const CGFloat start_angle = [[self.displayView.layer valueForKeyPath:@"transform.rotation.z"] floatValue];
    const CGFloat end_angle = start_angle + angle;
    
    [self.displayView setAnchorPoint:NSMakePoint(0.5, 0.5)];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 0.3;
    animation.fromValue = [NSNumber numberWithFloat:start_angle];
    animation.toValue = [NSNumber numberWithFloat:end_angle];
    [self.displayView.layer addAnimation:animation forKey:@"rotate"];
    self.displayView.layer.transform = CATransform3DRotate(self.displayView.layer.transform, angle, 0, 0, 1);
    
}

- (IBAction)zoomin:(NSButton *)sender {
    [self.displayView setAnchorPoint:NSMakePoint(0.5, 0.5)];
    const CGFloat scale = 1.1;
    self.displayView.layer.transform = CATransform3DScale(self.displayView.layer.transform, scale, scale, 1);
}


- (IBAction)zoomout:(NSButton *)sender {
    [self.displayView setAnchorPoint:NSMakePoint(0.5, 0.5)];
    const CGFloat scale = 0.9;
    self.displayView.layer.transform = CATransform3DScale(self.displayView.layer.transform, scale, scale, 1);
}

- (IBAction)prev:(NSButton *)sender {
    NSInteger index = 0;
    if ((index = self.collectionView.selectionIndexes.firstIndex) <= 0) {
        return;
    }
    self.collectionView.selectionIndexes = [NSIndexSet indexSetWithIndex:index - 1];
}

- (IBAction)next:(NSButton *)sender {
    NSInteger index = self.collectionView.selectionIndexes.firstIndex;
    if (index >= [(NSArray*)self.arrayController.arrangedObjects count]) {
        return;
    }
    self.collectionView.selectionIndexes = [NSIndexSet indexSetWithIndex:index+1];
}

- (IBAction)downloadPicture:(NSButton *)sender {
    NSNumber* file_type = [self.images.pictures[self.arrayController.selectionIndex] objectForKey:@"type"];
    NSString *saved_location = [NSString stringWithFormat:@"~/Downloads/%@", self.displayView.image.name];
    NSString *file_path = [saved_location stringByExpandingTildeInPath];
    
    if ([file_type integerValue] == NSGIFFileType ) {
        [self.displayView.image saveAnimatedGIFToFile:file_path];
    } else {
        NSImageRep *imgRep = [[self.displayView.image representations] objectAtIndex: 0];
        NSDictionary *image_property = @{};
//        if ([file_type integerValue] == NSGIFFileType ) {
//            image_property = @{NSImageLoopCount: @0,
//                               NSImageCurrentFrameDuration: @1,
//                               NSImageCurrentFrame: @0,
//                               NSImageFrameCount: @10,
//                               };
//        }
        NSData *data = [(NSBitmapImageRep*)imgRep representationUsingType: [file_type integerValue]
                                                               properties: image_property];
        
        if ([data writeToFile:file_path atomically: NO]) {
            NSLog(@"save file success!");
        } else {
            NSLog(@"faild to save image");
        }
    }
}

-(void)dealloc {
    [NSMenu setMenuBarVisible:YES];
    NSLog(@"ImageViewerWindowController dealloc");
    [self.arrayController removeObserver:self forKeyPath:@"selectionIndex"];
}
- (IBAction)showCurrentSelected:(NSButton *)sender {
    NSLog(@"current seletced %@", self.collectionView.selectionIndexes);
    NSLog(@"current seletced %lu", (unsigned long)self.arrayController.selectionIndex);
}


@end


