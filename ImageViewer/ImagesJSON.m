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
            NSImage *image = [[NSImage alloc] initWithContentsOfURL:url];
            [self.pictures addObject:image];
        }
        
    }
    
    return self;
}

@end
