//
//  AboutBOXViewController.m
//  SJFood
//
//  Created by 叶帆 on 15/3/26.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "AboutBOXViewController.h"

@interface AboutBOXViewController ()

@end

@implementation AboutBOXViewController

#pragma mark - IBAction Methods
- (IBAction)linkButtonClicked:(id)sender {
    NSString *path = @"http://120.26.76.252:8080/boxstudio/home.html";
    YFWebViewController *yfwvc = [[YFWebViewController alloc] init];
    yfwvc.htmlTitle = @"盒子工作室";
    yfwvc.htmlPath = path;
    yfwvc.htmlType = kRemoteHtml;
    yfwvc.isContainCSS = YES;
    [self.navigationController pushViewController:yfwvc animated:YES];
}

#pragma mark - UIView Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"关于盒子"];
}

@end
