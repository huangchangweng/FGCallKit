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
 * 创建连接
 * @param username 用户名
 * @param password 密码
 */
- (BOOL)connectWithUsername:(NSString *)username
                   password:(NSString *)password
{
    NSString *domain = @"";
    NSString *server = @"";
    
    GSAccountConfiguration *account = [GSAccountConfiguration defaultConfiguration];
    account.address = [NSString stringWithFormat:@"%@@%@", username, domain];
    account.username = username;
    account.password = password;
    account.domain = domain;
    account.proxyServer = server;
    
    GSConfiguration *configuration = [GSConfiguration defaultConfiguration];
    configuration.account = account;
    configuration.logLevel = 3;
    configuration.consoleLogLevel = 3;
    configuration.transportType = GSUDPTransportType;
    
    GSUserAgent *agent = [GSUserAgent sharedAgent];
    [agent configure:configuration];
    BOOL flag = [agent start];
    
    if (!flag) {
        return NO;
    }
    
    GSAccount *acc = agent.account;
    acc.delegate = self;
    BOOL connect = [acc connect];
    
    [self addAccountKVO];
    return connect;
}

/**
 * 断开连接
 */
- (void)disconnect
{
    GSAccount *account = [GSUserAgent sharedAgent].account;
    if (!account) {
        return;
    }
    if (account.status != GSAccountStatusConnected) {
        return;
    }
    _accountStatus = FGAccountStatusOffline;
    if ([self.delegate respondsToSelector:@selector(callKit:statusDidChanged:)]) {
        [self.delegate callKit:self statusDidChanged:self.accountStatus];
    }
    [account disconnect];
}

/**
 * 重置
 */
- (BOOL)reset
{
    if ([GSUserAgent sharedAgent].account.status == GSAccountStatusConnecting) {
        return NO;
    }
    return [[GSUserAgent sharedAgent] reset];
}

/**
 * 拨号
 * @param number 呼出号码
 * @block 回调
 */
- (void)outgoingCall:(NSString *)number
               block:(FGCallKitOutgoingCallBlock)block
{
    NSString *domain = @"";
    
    GSAccount *account = [GSUserAgent sharedAgent].account;
    NSString *uri = [NSString stringWithFormat:@"sip:%@@%@", number, domain];
    GSCall *call = [GSCall outgoingCallToUri:uri fromAccount:account];
    
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
    AVAudioSessionCategoryOptions options = isHandfree ? AVAudioSessionCategoryOptionDefaultToSpeaker : AVAudioSessionCategoryOptionDuckOthers;
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
