//
//  FGViewController.m
//  FGCallKit
//
//  Created by huangchangweng on 03/29/2023.
//  Copyright (c) 2023 huangchangweng. All rights reserved.
//

#import "FGViewController.h"
#import <FGCallKit.h>
#import "FGCallingViewController.h"

@interface FGViewController ()<FGCallKitDelegate>
@property (weak, nonatomic) IBOutlet UITextField *apiKeyTextField;
@property (weak, nonatomic) IBOutlet UITextField *apiSecretTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@end

@implementation FGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [FGCallKit sharedKit].isTest = YES;
    [FGCallKit sharedKit].delegate = self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Private Method

- (void)popCallingVC:(FGCall *)call
{
    FGCallingViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FGCallingViewController"];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    vc.call = call;
    [self presentViewController:vc animated:YES completion:^{}];
}

- (void)showAlert:(NSString *)msg
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{}];
}

#pragma mark - Response Event

- (IBAction)loginAction:(UIButton *)sender {
    sender.hidden = YES;
    
    NSString *apiKey = self.apiKeyTextField.text;
    NSString *apiSecret = self.apiSecretTextField.text;
    NSString *username = self.usernameTextField.text;
    
    [[FGCallKit sharedKit] login:apiKey
                       apiSecret:apiSecret
                        username:username
                       callBlock:^(NSInteger code, NSString *msg, id data) {
        NSLog(@"登录%@ code:%ld msg:%@", code == 200 ? @"成功" : @"失败", code, msg);
        if (code == 200) {
            [self showAlert:@"登录成功"];
        }
    }];
}

- (IBAction)outgoingCallAction:(UIButton *)sender {
    NSString *number = self.numberTextField.text;
    
    if ([FGCallKit sharedKit].accountStatus != FGAccountStatusConnected) {
        [self showAlert:@"未登录"];
        return;
    }
    
    if (number.length == 0) {
        [self showAlert:@"请输入号码"];
        return;
    }
    
    [[FGCallKit sharedKit] outgoingCall:number
                                  block:^(BOOL succeed, NSString *msg, FGCall *call) {
        if (succeed) {
            [self popCallingVC:call];
        }
        NSLog(@"呼出%@ msg:%@", succeed ? @"成功" : @"失败", msg);
    }];
}

#pragma mark - FGCallKitDelegate

/**
 * 收到来电回调
 * @param call 来电对象
 */
- (void)callKit:(FGCallKit *)callKit didReceiveIncomingCall:(FGCall *)call
{
    [self popCallingVC:call];
}

/**
 * 账号状态改变回调
 * @param status 状态
 */
- (void)callKit:(FGCallKit *)callKit statusDidChanged:(FGCallAccountStatus)status
{
    // TODO 显示状态
}

/**
 * 登录信息失效，收到此回调需重新登录SDK
 */
- (void)callKitLoginInvalid
{
    // TODO 退出登录
}

@end
