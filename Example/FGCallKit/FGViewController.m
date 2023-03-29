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

@end

@implementation FGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Response Event

- (IBAction)testAction:(UIButton *)sender {
    [[FGCallKit new] textMethod];
}

@end
