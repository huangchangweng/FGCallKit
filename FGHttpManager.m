//
//  FGHttpManager.m
//  FGCallKit
//
//  Created by feige on 2023/4/11.
//

#import "FGHttpManager.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

#ifdef DEBUG
#define FGLog(...) printf("[%s] %s [第%d行]: %s\n", __TIME__ ,__PRETTY_FUNCTION__ ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#else
#define FGLog(...)
#endif

#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]
#define FGToJson(object) [FGHttpManager toJsonStrWithObject:object]

@interface FGHttpManager()

@end

@implementation FGHttpManager
static BOOL _isOpenLog;
static AFHTTPSessionManager *_sessionManager;

#pragma mark Init Method

/**
 开始监测网络状态
 */
+ (void)load {
    _isOpenLog = YES;
}

/**
 *  所有的HTTP请求共享一个AFHTTPSessionManager
 *  原理参考地址:http://www.jianshu.com/p/5969bbb4af9f
 */
+ (void)initialize {
    _sessionManager = [AFHTTPSessionManager manager];
    _sessionManager.requestSerializer.timeoutInterval = 30.f;
    _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    // 打开状态栏的等待菊花
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}

#pragma mark - Private Method

+ (NSString *)toJsonStrWithObject:(id)object {
    if ([object isKindOfClass:[NSString class]]) {
        return (NSString *)object;
    }
    if (!object) {
        return @"";
    }
    NSError *parseError = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:object
                                                   options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *jsonSrt = [[NSString alloc] initWithData:data
                                              encoding:NSUTF8StringEncoding];
    if (parseError) {
        jsonSrt = @"";
    }
    return jsonSrt;
}

/// 设置请求头
+ (NSDictionary <NSString *, NSString *> *)requestHeaders:(BOOL)verifyToken
{
    NSMutableDictionary *headers = [NSMutableDictionary new];
    
    // token
    if (verifyToken) {
//        NSString *tokenType = [FGAppInfo shared].tokenType;
//        NSString *token = [FGAppInfo shared].token;
//        if (![HLUtils isNullOrEmpty:token]) {
//            headers[@"Authorization"] = [NSString stringWithFormat:@"%@ %@", tokenType, token];
//        }
    }
    
    return headers;
}

/// 处理请求返回数据
+ (void)handleResponseData:(id)responseObject
                      type:(FGRequestType)type
                       url:(NSString *)url
                   success:(FGRequestSuccessBlock)success
{
    if (_isOpenLog) {
        FGLog(@"\n<----%@返回结果---->\n%@\n%@", type == GET ? @"GET" : @"POST", url, FGToJson(responseObject));
    }
    
    NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
    BOOL status = [[responseObject objectForKey:@"status"] boolValue];
    NSString *message = [responseObject objectForKey:@"message"];
    id data = [responseObject objectForKey:@"data"];
    if (code == 0 && status) {
        if (success) { success(YES, message, data); }
    } else {
        if (success) { success(NO, message, responseObject); }
    }
}

/// 处理请求失败错误
+ (void)handleFailureError:(NSError *)error
                      type:(FGRequestType)type
                       url:(NSString *)url
                   failure:(FGRequestFailureBlock)failure
{
    if (_isOpenLog) {
        FGLog(@"\n<----%@返回结果---->\n%@\n%@", type == GET ? @"GET" : @"POST", url, error);
    }
    
    NSData *responseData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    NSString *receive = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSData *data = [receive dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];

    NSInteger code = [[dict objectForKey:@"code"] integerValue];
    // 登录信息失效
    if (code == 401 || code == 402) {
   
    }
    
    if (failure) { failure(error); }
}

#pragma mark - Public Method

/**
 *  网络请求
 *  @param  type        请求类型
 *  @param  method      除host剩余路径
 *  @param  parameters  请求参数
 */
+ (__kindof NSURLSessionTask *)request:(FGRequestType)type
                                method:(NSString *)method
                            parameters:(id)parameters
                               success:(FGRequestSuccessBlock)success
                               failure:(FGRequestFailureBlock)failure
{
    return [self request:type
                  method:method
              parameters:parameters
             verifyToken:YES
                 success:success
                 failure:failure];
}

/**
 *  网络请求
 *  @param  type        请求类型
 *  @param  method      除host剩余路径
 *  @param  parameters  请求参数
 */
+ (__kindof NSURLSessionTask *)request:(FGRequestType)type
                                method:(NSString *)method
                            parameters:(id)parameters
                           verifyToken:(BOOL)verifyToken
                               success:(FGRequestSuccessBlock)success
                               failure:(FGRequestFailureBlock)failure
{
    NSString *url = url = [NSString stringWithFormat:@"%@%@", @"", method];
    
    if (_isOpenLog) {
        FGLog(@"\n<----%@请求---->\n%@\n%@", type == GET ? @"GET" : @"POST", url, FGToJson(parameters));
    }
    
    NSURLSessionTask *sessionTask;
    if (type == GET) {
        sessionTask = [_sessionManager GET:url
                                parameters:parameters
                                   headers:[self requestHeaders:verifyToken]
                                  progress:^(NSProgress * _Nonnull downloadProgress) {}
                                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self handleResponseData:responseObject type:type url:url success:success];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self handleFailureError:error type:type url:url failure:failure];
        }];
    } else {
        sessionTask = [_sessionManager POST:url
                                 parameters:parameters
                                    headers:[self requestHeaders:verifyToken]
                                   progress:^(NSProgress * _Nonnull downloadProgress) {}
                                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self handleResponseData:responseObject type:type url:url success:success];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self handleFailureError:error type:type url:url failure:failure];
        }];
    }
    return sessionTask;
}

@end
