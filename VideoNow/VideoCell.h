//
//  VideoCell.h
//  VideoNow
//
//  Created by Anish Kumar on 7/17/17.
//  Copyright © 2017 Anish Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModelArray.h"

@interface VideoCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *videoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoDetailLabel;
@property (weak, nonatomic) IBOutlet UIButton *videoDownloadButton;

- (void)populateModel:(VideoModelArray*)model;

@end
