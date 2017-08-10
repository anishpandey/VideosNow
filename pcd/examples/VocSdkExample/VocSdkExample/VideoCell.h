//
//  VideoCell.h
//  VocSdkExample
//
//  Created by Yadhu Manoharan on 7/6/17.
//  Copyright © 2017 Akamai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UILabel *info;
@property (weak, nonatomic) IBOutlet UILabel *info2;
@property (weak, nonatomic) IBOutlet UILabel *progress;

- (void)setItem:(id)item;

@end
