//
//  GeneratorTotp.h
//  Mina_OTP_OC
//
//  Created by 武建明 on 2018/2/23.
//  Copyright © 2018年 Four_w. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeneratorTotp : NSObject

+ (NSString *)generateOTPForSecret:(NSString *)secret;

@end
