//
//  AppDelegate.m
//  VideoNow
//
//  Created by Anish Kumar on 7/17/17.
//  Copyright © 2017 Anish Kumar. All rights reserved.
//
#import <VocSdk/VocSdk.h>
#import "AppDelegate.h"
#import "UITabBarController+TransparentBackground.h"
#import "VNNetworkFatory.h"
#import "VNSharedData.h"
#import "Settings+CoreDataClass.h"

@interface AppDelegate ()<VocServiceDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
////    tabBarController.tabBar.barStyle = UIBarStyleBlack;
////    tabBarController.tabBar.translucent = NO;
////    tabBarController.tabBar.barTintColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.0];
//    
//    //  The color you want the tab bar to be
//    UIColor *barColor = [UIColor colorWithRed:79.0f/255.0 green:53.0f/255.0 blue:98.0f/255.0 alpha:0.6f];
//    
//    //  Create a 1x1 image from this color
//    UIGraphicsBeginImageContext(CGSizeMake(1, 1));
//    [barColor set];
//    UIRectFill(CGRectMake(0, 0, 1, 1));
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    //  Apply it to the tab bar
//    [[UITabBar appearance] setBackgroundImage:image];
    
    
    
    //CoreData Set
    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    NSError *error ;
    NSFetchRequest<Settings *> *fetchRequest = [Settings fetchRequest];
    NSArray *resultArray= [context executeFetchRequest:fetchRequest error:&error];

    if ([resultArray count] == 0)
    {
        NSManagedObject *entityNameObj = [NSEntityDescription insertNewObjectForEntityForName:@"Settings" inManagedObjectContext:context];
        
        [entityNameObj setValue:@YES forKey:@"wiFIState"];
        [entityNameObj setValue:@NO forKey:@"cellularState"];
        [entityNameObj setValue:@0.5 forKey:@"diskSpaceAllocated"];
        
        //Save context
        NSMergePolicy *mergePolicy = [[NSMergePolicy alloc] initWithMergeType:NSMergeByPropertyStoreTrumpMergePolicyType];
        [context setMergePolicy:mergePolicy];
        [((AppDelegate*)[[UIApplication sharedApplication] delegate]) saveContext];
    }
    
    
    //Fetch Data
    resultArray= [context executeFetchRequest:fetchRequest error:&error];
    
    BOOL wifiState = NO;
    BOOL cellularState = NO;
    int spaceAllocated = 0;
    
    NSManagedObject *ids = [resultArray objectAtIndex:0];
    wifiState = [[ids valueForKey:@"wiFIState"] boolValue];
    cellularState = [[ids valueForKey:@"cellularState"] boolValue];
    spaceAllocated = [[ids valueForKey:@"diskSpaceAllocated"] intValue];
    //for (NSManagedObject *ids in resultArray)

    
    //Tab controls
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UITabBar *tabBar = tabBarController.tabBar;

    tabBar.translucent = YES;
    
    
    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, tabBar.bounds.size.height)];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    [blurView setEffect:blurEffect];
    [tabBar insertSubview:blurView atIndex:0];
    
    //18.2.31
    {
        
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
        
        if (self.vocService.state == VOCServiceStateNotRegistered) {
            // voc service needs registering
            NSLog(@"VOC not registered, starting registration flow");
            
            return YES;
        }
        
        // voc service is registered
        NSLog(@"VOC registered, starting normal flow");
        
        [self vocService:self.vocService didRegister:@{}];
        
        //Set a max file size (1 GB)
        //appDelegate().vocService.config.fileSizeMax = 1 * 1024 * 1024 * 1024;
    }
    
    
    
    //18.22
//    {
//        NSError *error;
//        self.vocService = [VocServiceFactory createServiceWithDelegate:self
//                                                         delegateQueue:[NSOperationQueue mainQueue]
//                                                               options:@{}
//                                                                 error:&error];
//        if (!self.vocService) {
//            // voc service cannot start up
//            NSLog(@"Could not create Voc Service %@", error);
//            
//            return NO;
//        }
//        
////        if (self.vocService.state == VOCServiceStateNotRegistered) {
////            // voc service needs registering
////            NSLog(@"VOC not registered, starting registration flow");
////            
////            return YES;
////        }
//        
//        // voc service is registered
//        NSLog(@"VOC registered, starting normal flow");
//        
//        [self vocService:self.vocService didRegister:@{}];
//        
//        NSLog(@"%ld",[[self.vocService config] itemDownloadBehavior]);
//        
//        if (appDelegate().vocService.state == VOCServiceStateNotRegistered) {
//            
//            //  [self.view showActivityViewWithLabel:@"Initializing...."];
//            
//            [[appDelegate().vocService config]setFileSizeMax:10300000000];//Set a max file size (100 GB)
//            NSString *sdkLicense = @"022851db16eba80a3c209a5c5b7ccca67e54c55fa6b326e01965dd55de4136df"; //sony
//            //NSString *sdkLicense = @"8056883356a6d9dd7db3c7390fcef590235de9b57aeb0f21624cb48e0589da4b"; //watchNow
//            
//            [appDelegate().vocService registerWithLicense:sdkLicense
//                                                 segments:nil
//                                               completion:^(NSError * __nullable error)
//             {
//                 
//                 if (error)
//                 {
//                     
//                     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
//                                                                                    message:error.localizedFailureReason
//                                                                             preferredStyle:UIAlertControllerStyleAlert];
//                     [alert addAction: [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
//                                        {
//                                            
//                                        }]
//                      ];
//                     
//                     [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
//                     return ;
//                 }
//                 else
//                 {
//                     
//                 }
//             }];
//        }
//    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userRegistered" object:self];
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

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Data"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
