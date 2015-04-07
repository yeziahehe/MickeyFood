//
//  MyMessageViewController.m
//  SJFood
//
//  Created by 叶帆 on 14/12/6.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "MyMessageViewController.h"

@interface MyMessageViewController ()

@end

@implementation MyMessageViewController
@synthesize messageDetail,messageLabel;

#pragma mark - UIViewController Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"我的消息"];
    if ([messageDetail isEqualToString:@""]) {
        messageLabel.text = @"暂无最新消息";
    } else {
        messageLabel.text = messageDetail;
    }
}

@end
