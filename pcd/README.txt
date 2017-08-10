Akamai Predictive Content Delivery (PCD) SDK for iOS
====================================================


PREDICTIVE CONTENT DELIVERY
--------------------
The Predictive Content Delivery platform gives you the ability to intelligently cache 
videos on a user device and provide a superior experience to your users. Personalize 
videos based on user preferences, usage data, and social activity. Manage delivery of
fresh and relevant videos to user devices at the right times throughout the day. 
Efficiently download and manage content on the device. Configure, control, and 
monitor through the dashboard.

More information can be found at: http://developer.akamai.com/


VERSION
--------------------
18.31


INSTALLATION
--------------------
Please find detailed installation instructions in PCD SDK iOS Integration Guide PDF.

USAGE
--------------------
* Important API usages can be found in the integration guide.
* Get up and running with the PCD SDK with our example app in the examples folder.



LICENSE
--------------------
Use of this SDK is governed by the Mobile Application Performance (MAP), Predictive
Content Delivery (PCD) and WatchNow SDK License Agreement found at
https://www.akamai.com/product/licenses .


RELEASE NOTES
--------------------
18.31 - 2017-07-26

- Backend optimizations.
- Automatically reregister the SDK on server errors.
- Added Download2Go example app.
- Added support for streaming HLS adjustable bitrates.
- Item filters moved from VocService.h to VocDataQuery.h.
- Call to access content metadata is tried 3 times in case of device failures.
  (VocDataQuery::getItemsWithContentIds:sourceName:completion:)
- Bug fixes.

DEPRECATIONS

- registerWithLicense (instead use configuration dictionary in Info.plist)
- VocConfig::networkSelection is marked readonly in this release and
        the value it holds reflect the applied network selection.
        Use VocConfig::networkSelectionOverride for writing the value.


18.22 - 2017-06-13


- New state for VocItem - VocItemState.VOCItemPartiallyCached.
- New video and content item filters.
- VocService.addDownloadedItem:completion: is deprecated and new method
	is provided VocService.addNewContent:completion:. The methods behave the same but
	instead of passing dictionary the new method takes VocImportInfo which has
	propperties matching the dictionary keys.
- New method VocService.getItemWithURL:completion: that will load an item with 
	the given url if it is present in the cache or download it from network.
- SDK will no longer cause location prompt and will monitor location only if app
	requests and is granted authorization to use location.


DEPRECATIONS

- Following enums are deprecated
	VOCItemState.VocItemQueued (instead use VOCItemQueued)
	VOCItemState.VocItemIdle (instead use VOCItemIdle)
	VOCItemState.VocItemPaused (instead use VOCItemPaused)
	VOCItemState.VocItemFailed (instead use VOCItemFailed)
   
- Following method is deprecated   
	VocService.getItemWithContentId:completion: 
		use VocService::getItemsWithContentIds:contentIds:sourceName:completion: instead.
	VocService.addDownloadedItem:completion:
		use VocService.addDownloadedItem:completion: instead.
   
- Following property is deprecated
	VocItem.downloadingNow


