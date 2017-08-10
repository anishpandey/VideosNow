//
//  VNSharedData.h
//  VideosNow
//
//  Created by Anish Kumar on 7/27/17.
//  Copyright © 2017 Anish Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VNSharedData : NSObject

+ (VNSharedData *)sharedManager;
@property (nonatomic, strong) NSArray *categoryArray;

@end
