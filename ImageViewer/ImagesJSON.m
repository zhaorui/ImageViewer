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
            NSURL *o_url = [NSURL URLWithString:(NSString*)pict_info[@"o_url"]];
            NSURL *l_url = [NSURL URLWithString:(NSString*)pict_info[@"l_url"]];
            NSURL *m_url = [NSURL URLWithString:(NSString*)pict_info[@"m_url"]];
            NSURL *s_url = [NSURL URLWithString:(NSString*)pict_info[@"s_url"]];
            NSNumber *angle = pict_info[@"angle"];
            NSNumber *mid = pict_info[@"mid"];
            
            NSBitmapImageFileType type = [self imageTypeFromFileName:l_url.lastPathComponent];
            NSMutableDictionary * pict_dict = [NSMutableDictionary dictionaryWithDictionary:@{@"image": [NSImage imageNamed:@"115spin"],
                                                                                              @"type": [NSNumber numberWithInteger:type],
                                                                                              @"name": @"",
                                                                                              @"o_url": o_url,
                                                                                              @"l_url": l_url, //this is the default one
                                                                                              @"m_url": m_url,
                                                                                              @"s_url": s_url,
                                                                                              @"angle": angle,
                                                                                              @"mid": mid,
                                                                                              @"exist": [NSNumber numberWithBool:NO],
                                                                                              }];
            
            [self.pictures addObject:pict_dict];
            NSLog(@"lurl: %@", l_url);
            dispatch_queue_t queue = dispatch_queue_create("download_picture", nil);
            dispatch_async(queue, ^{
                
                NSImage *image = [[NSImage alloc] initWithContentsOfURL:l_url];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (image != nil) {
                        pict_dict[@"image"] = image;
                        pict_dict[@"name"] = l_url.lastPathComponent;
                        pict_dict[@"exist"] = [NSNumber numberWithBool:YES];
                    } else {
                        pict_dict[@"image"] = [NSImage imageNamed:@"ImgNotExist"];
                    }
                });
            });
        }
    }
    
    return self;
}


- (NSBitmapImageFileType)imageTypeFromFileName:(NSString*)name {
    NSString *file_type = [[name componentsSeparatedByString:@"."] firstObject];
    NSBitmapImageFileType type = NSTIFFFileType;
    if ([file_type isEqualToString:@"bmp"]) {
        type = NSBMPFileType;
    } else if ([file_type isEqualToString:@"png"]) {
        type = NSPNGFileType;
    } else if ([file_type isEqualToString:@"tiff"]) {
        type = NSTIFFFileType;
    } else if ([file_type isEqualToString:@"jpg"] || [file_type isEqualToString:@"jpeg"]) {
        type = NSJPEGFileType;
    } else if ([file_type isEqualToString:@"gif"]) {
        type = NSGIFFileType;
    }
    return type;
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
