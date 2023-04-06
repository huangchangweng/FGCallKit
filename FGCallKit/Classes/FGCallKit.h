//
//  FGCallKit.h
//  FGCallKit
//
//  Created by feige on 2023/3/29.
//

#import <Foundation/Foundation.h>
#import <FGCall.h>

/**
 * 语音账号状态
 */
typedef NS_ENUM(NSUInteger, FGCallAccountStatus) {
    FGAccountStatusOffline,         ///< 离线
    FGAccountStatusInvalid,         ///< 失效
    FGAccountStatusConnecting,      ///< 连接中
    FGAccountStatusConnected,       ///< 已连接
    FGAccountStatusDisconnecting,   ///< 断开连接中
};

/// 呼出回调
typedef void (^FGCallKitOutgoingCallBlock)(BOOL succeed, NSString *msg, FGCall *call);

@class FGCallKit;
@protocol FGCallKitDelegate <NSObject>
/**
 * 收到来电回调
 * @param call 来电对象
 */
- (void)callKit:(FGCallKit *)callKit didReceiveIncomingCall:(FGCall *)call;
/**
 * 账号状态改变回调
 * @param status 状态
 */
- (void)callKit:(FGCallKit *)callKit statusDidChanged:(FGCallAccountStatus)status;
@end

@interface FGCallKit : NSObject
/// 语音账号状态
@property (nonatomic, assign, readonly) FGCallAccountStatus accountStatus;
/// 代理
@property (nonatomic, weak) id<FGCallKitDelegate> delegate;
/// 通话中是否免提
@property (nonatomic, assign, readonly) BOOL isHandfree;

/**
 * 单例
 */
+ (instancetype)sharedKit;

/**
 * 创建连接
 * @param username 用户名
 * @param password 密码
 */
- (BOOL)connectWithUsername:(NSString *)username
                   password:(NSString *)password;

/**
 * 断开连接
 */
- (void)disconnect;

/**
 * 重置
 */
- (BOOL)reset;

/**
 * 拨号
 * @param number 呼出号码
 * @block 回调
 */
- (void)outgoingCall:(NSString *)number
               block:(FGCallKitOutgoingCallBlock)block;

/**
 * 通话中开启/关闭免提
 * @param isHandfree 是否免提
 */
- (void)handfree:(BOOL)isHandfree;

@end
