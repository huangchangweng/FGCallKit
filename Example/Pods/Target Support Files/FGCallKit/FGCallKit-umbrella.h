#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "FGAccountInfoModel.h"
#import "FGCall.h"
#import "FGCallKit.h"
#import "FGCompanyModel.h"
#import "FGHttpManager.h"
#import "FGKitInfo.h"
#import "FGUserModel.h"
#import "FGUtils.h"
#import "Gossip.h"
#import "GSAccount+Private.h"
#import "GSAccount.h"
#import "GSAccountConfiguration.h"
#import "GSCall+Private.h"
#import "GSCall.h"
#import "GSCodecInfo+Private.h"
#import "GSCodecInfo.h"
#import "GSConfiguration.h"
#import "GSDispatch.h"
#import "GSIncomingCall.h"
#import "GSNotifications.h"
#import "GSOutgoingCall.h"
#import "GSPJUtil.h"
#import "GSRingback.h"
#import "GSUserAgent+Private.h"
#import "GSUserAgent.h"
#import "PJSIP.h"
#import "Util.h"

FOUNDATION_EXPORT double FGCallKitVersionNumber;
FOUNDATION_EXPORT const unsigned char FGCallKitVersionString[];

