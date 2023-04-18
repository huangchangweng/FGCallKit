//
//  FGCallKit.m
//  FGCallKit
//
//  Created by feige on 2023/3/29.
//

#import "FGCallKit.h"
#import <AVFoundation/AVFoundation.h>
#import "GSUserAgent.h"
#import "FGHttpManager.h"
#import "FGUtils.h"
#import "FGKitInfo.h"
#import "FGAccountInfoModel.h"
#import <MJExtension/MJExtension.h>

@interface FGCallKit()<GSAccountDelegate>

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
    GSAccount *account = [GSUserAgent sharedAgent].account;
    [account removeObserver:self forKeyPath:@"status"];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        _accountStatus = (NSInteger)[GSUserAgent sharedAgent].account.status;
        if ([self.delegate respondsToSelector:@selector(callKit:statusDidChanged:)]) {
            [self.delegate callKit:self statusDidChanged:self.accountStatus];
        }
    }
}

#pragma mark - Private Method

- (void)bulid
{
    _accountStatus = (NSInteger)[GSUserAgent sharedAgent].account.status;
    _isHandfree = [AVAudioSession sharedInstance].categoryOptions == AVAudioSessionCategoryOptionDefaultToSpeaker;
}

- (void)addAccountKVO
{
    GSAccount *account = [GSUserAgent sharedAgent].account;
    [account addObserver:self
              forKeyPath:@"status"
                 options:NSKeyValueObservingOptionInitial
                 context:nil];
}

/// 获取账号信息
- (void)getAccountInfo:(FGCallKitCommonCallBlock)callBlock
{
    [FGHttpManager request:POST
                    method:@"/Account/GetAccountInfo"
                parameters:nil
                   success:^(BOOL succeed, NSString *msg, NSInteger code, id data) {
        if (succeed) {
            FGAccountInfoModel *model = [FGAccountInfoModel mj_objectWithKeyValues:data];
            [FGKitInfo shared].accountInfo = model;
            
            // 登录SIP
            [self loginSIP];
            
            if (callBlock) { callBlock(200, @"登录成功", nil); }
        } else {
            if (callBlock) { callBlock(code, msg, nil); }
        }
    } failure:^(NSError *error) {
        if (callBlock) { callBlock(501, @"服务器或网络出错", nil); }
    }];
}

/// 登录SIP
- (void)loginSIP
{
    FGUserModel *model = [FGKitInfo shared].accountInfo.userInfo;
    
    NSString *username = model.extensionUserName;
    NSString *password = model.extensionPassword;
    NSString *domain = [NSString stringWithFormat:@"%@.feige.cn", [FGKitInfo shared].accountInfo.companyInfo.id];
    NSString *server = [NSString stringWithFormat:@"%@:%ld", model.ip, model.tcpPort];
    
    GSAccountConfiguration *account = [GSAccountConfiguration defaultConfiguration];
    account.address = [NSString stringWithFormat:@"%@@%@", username, domain];
    account.username = username;
    account.password = password;
    account.domain = domain;
    account.proxyServer = server;
    account.enableRingback = NO;
    
    GSConfiguration *configuration = [GSConfiguration defaultConfiguration];
    configuration.account = account;
    configuration.logLevel = 3;
    configuration.consoleLogLevel = 3;
    configuration.transportType = GSUDPTransportType;
    
    GSUserAgent *agent = [GSUserAgent sharedAgent];
    [agent configure:configuration];
    BOOL flag = [agent start];
    
    if (!flag) {
        return;
    }
    
    GSAccount *acc = agent.account;
    acc.delegate = self;
    BOOL connect = [acc connect];
    if (!connect) {
        NSLog(@"语音连接失败！");
    }
    
    [self addAccountKVO];
}

/// 销毁SIP
- (void)resetSIP
{
    if ([GSUserAgent sharedAgent].account.status == GSAccountStatusConnecting) {
        return;
    }
    [[GSUserAgent sharedAgent] reset];
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
 * 登录
 * @param apiKey    平台申请的key
 * @param apiSecret 平台申请的secret
 * @param username  用户名
 * @param callBlock 回调
 */
- (void)login:(NSString *)apiKey
    apiSecret:(NSString *)apiSecret
     username:(NSString *)username
    callBlock:(FGCallKitCommonCallBlock)callBlock
{
    if ([FGUtils isNullOrEmpty:apiKey] ||
        [FGUtils isNullOrEmpty:apiSecret] ||
        [FGUtils isNullOrEmpty:username]) {
        if (callBlock) { callBlock(500, @"apiKey、apiSecret、username不能为空", nil); }
        return;
    }
    
    NSString *nowTimeTimestamp = [FGUtils nowTimeTimestamp];
    NSString *sign = [FGUtils md5:[NSString stringWithFormat:@"%@%@%@%@", apiKey, username, nowTimeTimestamp, apiSecret]];
    NSDictionary *parameters = @{@"apiKey": apiKey,
                                 @"userName": username,
                                 @"timestamp": nowTimeTimestamp,
                                 @"sign": sign
    };
    [FGHttpManager request:POST
                    method:@"/api/User/SDKLogin"
                parameters:parameters
                   success:^(BOOL succeed, NSString *msg, NSInteger code, id data) {
        if (succeed) {
            NSString *tokenType = data[@"tokenType"];
            NSString *token = data[@"token"];
            [FGKitInfo shared].tokenType = tokenType;
            [FGKitInfo shared].token = token;
            
            // 获取账号信息
            [self getAccountInfo:callBlock];
        } else {
            if (callBlock) { callBlock(code, msg, nil); }
        }
    } failure:^(NSError *error) {
        if (callBlock) { callBlock(501, @"服务器或网络出错", nil); }
    }];
}

/**
 * 退出登录
 * @param callBlock 回调
 */
- (void)logout:(FGCallKitCommonCallBlock)callBlock
{
    [FGHttpManager request:POST
                    method:@"/api/User/Logout"
                parameters:nil
                   success:^(BOOL succeed, NSString *msg, NSInteger code, id data) {
        if (succeed) {
            // 销魂SIP
            [self resetSIP];
            // 清除登录信息
            [[FGKitInfo shared] clearLoginInfo];
            
            if (callBlock) { callBlock(300, @"退出登录成功", nil); }
        } else {
            if (callBlock) { callBlock(code, msg, nil); }
        }
    } failure:^(NSError *error) {
        if (callBlock) { callBlock(501, @"服务器或网络出错", nil); }
    }];
}

/**
 * 拨号
 * @param number 呼出号码
 * @block 回调
 */
- (void)outgoingCall:(NSString *)number
               block:(FGCallKitOutgoingCallBlock)block
{
    NSString *domain = [NSString stringWithFormat:@"%@.feige.cn", [FGKitInfo shared].accountInfo.companyInfo.id];
    
    GSAccount *account = [GSUserAgent sharedAgent].account;
    NSString *uri = [NSString stringWithFormat:@"sip:%@@%@", number, domain];
    GSCall *call = [GSCall outgoingCallToUri:uri fromAccount:account];
    [call begin];
    
    FGCall *fgCall = [[FGCall alloc] initWithCall:call isIncoming:NO];
    if (block) {
        block(YES, @"成功！", fgCall);
    }
}

/**
 * 通话中开启/关闭免提
 * @param isHandfree 是否免提
 */
- (void)handfree:(BOOL)isHandfree
{
    AVAudioSessionCategoryOptions options = isHandfree ? AVAudioSessionCategoryOptionDefaultToSpeaker : AVAudioSessionCategoryOptionAllowBluetooth;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord
                                         withOptions:options
                                               error:nil];
    });
    _isHandfree = isHandfree;
}

#pragma mark - GSAccountDelegate

- (void)account:(GSAccount *)account didReceiveIncomingCall:(GSCall *)call
{
    FGCall *fgCall = [[FGCall alloc] initWithCall:call isIncoming:YES];
    if ([self.delegate respondsToSelector:@selector(callKit:didReceiveIncomingCall:)]) {
        [self.delegate callKit:self didReceiveIncomingCall:fgCall];
    }
}

@end
