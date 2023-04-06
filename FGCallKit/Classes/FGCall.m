//
//  FGCall.m
//  FGCallKit
//
//  Created by feige on 2023/3/29.
//

#import "FGCall.h"

#import <pjsip.h>
#import <pjsua-lib/pjsua.h>

@interface FGCall()
@property (nonatomic, assign) float micVolume;  ///< 麦克风音量
@end

@implementation FGCall

#pragma Life Cycle

- (void)dealloc {
    [self.call removeObserver:self forKeyPath:@"status"];
    self.call = nil;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        _status = (NSInteger)self.call.status;
        if ([self.delegate respondsToSelector:@selector(call:statusDidChanged:)]) {
            [self.delegate call:self statusDidChanged:self.status];
        }
    }
}

#pragma mark - Private Method

/**
 * 获取来电号码
 * @param callId 通话id
 */
+ (NSString *)incomingNumForCallId:(int)callId
{
    NSString *incomingNum = @"未知";
    
    // 获取通话信息
    pjsua_call_info ci;
    pjsua_call_get_info(callId, &ci);
    NSString *str = [NSString stringWithFormat:@"%s", ci.buf_.remote_info];
    
    incomingNum = [[[[str componentsSeparatedByString:@":"] lastObject] componentsSeparatedByString:@"@"] firstObject];
    
    return incomingNum;
}

- (void)setupNumber
{
    if (self.isIncoming) {
        self.number = [FGCall incomingNumForCallId:self.call.callId];
    } else {
        NSString *remoteUri = [self.call valueForKeyPath:@"remoteUri"];
        NSString *num = [[[[remoteUri componentsSeparatedByString:@":"] lastObject] componentsSeparatedByString:@"@"] firstObject];
        self.number = num;
    }
}

- (void)addCallKVO
{
    [self.call addObserver:self
                forKeyPath:@"status"
                   options:NSKeyValueObservingOptionInitial
                   context:nil];
}

#pragma mark - Public Method

/**
 * 初始化
 */
- (instancetype)initWithCall:(GSCall *)call
                  isIncoming:(BOOL)isIncoming
{
    if (self = [super init]) {
        _isMute = NO;
        _call = call;
        _status = FGCallStatusReady;
        _isIncoming = isIncoming;
        _micVolume = _call.micVolume;
        
        [self setupNumber];
        [self addCallKVO];
    }
    return self;
}

/**
 * 挂断
 */
- (void)hangup:(void(^)(BOOL succeed, NSString *msg))block
{
    if (self.call.status == GSCallStatusReady) {
        if (block) { block(NO, @"通话建立中，不能挂断！"); }
        return;
    }
    [self.call end];
    if (block) { block(YES, @"挂断成功！"); }
}

/**
 * 开启/关闭静音
 * @param isMute 是否静音
 */
- (void)mute:(BOOL)isMute
{
    _isMute = isMute;
    [self.call setMicVolume:isMute ? 0 : self.micVolume];
}

/**
 * 通话中途发送数字
 * @param digits 数字
 */
- (BOOL)sendDTMFDigits:(NSString *)digits
{
    return [self.call sendDTMFDigits:digits];
}

@end
