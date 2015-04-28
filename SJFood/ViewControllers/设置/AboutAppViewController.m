//
//  AboutAppViewController.m
//  SJFood
//
//  Created by 叶帆 on 14/12/7.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "AboutAppViewController.h"
#import "AboutBOXViewController.h"

@interface AboutAppViewController ()

@end

@implementation AboutAppViewController
@synthesize versionLabel;

#pragma mark - IBAction Methods
- (IBAction)aboutBOXButtonClicked:(id)sender {
    AboutBOXViewController *aboutBOXViewController = [[AboutBOXViewController alloc]initWithNibName:@"AboutBOXViewController" bundle:nil];
    [self.navigationController pushViewController:aboutBOXViewController animated:YES];
}

#pragma mark - UIViewController Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"关于我们"];
    NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = localVersion;
}

@end
