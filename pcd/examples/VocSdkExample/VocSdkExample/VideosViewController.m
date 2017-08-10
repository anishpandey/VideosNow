//
//  VideosViewController.m
//  VocSdkExample
//
//  Created by Tzvetan Todorov on 8/11/15.
//  Copyright (c) 2015 Akamai. All rights reserved.
//

#import <VocSdk/VocSdk.h>

#import "VideosViewController.h"

#import "AppDelegate.h"
#import "VideoCell.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface VideosViewController () <VocObjSetChangeListener>

@property (strong, nonatomic) id<VocVideoSet>		vocVideos;

@end


@implementation VideosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

	[appDelegate().vocService getVideosWithFilter:[VocVideoFilter allWithSort:nil]
									   completion:^(NSError * __nullable error, id<VocVideoSet> __nullable set) {
		if (error) {
			NSLog(@"There was an error trying to get items from VOC SDK %@", error);
			return ;
		}

		NSLog(@"Received new item set from VOC SDK with %ld items", (long)set.videos.count);

		self.vocVideos = set;
		[self.vocVideos addListener:self];

		[self.tableView reloadData];
	}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - VOC SDK change listener

- (void)vocService:(nonnull id<VocService>)vocService
   objSetDidChange:(nonnull id<VocObjSet>)objSet
			 added:(nonnull NSSet *)added
		   updated:(nonnull NSSet *)updated
		   removed:(nonnull NSSet *)removed
	 objectsBefore:(nonnull NSArray *)objectsBefore
{
	[self.tableView reloadData];
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return self.vocVideos == nil ?  0 : self.vocVideos.videos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    VideoCell *cell = (VideoCell*)[tableView dequeueReusableCellWithIdentifier:@"videoClip" forIndexPath:indexPath];
    
    // Configure the cell...
	[cell setItem: self.vocVideos.videos[indexPath.row]];
    
    return cell;
}


- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
	

	id<VocItem> selectedItem =  (id<VocItem>) self.vocVideos.videos[indexPath.row];

	UIAlertAction* downloadAction = [UIAlertAction actionWithTitle:@"Download" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		NSLog(@"START DOWNLOAD ACTION: %@",selectedItem.contentId);
		[appDelegate().vocService downloadItems:@[selectedItem] options:@{@"videoPartialDownloadLength":@(0),											@"downloadBehavior":@(VOCItemDownloadFullAuto)}
																completion:nil];
		[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
	}];

	UIAlertAction* pauseAction = [UIAlertAction actionWithTitle:@"Pause Download" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		NSLog(@"PAUSE DOWNLOAD ACTION: %@",selectedItem.contentId);
		[appDelegate().vocService pauseItemDownload:selectedItem completion:nil];
		[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
	}];

	UIAlertAction* deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		NSLog(@"DELETE ACTION: %@",selectedItem.contentId);
		[selectedItem deleteFiles:NO];
		[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
	}];

	UIAlertAction* playAction = [UIAlertAction actionWithTitle:@"Play Video" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

		NSLog(@"PLAY VIDEO ACTION: %@",selectedItem.contentId);
		if ([selectedItem conformsToProtocol:@protocol(VocItemHLSVideo)]) {
			id<VocItemHLSVideo> hlsVideo = (id<VocItemHLSVideo>)selectedItem;

			if ([appDelegate().vocService hlsServerRunning]) {
				NSURL* url = [appDelegate().vocService.hlsServerUrl URLByAppendingPathComponent:hlsVideo.hlsServerRelativePath];
				[self playVideoAt:url];
				return ;
			}
			[appDelegate().vocService startHLSServerWithCompletion:^(BOOL success){
				NSURL* url = [appDelegate().vocService.hlsServerUrl URLByAppendingPathComponent:hlsVideo.hlsServerRelativePath];
				[self playVideoAt:url];

			}];

		} else { //Not HLS Video
			NSURL* url = [NSURL fileURLWithPath:selectedItem.file.localPath];
			[self playVideoAt:url];
		}

	}];

	UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Menu" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
	switch (selectedItem.state) {
		case VOCItemDiscovered:
			[alertController addAction:downloadAction];
			break;

		case VOCItemQueued:
			[alertController addAction:pauseAction];
			break;

		case VOCItemIdle:
			[alertController addAction:downloadAction];
			[alertController addAction:pauseAction];
			[alertController addAction:deleteAction];
			break;

		case VOCItemPaused:
			[alertController addAction:downloadAction];
			[alertController addAction:deleteAction];
			break;

		case VOCItemDownloading:
			[alertController addAction:pauseAction];
			break;

		case VOCItemCached:
			if ([selectedItem conformsToProtocol:@protocol(VocItemVideo)]) {
				[alertController addAction:playAction];
			}
			[alertController addAction:deleteAction];
			break;

		case VOCItemPartiallyCached:
			if ([selectedItem conformsToProtocol:@protocol(VocItemVideo)]) {
				[alertController addAction:playAction];
			}
			[alertController addAction:downloadAction];
			[alertController addAction:deleteAction];
			break;

		case VOCItemFailed:
			[alertController addAction:downloadAction];
			[alertController addAction:deleteAction];
			break;

		default:
			break;
	}

	[alertController addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDestructive handler:nil]];

	[self presentViewController:alertController animated:YES completion:nil];
}

-(void)playVideoAt:(NSURL*)playableURL{
	NSLog(@"Video Playback");

	AVPlayerViewController* playerVC = [[AVPlayerViewController alloc]init];
	AVPlayer* player = [AVPlayer playerWithURL:playableURL];
	playerVC.player = player;

	[self presentViewController:playerVC animated:NO completion:^{
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[player play];
		});
	}];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
