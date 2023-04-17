//
//  FGKitInfo.h
//  FGCallKit
//
//  Created by feige on 2023/4/17.
//

#import <Foundation/Foundation.h>
#import "FGAccountInfoModel.h"

@interface FGKitInfo : NSObject
// local data
@property (nonatomic, copy) NSString *tokenType;        ///< 验证token类型
@property (nonatomic, copy) NSString *token;            ///< 验证token
// temp data
@property (nonatomic, strong) FGAccountInfoModel *accountInfo;

+ (instancetype)shared;

/// 退出登录
- (void)clearLoginInfo;

@end
