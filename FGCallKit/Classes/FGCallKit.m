//
//  FGCallKit.m
//  FGCallKit
//
//  Created by feige on 2023/3/29.
//

#import "FGCallKit.h"
#import <AVFoundation/AVFoundation.h>
#import "GSUserAgent.h"

NSString * const FGCallKitAccountStatusChanged = @"FGCallKitAccountStatusChanged";

@interface FGCallKit()

@end

@implementation FGCallKit

#pragma Life Cycle

- (instancetype)init {
    if (self = [super init]) {
        [self bulid];
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark - Private Method

- (void)bulid
{
    _accountStatus = (NSInteger)[GSUserAgent sharedAgent].account.status;
    _isHandfree = [AVAudioSession sharedInstance].categoryOptions == AVAudioSessionCategoryOptionDefaultToSpeaker;
}

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

/**
 * 拨号
 * @param number 呼出号码
 * @block 回调
 */
- (void)outgoingCall:(NSString *)number
               block:(FGCallKitOutgoingCallBlock)block
{
    
}

/**
 * 通话中开启/关闭免提
 * @param isHandfree 是否免提
 */
- (void)handfree:(BOOL)isHandfree
{
    AVAudioSessionCategoryOptions options = isHandfree ? AVAudioSessionCategoryOptionDefaultToSpeaker : AVAudioSessionCategoryOptionDuckOthers;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord
                                         withOptions:options
                                               error:nil];
    });
    _isHandfree = isHandfree;
}

@end
