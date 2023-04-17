//
//  FGKitInfo.m
//  FGCallKit
//
//  Created by feige on 2023/4/17.
//

#import "FGKitInfo.h"

static NSString *const kTokenTypeKey = @"kTokenTypeKey";
static NSString *const kTokenKey = @"kTokenKey";

@interface FGKitInfo()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@end

@implementation FGKitInfo

+ (instancetype)shared {
    static FGKitInfo *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FGKitInfo alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
        
        _tokenType = [_userDefaults objectForKey:kTokenTypeKey];
        _token = [_userDefaults objectForKey:kTokenKey];
    }
    return self;
}

/// 退出登录
- (void)clearLoginInfo
{
    self.tokenType = nil;
    self.token = nil;
}

#pragma mark - Getters & Setters

- (void)setTokenType:(NSString *)tokenType {
    _tokenType = tokenType;
    [_userDefaults setObject:_tokenType forKey:kTokenTypeKey];
}

- (void)setToken:(NSString *)token {
    _token = token;
    [_userDefaults setObject:_token forKey:kTokenKey];
}

@end
