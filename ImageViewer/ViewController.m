//
//  ViewController.m
//  ImageViewer
//
//  Created by 赵睿 on 25/4/17.
//  Copyright © 2017年 赵睿. All rights reserved.
//

#import "ViewController.h"
#import "ImageViewerWindowController.h"
#import "ImagesJSON.h"

// Keys used for bindings
#define ATKeyName @"name"
#define ATKeyShortDescription @"shortDescription"
#define ATKeyImagePreview @"imagePreview"


static NSString * mock_json =
@"{\
    \"c_index\": 1,\
    \"pics\": [\
                {\
                    \"s_url\": \"\",  \
                    \"m_url\": \"\",  \
                    \"l_url\": \"\",  \
                    \"o_url\": \"https://www.baidu.com/img/bd_logo1.png\",  \
                    \"angle\": 0,     \
                    \"mid\": 123123,  \
                    },\
                    {\
                    \"s_url\": \"\",  \
                    \"m_url\": \"\",  \
                    \"l_url\": \"\",  \
                    \"o_url\": \"https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_120x44dp.png\",  \
                    \"angle\": 0,     \
                    \"mid\": 123123,  \
                }\
    ]\
}";


@interface ViewController () <NSTableViewDelegate, NSTableViewDataSource>

@property (strong) NSMutableArray *tableContents;
@property (strong) NSMutableArray *windowControllers;

@property (strong) IBOutlet NSArrayController *array_controller;

@end


@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
    
    _tableContents = [NSMutableArray array];
    [self willChangeValueForKey:@"_tableContents"];
    
    [self.tableContents addObject:@{ ATKeyName: @"Basic Table View",
                                     ATKeyShortDescription: @"A Minimal View Based Implementation",
                                     ATKeyImagePreview: [NSImage imageNamed: @"lada"]}];
    
    [self.tableContents addObject:@{ ATKeyName: @"Complex Table View",
                                     ATKeyShortDescription: @"A Complex Cell Example",
                                     ATKeyImagePreview: [NSImage imageNamed: @"poto"]}];
    
    
    [self.tableContents addObject:@{ ATKeyName: @"Complex Outline View",
                                     ATKeyShortDescription: @"A Complex Bindings Example",
                                     ATKeyImagePreview: [NSImage imageNamed: @"lugu"]}];
    
    [self didChangeValueForKey:@"_tableContents"];
    
    [self.array_controller setContent:self.tableContents];
}


- (void)setRepresentedObject:(id)representedObject {
  [super setRepresentedObject:representedObject];

  // Update the view, if already loaded.
}

- (IBAction)createImageViewer:(NSButton *)sender {
    
    if (_windowControllers == nil) {
        _windowControllers = [NSMutableArray array];
    }
    
    if ([_windowControllers count] == 0) {
        
        ImagesJSON *json = [[ImagesJSON alloc] initWithJsonString:mock_json];
        ImageViewerWindowController *controller = [[ImageViewerWindowController alloc] init];
        [controller setImages:json];
        
        // Observe all windows closing so we can remove them from our array.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowClosed:) name:NSWindowWillCloseNotification object:controller.window];
        
        [self.windowControllers addObject:controller];
    }
    
    //[[self.windowControllers[0] window] setLevel:NSModalPanelWindowLevel];
}

-(void)windowClosed:(NSNotification*)note {
//    NSWindow * window = note.object;
//    for (NSWindowController *winController in self.windowControllers) {
//        if (winController.window == window) {
//            [self.windowControllers removeObject:winController];
//            break;
//        }
//    }
    [self.windowControllers removeAllObjects];
}

-(void)windowWillExitFullScreen:(NSNotification*)note {
    //[[self.windowControllers[0] window] performClose:self];
}




@end
