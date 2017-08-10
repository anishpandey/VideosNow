//
//  AppDelegate.swift
//  VocSdkExampleSwift
//
//  Created by Gensch, Larry on 5/17/17.
//  Copyright © 2017 Akamai Technologies. All rights reserved.
//

import UIKit
import VocSdk;

@UIApplicationMain
// App Delegate class
class AppDelegate: UIResponder, UIApplicationDelegate, VocServiceDelegate {

	var window: UIWindow?


	///Update the vocSdkInfo.plist with vocSDK licenceKey.
	/// The VocService
	public var pcdService : VocService?

	/// Singleton variable to return "our" AppDelegate
	static var ours : AppDelegate! {
		return UIApplication.shared.delegate as! AppDelegate
	}

	/// Override point for customization after application launch.
	///
	/// - Parameter `application` The shared UIApplication
	/// - Parameter `launchOptions` options passed at launch time
	///
	/// - Returns `true` to continue launching, `false` to stop launching
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		do {
			try self.pcdService = VocServiceFactory.createService(with: self,
			                                                      delegateQueue: OperationQueue.main,
			                                                      options: nil)


		} catch {
			print("Could not create service")
			return false
		}

		self.pcdService?.config.fileSizeMax = Int64(2) * Int64(1073741824)		

		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


	//MARK: - VocServiceDelegate methods

	func vocService(_ vocService: VocService, didBecomeNotRegistered info: [AnyHashable : Any]){
		print("VocSdk changed to notregistered state");
	}

	func vocService(_ vocService: VocService, didFailToRegister error: Error){
		print("VocSdk is failed to register");
	}

	func vocService(_ vocService: VocService, didRegister info: [AnyHashable : Any]){
		print("VocSdk is registered");
	}

	func vocService(_ vocService: VocService, itemsDiscovered items: [Any]){
		print("\(items.count) items discovered");
	}

	func vocService(_ vocService: VocService, itemsStartDownloading items: [Any]){
		print("\(items.count) items started downloading");
	}

	func vocService(_ vocService: VocService, itemsDownloaded items: [Any]){
		print("\(items.count) items downloaded");
	}


	/* Token Authentication Delegate API.
	* Application can modify the URL request for downloading content.
	*/
	func vocService(_ vocService: VocService, convertDownloadRequest request: NSMutableURLRequest, item: VocItem, file: VocFile, completion: @escaping (NSMutableURLRequest?) -> Swift.Void){
		//Modify the download request if needed.
		completion(request)
	}
}

