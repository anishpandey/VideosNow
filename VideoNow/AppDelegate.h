//
//  AppDelegate.h
//  VideoNow
//
//  Created by Anish Kumar on 7/17/17.
//  Copyright © 2017 Anish Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@protocol VocService;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) id<VocService> vocService;
@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

@end


static inline AppDelegate *appDelegate()
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}
