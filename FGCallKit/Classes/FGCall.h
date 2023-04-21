//
//  FGCall.h
//  FGCallKit
//
//  Created by feige on 2023/3/29.
//

#import <Foundation/Foundation.h>
#import "GSCall.h"

/**
 * 通话状态
 */
typedef NS_ENUM(NSUInteger, FGCallStatus) {
    FGCallStatusReady,          ///< 准备
    FGCallStatusCalling,        ///< Call is ringing.
    FGCallStatusConnecting,     ///< 连接中
    FGCallStatusConnected,      ///< 已接通，声音已经传入
    FGCallStatusDisconnected,   ///< 呼叫中断(用户挂机/对方挂机)
};

@class FGCall;
@protocol FGCallDelegate <NSObject>
/**
 * 通话状态改变回调
 */
- (void)call:(FGCall *)call statusDidChanged:(FGCallStatus)status;
@end

@interface FGCall : NSObject
/// 是否静音
@property (nonatomic, assign, readonly) BOOL isMute;
/// 通话
@property (nonatomic, strong) GSCall *call;
/// 号码
@property (nonatomic, copy) NSString *number;
/// 状态
@property (nonatomic, readonly) FGCallStatus status;
/// 是否来电
@property (nonatomic, assign) BOOL isIncoming;
/// 代理
@property (nonatomic, weak) id<FGCallDelegate> delegate;

/**
 * 初始化
 */
- (instancetype)initWithCall:(GSCall *)call
                  isIncoming:(BOOL)isIncoming;

/**
 * 接听
 */
- (void)answer;

/**
 * 挂断
 */
- (void)hangup:(void(^)(BOOL succeed, NSString *msg))block;

/**
 * 开启/关闭静音
 * @param isMute 是否静音
 */
- (void)mute:(BOOL)isMute;

/**
 * 通话中途发送数字
 * @param digits 数字
 */
- (BOOL)sendDTMFDigits:(NSString *)digits;

@end
