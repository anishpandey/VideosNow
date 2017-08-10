//
//  VideoCell.m
//  VideoNow
//
//  Created by Anish Kumar on 7/17/17.
//  Copyright © 2017 Anish Kumar. All rights reserved.
//

#import "VideoCell.h"
#import <VocSdk/VocSdk.h>
#import "UIImageView+WebCache.h"

@implementation VideoCell

- (void)populateModel:(VideoModelArray*)model
{
    _videoTitleLabel.text = model.videoTitle;
    _videoDetailLabel.text = model.videoDescription;
    
    [_videoImageView sd_setImageWithURL:[NSURL URLWithString:model.thumbURL]
                           placeholderImage:[UIImage imageNamed:@"TabVideo"]];
    
    [self updateProgress:model.item.size bytesDownloaded:model.item.bytesDownloaded];
    
    switch (model.item.state)
    {
        case VOCItemDiscovered:
        {
//            self.downloadButton.enabled = YES;
//            self.playButton.enabled = NO;
//            self.deleteButton.enabled = NO;
            NSLog(@"VOCItemDiscovered = %@", model.videoTitle);
        }
            break;
            
        case VOCItemDownloading:
        {
//            self.progress.hidden = NO;
//            self.downloadButton.enabled = YES;
//            self.playButton.enabled = YES;
//            self.deleteButton.enabled = NO;
//            [self.downloadButton setBackgroundImage:[UIImage imageNamed:@"PauseDownload"] forState:UIControlStateNormal];
//            
//            self.progressBar.progressStrokeColor = [UIColor blueColor];
            
            NSLog(@"VOCItemDownloading = %@", model.videoTitle);
        }
            break;
            
        case VOCItemCached:
        {
//            self.downloadButton.enabled = NO;
//            self.progress.hidden = YES;
//            self.playButton.enabled = YES;
//            self.deleteButton.enabled = YES;
//            
//            [self.downloadButton setTitleColor:[UIColor colorWithRed:247/255.0 green:7/255.0 blue:35/255.0 alpha:1.0] forState:UIControlStateNormal];
//            [self.downloadButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:10.0]];
//            [self.downloadButton setTitle:@"100%" forState:UIControlStateNormal];
//            [self.downloadButton setBackgroundImage:nil forState:UIControlStateNormal];
//            
//            self.progressBar.progressStrokeColor = [UIColor redColor];
            NSLog(@"VOCItemCached = %@", model.videoTitle);
        }
            break;
            
        case VOCItemPartiallyCached:
        {
//            self.downloadButton.enabled = YES;
//            self.playButton.enabled = YES;
//            self.deleteButton.enabled = NO;
//            [self.downloadButton setBackgroundImage:[UIImage imageNamed:@"Download"] forState:UIControlStateNormal];
//            
//            self.progressBar.progressStrokeColor = [UIColor orangeColor];
            NSLog(@"VOCItemPartiallyCached = %@", model.videoTitle);
        }
            break;
            
        case VOCItemPaused:
        {
//            self.downloadButton.enabled = YES;
//            self.playButton.enabled = NO;
//            self.deleteButton.enabled = NO;
//            [self.downloadButton setBackgroundImage:[UIImage imageNamed:@"Download"] forState:UIControlStateNormal];
            
            NSLog(@"VOCItemPaused = %@", model.videoTitle);
        }
            break;
            
        default:
        {
//            self.downloadButton.enabled = YES;
//            self.playButton.enabled = YES;
//            self.deleteButton.enabled = NO;
        }
            break;
    }
}

-(void) updateProgress:(double)size bytesDownloaded:(double) bytesDownloaded//VR:ProgressOption
{
    
    if (size <= 0.0 || bytesDownloaded <= 0.0) {
        //	DDLogError("Progress not updated. Size is %f which is wrong.", size);
        return;
    }
    int progress = (bytesDownloaded/size) * 100;
    progress = progress < 100 ? progress : 100;//it could happen in the case of HLS
    NSLog(@"Bytes Downlaoded = %f , progress = %d ", bytesDownloaded, progress);
    //self.progress.text = [NSString stringWithFormat:@"%d",progress];
    
    //self.progressBar.value = progress;
}

@end
