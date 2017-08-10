//
//  DownloadCell.m
//  VideosNow
//
//  Created by Anish Kumar on 8/2/17.
//  Copyright © 2017 Anish Kumar. All rights reserved.
//

#import "DownloadCell.h"
#import <VocSdk/VocSdk.h>

@implementation DownloadCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [_linearProgressBar setUsesRoundedCorners:NO];
    [_linearProgressBar setProgress:0];
    [_linearProgressBar setBarBorderWidth:0.0];
    [_linearProgressBar setBarBorderColor:[UIColor clearColor]];
    [_linearProgressBar setBarInnerBorderWidth:0];
    [_linearProgressBar setBarInnerBorderColor:nil];
    [_linearProgressBar setBarInnerPadding:0.0];
    [_linearProgressBar setBarFillColor:[UIColor orangeColor]];
    [_linearProgressBar setBarBackgroundColor:[UIColor clearColor]];
}

- (void)setItem:(nonnull id<VocItem>)item
{
    NSLog(@"----------------------");
    NSLog(@"Tite = %@", item.title);
    NSLog(@"Content_unique_id = %@", item.uniqueId);
    //NSLog(@"Content duration = %@", item.duration);
    NSLog(@"----------------------");
    self.videoTitleLabel.text = item.title;
    self.videoDetailLabel.text = item.summary;
    
    NSLog(@"Item Title = %@", item.title);
    
    if (item.thumbnail) {
        self.videoImageView.image = [UIImage imageWithContentsOfFile:item.thumbnail.localPath];
    }
    
    //self.info2.text = item.localPath;
    
    [self updateProgress:item.size bytesDownloaded:item.bytesDownloaded];
    
    //if ([item.title isEqualToString:@"What Not To Say In A Relationship"]) {
        //
    //}
    
    switch (item.state) {
            
        case VOCItemDiscovered:
            break;
            
        case VOCItemDownloading:
            self.deleteButton.enabled = NO;
            [self.downloadButton setBackgroundImage:[UIImage imageNamed:@"PauseDownload"] forState:UIControlStateNormal];
            self.downloadButton.enabled = YES;
            break;
            
        case VOCItemCached:
            self.deleteButton.enabled = YES;
            [self.downloadButton setBackgroundImage:[UIImage imageNamed:@"Download"] forState:UIControlStateNormal];
            self.downloadButton.enabled = YES;
            self.progressBar.progressStrokeColor = [UIColor redColor];
            break;
            
        case VOCItemPartiallyCached:
            self.deleteButton.enabled = NO;
            [self.downloadButton setBackgroundImage:[UIImage imageNamed:@"Download"] forState:UIControlStateNormal];
            self.downloadButton.enabled = YES;
            break;
            
        case VOCItemPaused:
            self.deleteButton.enabled = NO;
            [self.downloadButton setBackgroundImage:[UIImage imageNamed:@"Download"] forState:UIControlStateNormal];
            self.downloadButton.enabled = YES;
            break;
            
        default:
            self.downloadButton.enabled = YES;
            self.deleteButton.enabled = NO;
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
    _linearProgressBar.progress = (float)progress/100;
}

//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    UIView *viewDelete = [self.deleteButton hitTest:[self.deleteButton convertPoint:point fromView:self] withEvent:event];
//    if (viewDelete == nil) {
//        viewDelete = [super hitTest:point withEvent:event];
//    }
//    return viewDelete;
//}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView != self) return hitView;
    return [self superview];
}

//-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    if ([super pointInside:point withEvent:event]) {
//        return YES;
//    }
//    //Check to see if it is within the delete button
//    return !self.deleteButton.hidden && [self.deleteButton pointInside:[self.deleteButton convertPoint:point fromView:self] withEvent:event];
//}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *v in self.subviews) {
        CGPoint localPoint = [v convertPoint:point fromView:self];
        if (v.alpha > 0.01 && ![v isHidden] && v.userInteractionEnabled && [v pointInside:localPoint withEvent:event])
            return YES;
    }
    return NO;
}
@end
