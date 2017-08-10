//
//  UIFont+JL.m
//  VideoNow
//
//  Created by Anish Kumar on 7/17/17.
//  Copyright © 2017 Anish Kumar. All rights reserved.
//

#import "UIFont+JL.h"

@implementation UIFont (JL)


+(UIFont*)fontHelsinkiRegulartWithSize:(float)size
{
    return [UIFont fontWithName:@"Helsinki" size:size];
}

+(UIFont*)fontRobotoMediunWithSize:(float)size
{
    return [UIFont fontWithName:@"Roboto-Medium" size:size];
}

+(UIFont*)fontAlegreyaSansRegularWithSize:(float)size
{
    return [UIFont fontWithName:@"AlegreyaSans-Medium" size:size];
}

+(UIFont*)fontArialMTWithSize:(float)size
{
    return [UIFont fontWithName:@"ArialMT" size:size];
}

+(UIFont*)fontHelveticaMediumwithSize:(float)size;
{
    return [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
}

+(UIFont*)fontHelveticaWithSize:(float)size
{
    return [UIFont fontWithName:@"HelveticaNeue" size:size];
}

+(UIFont*)fontHelveticaNeueLightWithSize:(float)size
{
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
}

+(UIFont*)fontHelveticaNeueBoldWithSize:(float)size
{
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];
}

+(UIFont*)fontEffraBoldWithSize:(float)size
{
     return [UIFont fontWithName:@"Effra-Bold" size:size];
}

+(UIFont*)fontEffraMediumWithSize:(float)size
{
    return [UIFont fontWithName:@"Effra-Medium" size:size];
}
+(UIFont*)fontEffraRegularWithSize:(float)size
{
    return [UIFont fontWithName:@"Effra-Regular" size:size];
}
+(UIFont*)fontEffraLightWithSize:(float)size
{
    return [UIFont fontWithName:@"Effra-Light" size:size];
}

@end
