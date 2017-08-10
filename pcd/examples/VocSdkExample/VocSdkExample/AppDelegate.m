//
//  AppDelegate.m
//  VocSdkExample
//
//  Created by Tzvetan Todorov on 8/11/15.
//  Copyright (c) 2015 Akamai. All rights reserved.
//
#import <VocSdk/VocSdk.h>

#import "AppDelegate.h"

#import "VideosViewController.h"

@interface AppDelegate () <VocServiceDelegate>

@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.

	NSError *error;
	///Update the vocSdkInfo.plist with vocSDK licenceKey.
	self.vocService = [VocServiceFactory createServiceWithDelegate:self
													 delegateQueue:[NSOperationQueue mainQueue]
														   options:@{}
															 error:&error];
	if (!self.vocService) {
		// voc service cannot start up
		NSLog(@"Could not create Voc Service %@", error);

		UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
																	   message:[NSString stringWithFormat:@"Registration error: %@",error.localizedFailureReason]
																preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:
		 [UIAlertAction actionWithTitle:@"Dismiss"
								  style:UIAlertActionStyleDestructive
								handler:^(UIAlertAction *action) {

								}]
		 ];
		[self.window.rootViewController presentViewController:alert animated:YES completion:nil];

		return NO;
	}

		//Set a max file size (2 GB)
		appDelegate().vocService.config.fileSizeMax = 2 * 1024 * 1024 * 1024;

	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - VocServiceDelegate

- (void)vocService:(nonnull id<VocService>)vocService didBecomeNotRegistered:(nonnull NSDictionary *)info
{
	NSLog(@"didBecomeNotRegistered  %@ %@", vocService, info);
}

-(void)vocService:(nonnull id<VocService>)vocService didFailToRegister:(nonnull NSError *)error
{
	NSLog(@"didFailToRegister  %@ %@", vocService, error);
}

- (void)vocService:(nonnull id<VocService>)vocService didRegister:(nonnull NSDictionary *)info
{
	NSLog(@"didRegister %@ %@", vocService, info);
}

- (void)vocService:(nonnull id<VocService>)vocService itemsDiscovered:(nonnull NSArray *)items
{
	NSLog(@"itemsDiscovered %@ %@", vocService, items);
}

- (void)vocService:(nonnull id<VocService>)vocService itemsStartDownloading:(nonnull NSArray *)items
{
	NSLog(@"itemsStartDownloading %@ %@", vocService, items);
}

- (void)vocService:(nonnull id<VocService>)vocService itemsDownloaded:(nonnull NSArray *)items
{
	NSLog(@"itemsDownloaded %@ %@", vocService, items);
}

- (void) vocService:(nonnull id<VocService>)vocService convertDownloadRequest:(nonnull NSMutableURLRequest*) request
			   item:(nonnull id<VocItem>)item
			   file:(nonnull id<VocFile>)file
		 completion:(nonnull void (^)(NSMutableURLRequest* __nullable request))completion
{
//	Modify the download request if needed
//	Sample usages
//	[request addValue:@"abc=123;" forHTTPHeaderField:@"Set-Cookie"];
//	[request addValue:@"def=234;" forHTTPHeaderField:@"Set-Cookie"];
//	[request setURL:[NSURL URLWithString:@"https://akamai.com"]];

	completion(request);
}

-(void) vocService:(id<VocService>)vocService downloadCompletedForDRMFile:(id<VocFile>)file
		completion:(void (^)(BOOL))ContinueDownload
{
	//Provide a BOOL to the SDK to continue the download of the HLS file.
	ContinueDownload(NO);
}


@end
