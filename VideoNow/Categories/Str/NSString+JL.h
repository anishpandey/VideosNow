//
//  NSString+JL.h
//  VideoNow
//
//  Created by Anish Kumar on 7/17/17.
//  Copyright © 2017 Anish Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JL)

@property (nonatomic, readonly) NSString *reversedString;

- (BOOL)containsString:(NSString *)string;
- (BOOL)containsString:(NSString *)string
               options:(NSStringCompareOptions)options;

@end
