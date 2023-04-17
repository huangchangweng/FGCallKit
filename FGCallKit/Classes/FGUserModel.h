//
//  FGUserModel.h
//  lite
//
//  Created by feige on 2022/9/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FGUserModel : NSObject
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, copy) NSString *accountName;
@property (nonatomic, strong) NSNumber *companyId;
@property (nonatomic, copy) NSString *headImg;
@property (nonatomic, copy) NSString *imPassword;
@property (nonatomic, copy) NSString *jobNumber;
@property (nonatomic, copy) NSString *qq;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, strong) NSNumber *roleId;
@property (nonatomic, assign) NSInteger upperLimit;
@property (nonatomic, copy) NSString *wechat;
@property (nonatomic, copy) NSString *introduction;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) BOOL isOpenChat; ///< 是否开启聊天
@property (nonatomic, strong) NSArray<NSNumber *> *websiteIds;
@property (nonatomic, copy) NSString *extensionUserName; ///< 分机号
@property (nonatomic, copy) NSString *extensionPassword; ///< 分机密码
@property (nonatomic, assign) NSInteger extensionStatus; ///< 分机配置是否有效 （1、有效 2、无效）
@property (nonatomic, assign) BOOL companyIsOpenExtension; ///< 是否有语音权限
@property (nonatomic, copy) NSString *voiceService;
@property (nonatomic, assign) BOOL isDesensitization;
@property (nonatomic, copy) NSString *expirationTime;
@property (nonatomic, copy) NSString *telePhone;
@property (nonatomic, copy) NSString *slogan;
@property (nonatomic, copy) NSString *ip; ///< ip地址
@property (nonatomic, assign) NSInteger tcpPort; ///< 不加密端口
@property (nonatomic, assign) NSInteger tcpSIPPort; ///< 加密端口
@end

NS_ASSUME_NONNULL_END
