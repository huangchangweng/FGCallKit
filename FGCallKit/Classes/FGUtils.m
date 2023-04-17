//
//  FGUtils.m
//  FGCallKit
//
//  Created by feige on 2023/4/17.
//

#import "FGUtils.h"
#import <CommonCrypto/CommonDigest.h>

@implementation FGUtils

/// 空字符串判断
+ (BOOL)isNullOrEmpty:(NSString *)str
{
    return str == nil
    || [str isEqual: (id)[NSNull null]]
    || [str isKindOfClass:[NSString class]] == NO
    || [@"" isEqualToString:str]
    || [[str stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0U
    || [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0U;
}

/// md5 加密
+ (NSString *)md5:(NSString *)str
{
    if (!str) return nil;
    
    const char *cStr = str.UTF8String;
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    NSMutableString *md5Str = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
        [md5Str appendFormat:@"%02x", result[i]];
    }
    return md5Str;
}

/// 当前时间戳（秒）
+ (NSString *)nowTimeTimestamp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];

    return timeSp;
}

@end
