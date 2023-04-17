//
//  FGUtils.h
//  FGCallKit
//
//  Created by feige on 2023/4/17.
//

#import <Foundation/Foundation.h>

@interface FGUtils : NSObject

/// 空字符串判断
+ (BOOL)isNullOrEmpty:(NSString *)str;

/// md5 加密
+ (NSString *)md5:(NSString *)str;

/// 当前时间戳（秒）
+ (NSString *)nowTimeTimestamp;

@end
