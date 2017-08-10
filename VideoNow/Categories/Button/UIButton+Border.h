//
//  UIButton+Border.h
//  VideoNow
//
//  Created by Anish Kumar on 7/17/17.
//  Copyright © 2017 Anish Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Border)

- (void)addBottomBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;

- (void)addLeftBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;

- (void)addRightBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;

- (void)addTopBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;

@end
