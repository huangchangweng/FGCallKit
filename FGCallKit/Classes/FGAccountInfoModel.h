//
//  FGAccountInfoModel.h
//  lite
//
//  Created by hcw on 2022/11/11.
//

#import <Foundation/Foundation.h>
#import "FGUserModel.h"
#import "FGCompanyModel.h"

@interface FGAccountInfoModel : NSObject
@property (nonatomic, strong) FGUserModel *userInfo;
@property (nonatomic, strong) FGCompanyModel *companyInfo;
@end
