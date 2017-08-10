//
//  AppDelegate.swift
//  D2GExample
//
//  Created by Tzvetan Todorov on 6/26/17.
//  Copyright © 2017 Akamai. All rights reserved.
//

import UIKit
import VocSdk


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, VocServiceDelegate {

	var window: UIWindow?

    ///Update the vocSdkInfo.plist with vocSDK licenceKey.
	public var pcdService : VocService?

	// Singleton variable to return typed AppDelegate
	static var instance : AppDelegate! {
		return UIApplication.shared.delegate as! AppDelegate
	}

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

		do {
			try self.pcdService = VocServiceFactory.createService(with: self,
			                                                      delegateQueue: OperationQueue.main,
			                                                      options: nil)
				// disable automatic prepositioning
				self.pcdService!.config.itemDownloadBehavior = .none

				// set inividual video file limit to 2 GB
				self.pcdService!.config.fileSizeMax = Int64(2) * Int64(1073741824)

		} catch {
			print("Could not create service")
			return false
		}

		return true
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

