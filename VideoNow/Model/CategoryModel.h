//
//  CategoryModel.h
//  VideosNow
//
//  Created by Anish Kumar on 7/27/17.
//  Copyright © 2017 Anish Kumar. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "VideoModel.h"

@interface CategoryModel : JSONModel

@property (nonatomic) NSArray <VideoModel, Optional> *categories;

@end
