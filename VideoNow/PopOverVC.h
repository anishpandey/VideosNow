//
//  PopOverVC.h
//  VideoNow
//
//  Created by Anish Kumar on 7/26/17.
//  Copyright © 2017 Anish Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VNEnums.h"

@protocol VideoNowPopDelegate;
@interface PopOverVC : UIViewController

@property (nonatomic, weak ) id <VideoNowPopDelegate> delegate;

@end

@protocol VideoNowPopDelegate <NSObject>
@optional
- (void)selectedType:(POP_ACTION)type;
@end
