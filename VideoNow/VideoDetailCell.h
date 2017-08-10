//
//  VideoDetailCell.h
//  VideoNow
//
//  Created by Anish Kumar on 7/19/17.
//  Copyright © 2017 Anish Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *videoDetailImageView;
@property (weak, nonatomic) IBOutlet UIButton *videoDetailButton;
@property (weak, nonatomic) IBOutlet UILabel *videoDetailTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoDetailDetailedLabel;
@property (weak, nonatomic) IBOutlet UIButton *videoPopUpButton;
@end
