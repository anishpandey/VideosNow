//
//  VNNetworkFatory.m
//  VideosNow
//
//  Created by Anish Kumar on 7/27/17.
//  Copyright © 2017 Anish Kumar. All rights reserved.
//

#import "VNNetworkFatory.h"
#import "VideoModel.h"
#import "VideoModelArray.h"
#import "CategoryModel.h"

@interface VNNetworkFatory (){
    
}
@end

@implementation VNNetworkFatory

+ (VNNetworkFatory *)networkingSharedmanager
{
    static VNNetworkFatory *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
        sharedAccountManagerInstance->_queue = dispatch_queue_create("com.akamai.voc.ent.preposition", DISPATCH_QUEUE_CONCURRENT);
        
    });
    return sharedAccountManagerInstance;
}

- (void)fetchtJSON:(void (^)(NSArray *data))success failure:(void (^)(NSDictionary *errorDict))failure
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *urlString = [NSURL URLWithString:@"http://rahuls.edgesuite-staging.net/watchnow.json"];
    
    
    NSLog(@"urlString URL = %@", urlString);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error)
      {
          NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
          int responseStatusCode = (int)[httpResponse statusCode];
          
          if (responseStatusCode == 200 )
          {
              if (data)
              {
                  NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                  
                  if (jsonArray != nil && [jsonArray isKindOfClass:[NSArray class]])
                  {
                      NSLog(@"%@",jsonArray);
                      NSDictionary *dict = [NSDictionary dictionaryWithObject:jsonArray forKey:@"categories"];
                      CategoryModel *categoryModel = [[CategoryModel alloc] initWithDictionary:dict error:&error];
                     // NSLog(@"categoryModel = %@", categoryModel);
                      //VideoModel *videoModel = [[VideoModel alloc] initWithDictionary:dict error:&error];
                      
                      //NSLog(@"videoModel = %@", videoModel);
                      
                      //NSSet *distinctSet = [NSSet setWithArray:[videoModel.content valueForKeyPath:@"videoID"]];
                      //NSLog(@"distinctSet = %@", distinctSet);
                      
                      success(jsonArray);
                  }
              }
          }
          else
          {
              if (responseStatusCode == 0)
              {
                  NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"No Connection! Please try again.", @"message", nil];
                  failure(dict);
              }
              else if (data) {
                  NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                  failure(dict);
              }
          }
      }];
    [task resume];
}

@end
