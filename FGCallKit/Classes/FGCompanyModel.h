//
//  FGCompanyModel.h
//  lite
//
//  Created by feige on 2022/9/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FGCompanyModel : NSObject
@property (nonatomic, assign) NSInteger seat;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *businessLicense;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSNumber *provinceCode;
@property (nonatomic, assign) NSInteger authStatus;
@property (nonatomic, assign) BOOL isOpenLogo;
@property (nonatomic, assign) NSInteger voiceAuthStatus;
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, copy) NSString *apiKey;
@property (nonatomic, copy) NSString *apiSecret;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, strong) NSNumber *cityCode;
@property (nonatomic, assign) NSInteger chatbotCount;
@property (nonatomic, assign) NSInteger businessType; ///< 公司业务类型（1、智能客服 2、语音呼叫 3、智能客服和语音呼叫）
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *authorizationLetter;
@property (nonatomic, strong) NSNumber *areaCode;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) BOOL isOpenMessageWithdraw; ///< 是否开启消息撤回
@property (nonatomic, assign) BOOL isOpenMessageForesee; ///< 是否开启他人是否“正在输入”
@property (nonatomic, assign) BOOL isOpenMessageReceipt; ///< 是否开启消息已读未读显示
@end

NS_ASSUME_NONNULL_END
