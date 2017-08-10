//
//  MBCircularProgressBarLayer.h
//  MBCircularProgressBar
//
//  Created by Mati Bot on 7/9/15.
//  Copyright (c) 2015 Mati Bot All rights reserved.
//

@import QuartzCore;
#import "GradientBorderLayer.h"

@interface MBCircularProgressBarLayer : GradientBorderLayer

@property (nonatomic,assign) CGFloat progressAngle;
@property (nonatomic,assign) CGFloat progressRotationAngle;
@property (nonatomic,assign) CGFloat percent;
@property (nonatomic,strong) UIColor* fontColor;

@property (nonatomic,assign) CGFloat progressLineWidth;
@property (nonatomic,strong) UIColor* progressColor;
@property (nonatomic,strong) UIColor* progressStrokeColor;
@property (nonatomic,assign) CGLineCap progressCapType;

@property (nonatomic,assign) CGFloat emptyLineWidth;
@property (nonatomic,assign) CGLineCap emptyCapType;
@property (nonatomic,strong) UIColor* emptyLineColor;

@property (nonatomic, strong) AngleGradientLayer *tempLayer;

//@property(copy) NSArray *colors;

/* An optional array of NSNumber objects defining the location of each
 * gradient stop as a value in the range [0,1]. The values must be
 * monotonically increasing. If a nil array is given, the stops are
 * assumed to spread uniformly across the [0,1] range. When rendered,
 * the colors are mapped to the output colorspace before being
 * interpolated. Defaults to nil. */

//@property(copy) NSArray *locations;


/* The core method generating gradient image.
 */
+ (CGImageRef)newImageGradientInRect:(CGRect)rect colors:(NSArray *)colors locations:(NSArray *)locations;
@end
