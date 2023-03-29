//
//  FGCall.h
//  FGCallKit
//
//  Created by feige on 2023/3/29.
//

#import <Foundation/Foundation.h>

@interface FGCall : NSObject
/// 是否静音
@property (nonatomic, assign, readonly) BOOL isMute;

/**
 * 开启/关闭静音
 * @param isMute 是否静音
 */
- (void)mute:(BOOL)isMute;

/**
 * 通话中途发送数字
 * @param digits 数字
 */
- (BOOL)sendDTMFDigits:(NSString *)digits;

@end
