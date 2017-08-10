//
//  VNSharedData.m
//  VideosNow
//
//  Created by Anish Kumar on 7/27/17.
//  Copyright © 2017 Anish Kumar. All rights reserved.
//

#import "VNSharedData.h"

@implementation VNSharedData

+ (VNSharedData *)sharedManager
{
    static VNSharedData *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
        
    });
    return sharedAccountManagerInstance;
}

@end
