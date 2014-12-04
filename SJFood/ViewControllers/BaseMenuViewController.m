//
//  BaseMenuViewController.m
//  SJFood
//
//  Created by 叶帆 on 14/11/25.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "BaseMenuViewController.h"

@interface BaseMenuViewController ()

@end

@implementation BaseMenuViewController

#pragma mark - UIViewController methods
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = nil;
}

@end
