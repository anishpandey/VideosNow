//
//  VideoCell.m
//  VocSdkExample
//
//  Created by Yadhu Manoharan on 7/6/17.
//  Copyright © 2017 Akamai. All rights reserved.
//

#import <VocSdk/VocSdk.h>
#import "VideoCell.h"

@implementation VideoCell

- (void)awakeFromNib {
	// Initialization code
	[super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];

	// Configure the view for the selected state
}

- (void)setItem:(nonnull id<VocItem>)item
{
	self.title.text = item.title;
	if (item.thumbnail) {
		self.thumbnail.image = [UIImage imageWithContentsOfFile:item.thumbnail.localPath];
	}

	self.info2.text = [NSString stringWithFormat:@"contentID: %@",item.contentId];

	[self updateProgress:item.size bytesDownloaded:item.bytesDownloaded];

	switch (item.state) {

		case VOCItemDiscovered:
			self.backgroundColor = [UIColor brownColor];
			self.info.text = @"DISCOVERED";
			break;

		case VOCItemIdle:
			self.backgroundColor = [UIColor orangeColor];
			self.info.text = @"IDLE";
			break;

		case VOCItemQueued:
			self.backgroundColor = [UIColor whiteColor];
			self.info.text = @"QUEUED";
			break;

		case VOCItemPaused:
			self.backgroundColor = [UIColor yellowColor];
			self.info.text = @"PAUSED";
			break;

		case VOCItemDownloading:
			self.backgroundColor = [UIColor whiteColor];
			self.info.text = @"DOWNLOADING";
			break;

		case VOCItemCached:
			self.backgroundColor = [UIColor greenColor];
			self.info.text = @"CACHED";
			self.progress.hidden = YES;
			break;

		case VOCItemPartiallyCached:
			self.backgroundColor = [UIColor greenColor];
			self.info.text = @"P-CACHED";
			self.progress.hidden = YES;
			break;

		case VOCItemFailed:
			self.backgroundColor = [UIColor redColor];
			self.info.text = @"FAILED";
			break;

		default:
			self.backgroundColor = [UIColor grayColor];
			break;
	}

}

-(void) updateProgress:(double)size bytesDownloaded:(double) bytesDownloaded//VR:ProgressOption
{
	if (size <=0) {
		//	DDLogError("Progress not updated. Size is %f which is wrong.", size);
		return;
	}
	int progress = (bytesDownloaded/size) * 100;
	progress = progress < 100 ? progress : 100;//it could happen in the case of HLS
	self.progress.text = [NSString stringWithFormat:@"%d",progress];
}

@end
