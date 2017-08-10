//
//  SettingsCell.h
//  VideoNow
//
//  Created by Anish Kumar on 7/21/17.
//  Copyright © 2017 Anish Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANStepperView.h"

@interface SettingsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *settingsTitle;
@property (weak, nonatomic) IBOutlet UILabel *settingsLabel;
@property (weak, nonatomic) IBOutlet ANStepperView *settingsStepper;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end
