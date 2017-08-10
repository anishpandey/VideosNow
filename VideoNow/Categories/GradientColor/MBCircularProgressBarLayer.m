//
//  MBCircularProgressBarLayer.m
//  MBCircularProgressBar
//
//  Created by Mati Bot on 7/9/15.
//  Copyright (c) 2015 Mati Bot All rights reserved.
//

@import UIKit;
@import CoreGraphics;

#import "MBCircularProgressBarLayer.h"
#import "UIColor+JL.h"

#import <QuartzCore/QuartzCore.h>

#if __has_feature(objc_arc)
#define BRIDGE_CAST(T) (__bridge T)
#else
#define BRIDGE_CAST(T) (T)
#endif

#define byte unsigned char
#define F2CC(x) ((byte)(255 * x))
#define RGBAF(r,g,b,a) (F2CC(r) << 24 | F2CC(g) << 16 | F2CC(b) << 8 | F2CC(a))
#define RGBA(r,g,b,a) ((byte)r << 24 | (byte)g << 16 | (byte)b << 8 | (byte)a)
#define RGBA_R(c) ((uint)c >> 24 & 255)
#define RGBA_G(c) ((uint)c >> 16 & 255)
#define RGBA_B(c) ((uint)c >> 8 & 255)
#define RGBA_A(c) ((uint)c >> 0 & 255)

@implementation MBCircularProgressBarLayer
@dynamic percent;
@dynamic progressLineWidth;
@dynamic progressColor;
@dynamic progressStrokeColor;
@dynamic emptyLineWidth;
@dynamic progressAngle;
@dynamic emptyLineColor;
@dynamic emptyCapType;
@dynamic progressCapType;
@dynamic fontColor;
@dynamic progressRotationAngle;

static void angleGradient(byte* data, int w, int h, int* colors, int colorCount, float* locations, int locationCount);

#pragma mark - Drawing

- (id)init
{
    if (!(self = [super init]))
        return nil;
    
    self.needsDisplayOnBoundsChange = YES;
    
    return self;
}

- (void) drawInContext:(CGContextRef) context{
    [super drawInContext:context];

    UIGraphicsPushContext(context);
    
    CGSize size = CGRectIntegral(CGContextGetClipBoundingBox(context)).size;
    [self drawEmptyBar:size context:context];
    [self drawProgressBar:size context:context];
    //[self drawText:size context:context];
    
    UIGraphicsPopContext();
    

}

- (void)drawEmptyBar:(CGSize)rectSize context:(CGContextRef)c{
    CGMutablePathRef arc = CGPathCreateMutable();
    
    CGPathAddArc(arc, NULL,
                 rectSize.width/2, rectSize.height/2,
                 MIN(rectSize.width,rectSize.height)/2 - self.progressLineWidth,
                 (self.progressAngle/100.f)*M_PI-((self.progressRotationAngle/100.f)*2.f+0.5)*M_PI,
                 -(self.progressAngle/100.f)*M_PI-((self.progressRotationAngle/100.f)*2.f+0.5)*M_PI,
                 YES);
    

    CGPathRef strokedArc =
    CGPathCreateCopyByStrokingPath(arc, NULL,
                                   self.emptyLineWidth,
                                   (CGLineCap)self.emptyCapType,
                                   kCGLineJoinMiter,
                                   10);
    
    
    CGContextAddPath(c, strokedArc);
    CGContextSetStrokeColorWithColor(c, self.emptyLineColor.CGColor);
    CGContextSetFillColorWithColor(c, self.emptyLineColor.CGColor);
    CGContextDrawPath(c, kCGPathFillStroke);
}

- (void)drawProgressBar:(CGSize)rectSize context:(CGContextRef)c{
    
    CGMutablePathRef arc = CGPathCreateMutable();
    
    CGPathAddArc(arc, NULL,
                 rectSize.width/2, rectSize.height/2,
                 MIN(rectSize.width,rectSize.height)/2 - self.progressLineWidth,
                 (self.progressAngle/100.f)*M_PI-((self.progressRotationAngle/100.f)*2.f+0.5)*M_PI-(2.f*M_PI)*(self.progressAngle/100.f)*(100.f-self.percent)/100.f,
                 -(self.progressAngle/100.f)*M_PI-((self.progressRotationAngle/100.f)*2.f+0.5)*M_PI,
                 YES);
    
    CGPathRef strokedArc =
    CGPathCreateCopyByStrokingPath(arc, NULL,
                                   self.progressLineWidth,
                                   (CGLineCap)self.progressCapType,
                                   kCGLineJoinMiter,
                                   10);
    
    
    CGContextAddPath(c, strokedArc);
   // CGContextSetFillColorWithColor(c, self.progressColor.CGColor);
    //CGContextSetStrokeColorWithColor(c, self.progressStrokeColor.CGColor);
    
    
    
 

//    CGFloat tempradius =  MIN(rectSize.width,rectSize.height)/2 - self.progressLineWidth;
    CGContextAddPath(c, strokedArc);
    CGContextSetFillColorWithColor(c, [UIColor gradientFromColor:[UIColor colorWithRed:255.0/255.0 green:120.0/255.0  blue:139.0/255.0 alpha:1] toColor:[UIColor colorWithRed:234.0/255.0 green:204.0/255.0  blue:095.0/255.0 alpha:1] withHeight:rectSize.height withRadius:rectSize.height].CGColor);
    CGContextSetStrokeColorWithColor(c, self.progressStrokeColor.CGColor);
    
    //CGContextDrawPath(c, kCGPathFillStroke);
    

    
    
    
    NSMutableArray *colors = [[NSMutableArray alloc] initWithCapacity:4];
    
    [colors addObject:(id)[UIColor colorWithRed:1 green:0 blue:0 alpha:1].CGColor];
    [colors addObject:(id)[UIColor colorWithRed:1 green:1 blue:0 alpha:1].CGColor];

    //AngleGradientLayer *l = (AngleGradientLayer *)self.layer;
    //AngleGradientLayer* layer = (AngleGradientLayer*) _tempLayer;
//    self.contentsScale = [UIScreen mainScreen].scale;
//    self.colors = colors;
//    self.gradientBorderWidth = 15;
    
    CGContextDrawPath(c, kCGPathFillStroke);
    
}

- (void)drawText:(CGSize)rectSize context:(CGContextRef)c
{
    NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
    textStyle.alignment = NSTextAlignmentLeft;
    
    NSDictionary* percentFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-Thin" size:rectSize.height/5], NSForegroundColorAttributeName: self.fontColor, NSParagraphStyleAttributeName: textStyle};
    
    NSString* percentText = [NSString stringWithFormat:@"%.f%%",self.percent];
    
    CGSize percentSize = [percentText sizeWithAttributes:percentFontAttributes];
  
    [percentText drawAtPoint:CGPointMake(rectSize.width/2-percentSize.width/2,
                                         rectSize.height/2-percentSize.height/2)
              withAttributes:percentFontAttributes];
    
}

#pragma mark - Override methods to support animations

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"percent"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (id<CAAction>)actionForKey:(NSString *)event{
    if ([self presentationLayer] != nil) {
        if ([event isEqualToString:@"percent"]) {
            CABasicAnimation *anim = [CABasicAnimation
                                      animationWithKeyPath:@"percent"];
            anim.fromValue = [[self presentationLayer]
                              valueForKey:@"percent"];
            anim.duration = [[CATransaction valueForKey:@"animationDuration"] floatValue];
            return anim;
        }
    }
    
    return [super actionForKey:event];
}




- (CGImageRef)newImageGradientInRect:(CGRect)rect
{
    return [[self class] newImageGradientInRect:rect colors:self.colors locations:self.locations];
}

+ (CGImageRef)newImageGradientInRect:(CGRect)rect colors:(NSArray *)colors locations:(NSArray *)locations
{
    int w = CGRectGetWidth(rect);
    int h = CGRectGetHeight(rect);
    int bitsPerComponent = 8;
    int bpp = 4 * bitsPerComponent / 8;
    int byteCount = w * h * bpp;
    
    int colorCount = (int)colors.count;
    int locationCount = (int)locations.count;
    int* cols = NULL;
    float* locs = NULL;
    
    if (colorCount > 0) {
        cols = calloc(colorCount, bpp);
        int *p = cols;
        for (id cg in colors) {
            CGColorRef c = BRIDGE_CAST(CGColorRef)cg;
            float r, g, b, a;
            
            size_t n = CGColorGetNumberOfComponents(c);
            const CGFloat *comps = CGColorGetComponents(c);
            if (comps == NULL) {
                *p++ = 0;
                continue;
            }
            r = comps[0];
            if (n >= 4) {
                g = comps[1];
                b = comps[2];
                a = comps[3];
            }
            else {
                g = b = r;
                a = comps[1];
            }
            *p++ = RGBAF(r, g, b, a);
        }
    }
    if (locationCount > 0 && locationCount == colorCount) {
        locs = calloc(locationCount, sizeof(locs[0]));
        float *p = locs;
        for (NSNumber *n in locations) {
            *p++ = [n floatValue];
        }
    }
    
    byte* data = malloc(byteCount);
    angleGradient(data, w, h, cols, colorCount, locs, locationCount);
    
    if (cols) free(cols);
    if (locs) free(locs);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Little;
    CGContextRef ctx = CGBitmapContextCreate(data, w, h, bitsPerComponent, w * bpp, colorSpace, bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    CGImageRef img = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    free(data);
    return img;
}



static inline byte blerp(byte a, byte b, float w)
{
    return a + w * (b - a);
}
static inline int lerp(int a, int b, float w)
{
    return RGBA(blerp(RGBA_R(a), RGBA_R(b), w),
                blerp(RGBA_G(a), RGBA_G(b), w),
                blerp(RGBA_B(a), RGBA_B(b), w),
                blerp(RGBA_A(a), RGBA_A(b), w));
}
static inline int multiplyByAlpha(int c)
{
    float a = RGBA_A(c) / 255.0;
    return RGBA((byte)(RGBA_R(c) * a),
                (byte)(RGBA_G(c) * a),
                (byte)(RGBA_B(c) * a),
                RGBA_A(c));
}

void angleGradient(byte* data, int w, int h, int* colors, int colorCount, float* locations, int locationCount)
{
    if (colorCount < 1) return;
    if (locationCount > 0 && locationCount != colorCount) return;
    
    int* p = (int*)data;
    float centerX = (float)w / 2;
    float centerY = (float)h / 2;
    
    for (int y = 0; y < h; y++)
        for (int x = 0; x < w; x++) {
            float dirX = x - centerX;
            float dirY = y - centerY;
            float angle = atan2f(dirY, dirX);
            if (dirY < 0) angle += 2 * M_PI;
            angle /= 2 * M_PI;
            
            int index = 0, nextIndex = 0;
            float t = 0;
            
            if (locationCount > 0) {
                for (index = locationCount - 1; index >= 0; index--) {
                    if (angle >= locations[index]) {
                        break;
                    }
                }
                if (index >= locationCount) index = locationCount - 1;
                nextIndex = index + 1;
                if (nextIndex >= locationCount) nextIndex = locationCount - 1;
                float ld = locations[nextIndex] - locations[index];
                t = ld <= 0 ? 0 : (angle - locations[index]) / ld;
            }
            else {
                t = angle * (colorCount - 1);
                index = t;
                t -= index;
                nextIndex = index + 1;
                if (nextIndex >= colorCount) nextIndex = colorCount - 1;
            }
            
            int lc = colors[index];
            int rc = colors[nextIndex];
            int color = lerp(lc, rc, t);
            color = multiplyByAlpha(color);
            *p++ = color;
        }
}

@end
