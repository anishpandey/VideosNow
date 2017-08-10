//
//  AppDelegate.h
//  VocSdkExample
//
//  Created by Tzvetan Todorov on 8/11/15.
//  Copyright (c) 2015 Akamai. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol VocService;


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) id<VocService> vocService;


@end


static inline AppDelegate *appDelegate()
{
	return (AppDelegate *)[UIApplication sharedApplication].delegate;
}
