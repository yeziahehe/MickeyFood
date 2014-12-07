//
//  WelcomeViewController.m
//  SJFood
//
//  Created by 叶帆 on 14/12/7.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController
@synthesize welcomeScrollView,pageControl;
@synthesize welcomeImageArray;

#pragma mark - Gesture methods
- (void)swipeWithGesture:(UISwipeGestureRecognizer *)gesture
{
    if(self.welcomeScrollView.contentOffset.x >= (self.welcomeImageArray.count-1)*self.welcomeScrollView.frame.size.width)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)showGuide
{
    [self.view addAnimationWithType:kCATransitionFade subtype:nil];
}

#pragma mark - UIViewController methods
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(IsDevicePhone6P)
    {
        self.welcomeImageArray = [NSArray arrayWithObjects:@"v2ex_736h@2x.png", @"v2ex_736h@2x.png",@"v2ex_736h@2x.png",nil];
    }
    else if (IsDevicePhone6)
    {
        self.welcomeImageArray = [NSArray arrayWithObjects:@"v2ex_667h@2x.png", @"v2ex_667h@2x.png",@"v2ex_667h@2x.png",nil];
    }
    else if (IsDevicePhone5)
    {
        self.welcomeImageArray = [NSArray arrayWithObjects:@"v2ex_736h@2x.png", @"v2ex_736h@2x.png",@"v2ex_736h@2x.png",nil];
    }
    else
    {
        self.welcomeImageArray = [NSArray arrayWithObjects:@"v2ex_736h@2x.png", @"v2ex_736h@2x.png",@"v2ex_736h@2x.png",nil];
    }
    
    NSInteger index = 0;
    for(NSString *imgName in self.welcomeImageArray)
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(index*self.welcomeScrollView.frame.size.width, 0, self.welcomeScrollView.frame.size.width, self.welcomeScrollView.frame.size.height)];
        imgView.image = [UIImage imageNamed:imgName];
        imgView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.welcomeScrollView addSubview:imgView];
        index++;
    }
    [self.welcomeScrollView setContentSize:CGSizeMake(self.welcomeScrollView.frame.size.width*self.welcomeImageArray.count, [UIScreen mainScreen].bounds.size.height)];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeWithGesture:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeGesture.delegate = self;
    [self.view addGestureRecognizer:swipeGesture];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - ScrollView Delegate Methods
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2) / scrollView.frame.size.width) + 1;
    self.pageControl.currentPage = page;
}

#pragma mark - Status bar methods
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
