//
//  VideoModelArray.m
//  PrePosition
//
//  Created by Anish Kumar on 7/13/17.
//  Copyright © 2017 Akamai. All rights reserved.
//

#import "VideoModelArray.h"

@implementation VideoModelArray 

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                                  @"content_id": @"videoID",
                                                                  @"description": @"videoDescription",
                                                                  @"image_url": @"thumbURL",
                                                                  @"title": @"videoTitle",
                                                                  @"url": @"videoUrl",
                                                                  @"item": @"item"
                                                                  }];
}

@end
