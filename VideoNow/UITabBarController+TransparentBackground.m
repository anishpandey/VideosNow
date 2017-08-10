//
//  UITabBarController+TransparentBackground.m
//  VideoNow
//
//  Created by Anish Kumar on 7/18/17.
//  Copyright © 2017 Anish Kumar. All rights reserved.
//

#import "UITabBarController+TransparentBackground.h"

@implementation UITabBarController (TransparentBackground)

- (void) setBackgroundImage:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,480)];
    imageView.backgroundColor = [UIColor colorWithPatternImage:image];
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
    [self.view setOpaque:NO];
    [self.view setBackgroundColor:[UIColor clearColor]];
}

@end
