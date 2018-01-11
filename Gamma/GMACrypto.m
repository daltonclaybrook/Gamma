//
//  GMACrypto.m
//  Gamma
//
//  Created by Dalton Claybrook on 1/8/18.
//  Copyright © 2018 Dalton Claybrook. All rights reserved.
//

#import <CommonCrypto/CommonCrypto.h>
#import "GMACrypto.h"

@implementation GMACrypto

+ (NSString *)sha1HashOfData:(const char *)data length:(unsigned int)length
{
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data, length, digest);
    NSMutableString *output = [[NSMutableString alloc] initWithCapacity:CC_SHA1_DIGEST_LENGTH];
    for (NSUInteger i=0; i<CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    return [output copy];
}

@end
