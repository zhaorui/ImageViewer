//
//  Thumbnail.m
//  ImageViewer
//
//  Created by 赵睿 on 2/5/17.
//  Copyright © 2017年 赵睿. All rights reserved.
//

#import "ThumbnailViewController.h"

@interface ThumbnailViewController ()

@end

@implementation ThumbnailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view bind:@"selected" toObject:self withKeyPath:@"selected" options:nil];
    
}



@end
