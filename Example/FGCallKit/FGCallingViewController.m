//
//  FGCallingViewController.m
//  FGCallKit-demo
//
//  Created by feige on 2023/4/20.
//

#import "FGCallingViewController.h"

@interface FGCallingViewController ()<FGCallDelegate>
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *answerButton;
@property (weak, nonatomic) IBOutlet UIButton *hangupButton;

@end

@implementation FGCallingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupData];
}

#pragma mark - Private Method

- (void)setupData
{
    self.call.delegate = self;
    self.numberLabel.text = self.call.number;
    self.statusLabel.text = [self statusStr];
    self.answerButton.hidden = !self.call.isIncoming;
}

- (NSString *)statusStr
{
    switch (self.call.status) {
        case FGCallStatusReady:
        case FGCallStatusCalling:
        case FGCallStatusConnecting:
            return self.call.isIncoming ? @"来电中..." : @"呼叫中...";
            break;
        case FGCallStatusConnected:
            return @"通话中...";
            break;
        case FGCallStatusDisconnected:
            return @"已挂断";
            break;
            
        default:
            return @"未知";
            break;
    }
}

#pragma mark - Response Event

- (IBAction)answerAction:(UIButton *)sender {
    [self.call answer];
    self.answerButton.hidden = YES;
}

- (IBAction)hangupAction:(UIButton *)sender {
    [self.call hangup:^(BOOL succeed, NSString *msg) {
        NSLog(@"挂断%@ msg:%@", succeed ? @"成功" : @"失败", msg);
    }];
}

#pragma mark - FGCallDelegate

/**
 * 通话状态改变回调
 */
- (void)call:(FGCall *)call statusDidChanged:(FGCallStatus)status
{
    self.statusLabel.text = [self statusStr];
    
    if (status == FGCallStatusDisconnected) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
}

@end
