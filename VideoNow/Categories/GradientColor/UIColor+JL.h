//
//  UIColor+Gradient.h
//  PerkWordSearch
//
//  Created by Anish Kumar on 27/07/15.
//  Copyright (c) 2015 Anish Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (JL)

+ (UIColor*) gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height;
+ (UIColor*) gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height withRadius:(CGFloat) radius;
@end
