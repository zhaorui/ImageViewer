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
    
    // bug in OS X 10.11.x in that NSCollectionView cannot be connected to its prototype item in the storyboard
    // so we set it here programmatically
    //
    //self.collectionView.itemPrototype = self.thumbnail;
    ThumbnailViewController *thumbnail = [[ThumbnailViewController alloc] initWithNibName:@"ThumbnailViewController"
                                                                                   bundle:nil];
    self.collectionView.itemPrototype = thumbnail;
    
    
    [self.arrayController addObserver:self forKeyPath:@"selectionIndex"
                              options:NSKeyValueObservingOptionNew
                              context:ImageViewerWindowControllerContext];
    
    //add images
    self.thumbnails = [[NSMutableArray alloc] init];
    [self.thumbnails addObject:@{@"image": [NSImage imageNamed:@"FirstResponder"]}];
    [self.thumbnails addObject:@{@"image": [NSImage imageNamed:NSImageNameIconViewTemplate]}];
    [self.thumbnails addObject:@{@"image": [NSImage imageNamed:NSImageNameBluetoothTemplate]}];
    [self.thumbnails addObject:@{@"image": [NSImage imageNamed:NSImageNameIChatTheaterTemplate]}];
    [self.thumbnails addObject:@{@"image": [NSImage imageNamed:NSImageNameSlideshowTemplate]}];
    [self.thumbnails addObject:@{@"image": [NSImage imageNamed:NSImageNameActionTemplate]}];
    [self.thumbnails addObject:@{@"image": [NSImage imageNamed:NSImageNameSmartBadgeTemplate]}];
    
    [self.thumbnails addObject:@{@"image": [NSImage imageNamed:@"poto"]}];
    [self.thumbnails addObject:@{@"image": [NSImage imageNamed:@"lugu"]}];
    [self.thumbnails addObject:@{@"image": [NSImage imageNamed:@"forward"]}];

    
    [self.arrayController addObjects: self.thumbnails];
    self.collectionsDisplay = YES;
    
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == ImageViewerWindowControllerContext && [keyPath isEqualToString:@"selectionIndex"] && object == self.arrayController) {
        
        NSLog(@"change: %@", change);
        
        if ([self.arrayController.arrangedObjects count] == 0 ) {
            NSLog(@"Sometimes KVO observe that arrayController's array is empty, while we change the selctionIndex");
            return;
        }
        
        self.displayView.image = [self.thumbnails[self.arrayController.selectionIndex] objectForKey:@"image"];
        
        
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
    //anchor point is set once view is loaded to window, so the view won't be offset
    //[self.displayView.layer setAnchorPoint:NSMakePoint(0.5, 0.5)];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 0.3;
    animation.fromValue = [NSNumber numberWithFloat:self.displayView.angle];
    self.displayView.angle -= M_PI_2;
    animation.toValue = [NSNumber numberWithFloat:self.displayView.angle];
    
    [self.displayView setAnchorPoint:NSMakePoint(0.5, 0.5)];
    
    [self.displayView.layer addAnimation:animation forKey:@"rotate"];
    self.displayView.layer.transform = CATransform3DRotate(CATransform3DIdentity, self.displayView.angle, 0, 0, 1);
    
}

- (IBAction)zoomin:(NSButton *)sender {
    //self.displayView.frame = CGRectInset(self.displayView.frame, -10, -10);
    self.displayView.scale += 0.1;
    self.displayView.layer.transform = CATransform3DScale(CATransform3DIdentity, self.displayView.scale, self.displayView.scale, 1);
}


- (IBAction)zoomout:(NSButton *)sender {
    //self.displayView.frame = CGRectInset(self.displayView.frame, 10, 10);
    self.displayView.scale -= 0.1;
    self.displayView.layer.transform = CATransform3DScale(CATransform3DIdentity, self.displayView.scale, self.displayView.scale, 1);
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

