//
//  ImagesJSON.h
//  ImageViewer
//
//  Created by 赵睿 on 18/05/2017.
//  Copyright © 2017 赵睿. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ImagesJSON : NSObject

@property (copy,nonatomic) NSString* raw_json;
@property (strong,nonatomic) NSDictionary * json_dict;
@property (strong,nonatomic) NSMutableArray<NSImage *> * pictures;
@property NSUInteger selected_index;

-(instancetype)initWithJsonString:(NSString*)json;

@end
