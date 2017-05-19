//
//  ImagesJSON.m
//  ImageViewer
//
//  Created by 赵睿 on 18/05/2017.
//  Copyright © 2017 赵睿. All rights reserved.
//

#import "ImagesJSON.h"


@implementation ImagesJSON

-(instancetype)initWithJsonString:(NSString*)json {
    if (self = [super init]) {
        NSError *parse_error;
        self.raw_json = json;
        self.json_dict = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                        options:NSJSONReadingAllowFragments error:&parse_error];
        if (parse_error != nil) {
            NSLog(@"ImagesJSON init failed!");
            NSLog(@"%@", parse_error);
            self.raw_json = nil;
            self.json_dict = nil;
            return nil;
        }
        
        self.pictures = [[NSMutableArray alloc] init];
        self.selected_index = [(NSNumber*)self.json_dict[@"c_index"]  integerValue];
        
        NSArray<NSDictionary*> * images = self.json_dict[@"pics"];
        for (id pict_info in images) {
            NSURL *url = [NSURL URLWithString:(NSString*)pict_info[@"o_url"]];
            NSLog(@"load pic url: %@", url);
            
            NSBitmapImageFileType type = NSTIFFFileType;
            NSString *file_type = [url.lastPathComponent componentsSeparatedByString:@"."].lastObject;
            if ([file_type isEqualToString:@"bmp"]) {
                type = NSBMPFileType;
            } else if ([file_type isEqualToString:@"tiff"]) {
                type = NSTIFFFileType;
            } else if ([file_type isEqualToString:@"jpg"] || [file_type isEqualToString:@"jpeg"]) {
                type = NSJPEGFileType;
            } else if ([file_type isEqualToString:@"gif"]) {
                type = NSGIFFileType;
            }
            
            NSMutableDictionary * pict_dict = [NSMutableDictionary dictionaryWithDictionary:@{@"image": [NSImage imageNamed:@"115spin"],
                                                                                              @"name": url.lastPathComponent,
                                                                                              @"type": [NSNumber numberWithInteger:type]}];
            
            [self.pictures addObject:pict_dict];
            
            dispatch_queue_t queue = dispatch_queue_create("download_picture", nil);
            dispatch_async(queue, ^{
                NSImage *image = [[NSImage alloc] initWithContentsOfURL:url];
                [image setName:url.lastPathComponent];
                pict_dict[@"image"] = image;
            });
        }
        
    }
    
    return self;
}

- (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
            break;
        case 0x42:
            return @"image/bmp";
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}

@end
