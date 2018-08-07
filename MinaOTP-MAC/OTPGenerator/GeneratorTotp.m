//
//  GeneratorTotp.m
//  Mina_OTP_OC
//
//  Created by 武建明 on 2018/2/23.
//  Copyright © 2018年 Four_w. All rights reserved.
//

#import "GeneratorTotp.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import "Base32Addition.h"

static NSUInteger kPinModTable[] = {
    0,
    10,
    100,
    1000,
    10000,
    100000,
    1000000,
    10000000,
    100000000,
};

@implementation GeneratorTotp

+ (NSTimeInterval)defaultPeriod {
    return 30;
}
+ (NSString *)generateOTPForSecret:(NSString *)secret{

    CCHmacAlgorithm alg = kCCHmacAlgSHA1;
    NSUInteger hashLength = CC_SHA1_DIGEST_LENGTH;

    NSData *secretData =  [NSData dataWithBase32String:secret];

    NSDate *date = [NSDate date];
    NSLog(@"%@",date);
    NSTimeInterval seconds = [date timeIntervalSince1970];

    uint64_t counter = (uint64_t)(seconds / [self defaultPeriod]);

    counter = NSSwapHostLongLongToBig(counter);
    NSData *counterData = [NSData dataWithBytes:&counter
                                         length:sizeof(counter)];

    NSMutableData *hash = [NSMutableData dataWithLength:hashLength];
    CCHmacContext ctx;
    CCHmacInit(&ctx, alg, [secretData bytes], [secretData length]);
    CCHmacUpdate(&ctx, [counterData bytes], [counterData length]);
    CCHmacFinal(&ctx, [hash mutableBytes]);
    const char *ptr = [hash bytes];
    unsigned char offset = ptr[hashLength-1] & 0x0f;

    uint32_t truncatedHash =
    NSSwapBigIntToHost(*((uint32_t *)&ptr[offset])) & 0x7fffffff;
    uint32_t pinValue = truncatedHash % kPinModTable[6];

    NSString *str = [NSString stringWithFormat:@"%0*u", (int)6, pinValue];;

    while (str.length < 6) {
        str = [NSString stringWithFormat:@"0%@",str];
    }
    return str;
}
@end
