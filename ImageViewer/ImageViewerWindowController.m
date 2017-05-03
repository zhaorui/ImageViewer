//
//  ImageViewerWindowController.m
//  ImageViewer
//
//  Created by 赵睿 on 26/4/17.
//  Copyright © 2017年 赵睿. All rights reserved.
//

#import "ImageViewerWindowController.h"
#import "ThumbnailViewController.h"
#import "ThumbnailView.h"

@interface ImageViewerWindowController ()

@property (strong) IBOutlet NSArrayController *arrayController;
@property (weak) IBOutlet NSCollectionView *collectionView;
@property (weak) IBOutlet NSImageView *displayView;

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
    
    [self.collectionView addObserver:self forKeyPath:@"selectionIndexes"
                             options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionPrior | NSKeyValueObservingOptionInitial
                             context:ImageViewerWindowControllerContext];
    
    //add images
    self.thumbnails = [[NSMutableArray alloc] init];
    [self.thumbnails addObject:@{@"image": [NSImage imageNamed:NSImageNameIconViewTemplate]}];
    [self.thumbnails addObject:@{@"image": [NSImage imageNamed:NSImageNameBluetoothTemplate]}];
    [self.thumbnails addObject:@{@"image": [NSImage imageNamed:NSImageNameIChatTheaterTemplate]}];
    [self.thumbnails addObject:@{@"image": [NSImage imageNamed:NSImageNameSlideshowTemplate]}];
    [self.thumbnails addObject:@{@"image": [NSImage imageNamed:NSImageNameActionTemplate]}];
    [self.thumbnails addObject:@{@"image": [NSImage imageNamed:NSImageNameSmartBadgeTemplate]}];
    
    [self.thumbnails addObject:@{@"image": [NSImage imageNamed:@"poto"]}];
    [self.thumbnails addObject:@{@"image": [NSImage imageNamed:@"lugu"]}];
//    [self.thumbnails addObject:@{@"image": [NSImage imageNamed:@"lugu"]}];
//    [self.thumbnails addObject:@{@"image": [NSImage imageNamed:@"lugu"]}];
//    [self.thumbnails addObject:@{@"image": [NSImage imageNamed:@"lugu"]}];
//    [self.thumbnails addObject:@{@"image": [NSImage imageNamed:@"lugu"]}];
//    [self.thumbnails addObject:@{@"image": [NSImage imageNamed:@"lugu"]}];
//    [self.thumbnails addObject:@{@"image": [NSImage imageNamed:@"lugu"]}];
//    [self.thumbnails addObject:@{@"image": [NSImage imageNamed:@"lugu"]}];
//    [self.thumbnails addObject:@{@"image": [NSImage imageNamed:@"lugu"]}];
//    
//    [self.thumbnails addObject:@{@"image": [NSImage imageNamed:@"lugu"]}];
//    [self.thumbnails addObject:@{@"image": [NSImage imageNamed:@"lugu"]}];
//    [self.thumbnails addObject:@{@"image": [NSImage imageNamed:@"lugu"]}];
//    [self.thumbnails addObject:@{@"image": [NSImage imageNamed:@"lugu"]}];
//    [self.thumbnails addObject:@{@"image": [NSImage imageNamed:@"lugu"]}];
//    [self.thumbnails addObject:@{@"image": [NSImage imageNamed:@"lugu"]}];
//    [self.thumbnails addObject:@{@"image": [NSImage imageNamed:@"lugu"]}];
//    [self.thumbnails addObject:@{@"image": [NSImage imageNamed:@"lugu"]}];
//    [self.thumbnails addObject:@{@"image": [NSImage imageNamed:@"lugu"]}];
    
    [self.arrayController addObjects: self.thumbnails];
    //[self.arrayController setContent:thumbnails];
    
    //why this readonly property could be assigned?
    //self.arrayController.selectionIndex = 0;
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == ImageViewerWindowControllerContext && [keyPath isEqualToString:@"selectionIndex"] && object == self.arrayController) {
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

    } else if (context == ImageViewerWindowControllerContext && [keyPath isEqualToString:@"selectionIndexes"] && object == self.collectionView) {
        NSLog(@"%@", change);
        
        
//        NSIndexSet *new_index = [change valueForKey:NSKeyValueChangeNewKey];
//        NSIndexSet *old_index = [change valueForKey:NSKeyValueChangeOldKey];
//        
        
//        NSInteger prior = [[change valueForKey:NSKeyValueChangeNotificationIsPriorKey] integerValue];
        
//        NSLog(@"prior: %lu", prior);
//        NSLog(@"<prior>: %@",[change valueForKey:@"notificationIsPrior"]);
        
//        [[[self.collectionView itemAtIndex:new_index.firstIndex] view] setNeedsDisplay:YES];
//        [[[self.collectionView itemAtIndex:old_index.firstIndex] view] setNeedsDisplay:YES];
        //[(ThumbnailView*)[[self.collectionView itemAtIndex:new_index.firstIndex] view] setSelected: YES];
        
    }
}

-(void)dealloc {
    [NSMenu setMenuBarVisible:YES];
    NSLog(@"ImageViewerWindowController dealloc");
    [self.collectionView removeObserver:self forKeyPath:@"selectionIndexes"];
    [self.arrayController removeObserver:self forKeyPath:@"selectionIndex"];
}
- (IBAction)showCurrentSelected:(NSButton *)sender {
    NSLog(@"current seletced %@", self.collectionView.selectionIndexes);
    NSLog(@"current seletced %lu", (unsigned long)self.arrayController.selectionIndex);
}

@end
