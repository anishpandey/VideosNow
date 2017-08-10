//
//  NSString+HMACString.m
//  VideoNow
//
//  Created by Anish Kumar on 7/17/17.
//  Copyright © 2017 Anish Kumar. All rights reserved.
//

#import "NSString+HMACString.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (HMACString)

- (NSString *) getHMACString {

    NSData *saltData = [HMAC_SALT dataUsingEncoding:NSUTF8StringEncoding];
    NSData *paramData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData* hash = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH ];
    CCHmac(kCCHmacAlgSHA256, saltData.bytes, saltData.length, paramData.bytes, paramData.length, hash.mutableBytes);
    
    NSString *base64Hash = [self hexadecimalStringWithData:hash];
    
    /*if ([hash respondsToSelector:@selector(base64EncodedDataWithOptions:)]) {
        
        base64Hash = [hash base64EncodedStringWithOptions:0];
        
    }else if ([hash respondsToSelector:@selector(base64Encoding)]){
    
        base64Hash = [hash base64Encoding];
    }*/
	//NSLog(@"============ %s ====================== %@ ", __FUNCTION__, base64Hash);
    return base64Hash;
}

- (NSString *)hexadecimalStringWithData:(NSData *) hash {
    
    const unsigned char *dataBuffer = (const unsigned char *)[hash bytes];
    
    if (!dataBuffer)
        return [NSString string];
    
    NSUInteger          dataLength  = [hash length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    
    return [NSString stringWithString:hexString];
}

@end
