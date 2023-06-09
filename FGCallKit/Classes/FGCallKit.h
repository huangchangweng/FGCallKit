//
//  FGCallKit.h
//  FGCallKit
//
//  Created by feige on 2023/3/29.
//

#import <Foundation/Foundation.h>
#import "FGCall.h"

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
/// 通用回调
typedef void (^FGCallKitCommonCallBlock)(NSInteger code, NSString *msg, id data);

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
/**
 * 登录信息失效，收到此回调需重新登录SDK
 */
- (void)callKitLoginInvalid;
@end

@interface FGCallKit : NSObject
/// 语音账号状态
@property (nonatomic, assign, readonly) FGCallAccountStatus accountStatus;
/// 代理
@property (nonatomic, weak) id<FGCallKitDelegate> delegate;
/// 通话中是否免提，默认NO
@property (nonatomic, assign, readonly) BOOL isHandfree;
/// 是否测试环境，默认NO（注：该属性一般不设置）
@property (nonatomic, assign) BOOL isTest;

/**
 * 单例
 */
+ (instancetype)sharedKit;

/**
 * 登录
 * @param apiKey    平台申请的key
 * @param apiSecret 平台申请的secret
 * @param username  用户名
 * @param callBlock 回调
 */
- (void)login:(NSString *)apiKey
    apiSecret:(NSString *)apiSecret
     username:(NSString *)username
    callBlock:(FGCallKitCommonCallBlock)callBlock;

/**
 * 退出登录
 * @param callBlock 回调
 */
- (void)logout:(FGCallKitCommonCallBlock)callBlock;

/**
 * 拨号
 * @param number 呼出号码
 * @block 回调
 */
- (void)outgoingCall:(NSString *)number
               block:(FGCallKitOutgoingCallBlock)block;

/**
 * 查询是否有来电
 * 因为如果应用退到后台是接收不到来电的，所以需要在应用进入前台时查询一下是否有来电
 * 注：该方法建议在以下方法中调用
 * - (void)applicationDidBecomeActive:(UIApplication *)application
 * 如果有来电会回调"- (void)callKit:(FGCallKit *)callKit didReceiveIncomingCall:(FGCall *)call"方法
 */
- (void)queryHaveIncoming;

/**
 * 通话中开启/关闭免提
 * @param isHandfree 是否免提
 */
- (void)handfree:(BOOL)isHandfree;

@end
