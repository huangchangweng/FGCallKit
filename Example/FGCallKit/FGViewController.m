//
//  FGViewController.m
//  FGCallKit
//
//  Created by huangchangweng on 03/29/2023.
//  Copyright (c) 2023 huangchangweng. All rights reserved.
//

#import "FGViewController.h"
#import <FGCallKit.h>

@interface FGViewController ()
@property (nonatomic, strong) FGCall *call;
@end

@implementation FGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [FGCallKit sharedKit].isTest = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Response Event

- (IBAction)loginAction:(UIButton *)sender {
    [[FGCallKit sharedKit] login:@"91jSP3k26mfcqVfr"
                       apiSecret:@"owd3ApuW9s9o180ySJt3I032039c02BF"
                        username:@"15123078327"
                       callBlock:^(NSInteger code, NSString *msg, id data) {
        NSLog(@"登录%@ code:%ld msg:%@", code == 200 ? @"成功" : @"失败", code, msg);
    }];
}

- (IBAction)callAction:(UIButton *)sender {
    [[FGCallKit sharedKit] outgoingCall:@"8013"
                                  block:^(BOOL succeed, NSString *msg, FGCall *call) {
        NSLog(@"呼出%@ msg:%@", succeed ? @"成功" : @"失败", msg);
        if (succeed) {
            self.call = call;
        }
    }];
}

- (IBAction)hangupAction:(UIButton *)sender {
    [self.call hangup:^(BOOL succeed, NSString *msg) {
        NSLog(@"挂断%@ msg:%@", succeed ? @"成功" : @"失败", msg);
    }];
}

@end
