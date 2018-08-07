//
//  Base32Addition.h
//  Mina_OTP_OC
//
//  Created by 武建明 on 2018/4/11.
//  Copyright © 2018年 Four_w. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NSBase32StringEncoding  0x4D467E32

@interface NSString (Base32Addition)
+(NSString *)stringFromBase32String:(NSString *)base32String;
-(NSString *)base32String;
@end

@interface NSData (Base32Addition)
+(NSData *)dataWithBase32String:(NSString *)base32String;
-(NSString *)base32String;
@end

@interface Base32Addition : NSObject

+(NSData *)dataFromBase32String:(NSString *)base32String;
+(NSString *)base32StringFromData:(NSData *)data;

@end
