//
//  FGHttpManager.h
//  FGCallKit
//
//  Created by feige on 2023/4/11.
//

#import <Foundation/Foundation.h>

typedef void (^FGRequestSuccessBlock)(BOOL succeed, NSString *msg, NSInteger code, id data);    ///< 请求成功回调
typedef void (^FGRequestFailureBlock)(NSError *error);                          ///< 请求失败回调

typedef NS_ENUM(NSInteger, FGRequestType) {
    GET,
    POST
};

@interface FGHttpManager : NSObject

/**
 * 开启日志打印，默认开启
 */
+ (void)openLog:(BOOL)isOpenLog;

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
                               failure:(FGRequestFailureBlock)failure;

/**
 *  网络请求
 *  @param  type        请求类型
 *  @param  method      除host剩余路径
 *  @param  parameters  请求参数
 *  @param  verifyToken 是否验证token
 */
+ (__kindof NSURLSessionTask *)request:(FGRequestType)type
                                method:(NSString *)method
                            parameters:(id)parameters
                           verifyToken:(BOOL)verifyToken
                               success:(FGRequestSuccessBlock)success
                               failure:(FGRequestFailureBlock)failure;

@end
