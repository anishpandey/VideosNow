//
//  VNNetworkFatory.h
//  VideosNow
//
//  Created by Anish Kumar on 7/27/17.
//  Copyright © 2017 Anish Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VNNetworkFatory : NSObject

@property (nonatomic, strong) dispatch_queue_t queue;

+ (VNNetworkFatory *)networkingSharedmanager;


- (void)fetchtJSON:(void (^)(NSArray *data))success failure:(void (^)(NSDictionary *errorDict))failure;

@end
