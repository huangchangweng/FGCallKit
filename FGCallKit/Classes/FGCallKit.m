//
//  FGCallKit.m
//  FGCallKit
//
//  Created by feige on 2023/3/29.
//

#import "FGCallKit.h"

NSString * const FGCallKitAccountStatusChanged = @"FGCallKitAccountStatusChanged";

@interface FGCallKit()

@end

@implementation FGCallKit

#pragma Life Cycle

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark - Private Method


#pragma mark - Public Method

/**
 * 单例
 */
+ (instancetype)sharedKit
{
    static FGCallKit *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FGCallKit alloc] init];
    });
    return instance;
}

@end
