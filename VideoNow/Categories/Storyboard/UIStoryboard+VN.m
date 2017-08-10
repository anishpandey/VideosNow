//
//  UIStoryboard+VN.m
//  VideoNow
//
//  Created by Anish Kumar on 7/17/17.
//  Copyright © 2017 Anish Kumar. All rights reserved.
//

#import "UIStoryboard+VN.h"

@implementation UIStoryboard (VN)

+ (id) mainStoryBoard
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return storyBoard;
}

@end
