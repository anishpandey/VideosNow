//
//  GradientBorderLayer.m
//  GardientBorder
//
//  Created by Anish Kumar on 04/08/15.
//  Copyright (c) 2015 Anish Kumar. All rights reserved.
//

#import "GradientBorderLayer.h"



@implementation GradientBorderLayer


-(void) drawInContext:(CGContextRef)ctx
{
    UIBezierPath* shapePath = [UIBezierPath bezierPathWithRoundedRect: CGRectInset(self.bounds, _gradientBorderWidth, _gradientBorderWidth) cornerRadius: self.bounds.size.height/2];
    

    CGPathRef shapeCopyPath = CGPathCreateCopyByStrokingPath(shapePath.CGPath, NULL, _gradientBorderWidth, kCGLineCapButt, kCGLineJoinBevel, 0);
    
    CGContextSaveGState(ctx);
    
    // Add the stroked path to the context and clip to it.
    CGContextAddPath(ctx, shapeCopyPath);
    CGContextClip(ctx);
    
    
    // Call our super class's (AngleGradientLayer) #drawInContext
    // which will do the work to create the gradient.
    [super drawInContext:ctx];
    
    CGContextRestoreGState(ctx);
}
@end
