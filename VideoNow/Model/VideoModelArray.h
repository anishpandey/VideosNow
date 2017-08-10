//
//  VideoModelArray.h
//  PrePosition
//
//  Created by Anish Kumar on 7/13/17.
//  Copyright © 2017 Akamai. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import <VocSdk/VocSdk.h>

@protocol VideoModelArray
@end

@interface VideoModelArray : JSONModel

@property (nonatomic) NSString <Optional>*videoID;
@property (nonatomic) NSString <Optional>*videoDescription;
@property (nonatomic) NSString <Optional>*thumbURL;
@property (nonatomic) NSString <Optional>*videoTitle;
@property (nonatomic) NSString <Optional>*videoUrl;
@property (nonatomic) id<VocItemVideo, Optional>item;

@end
