//
//  VideoModel.h
//  PrePosition
//
//  Created by Anish Kumar on 7/13/17.
//  Copyright © 2017 Akamai. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "VideoModelArray.h"

@protocol VideoModel
@end

@interface VideoModel : JSONModel

@property (nonatomic) NSString <Optional>*category_title;
@property (nonatomic) NSArray <VideoModelArray, Optional> *content;

@end
