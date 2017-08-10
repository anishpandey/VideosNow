//
//  DownloadCell.h
//  VideosNow
//
//  Created by Anish Kumar on 8/2/17.
//  Copyright © 2017 Anish Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBCircularProgressBar/MBCircularProgressBarView.h>
#import <TYMProgressBarView/TYMProgressBarView.h>

@interface DownloadCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *videoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoDetailLabel;
@property (weak, nonatomic) IBOutlet MBCircularProgressBarView *progressBar;
@property (weak, nonatomic) IBOutlet TYMProgressBarView *linearProgressBar;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (void)setItem:(id)item;

@end
