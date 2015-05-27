//
//  StartViewController.m
//  SJFood
//
//  Created by 叶帆 on 14/11/25.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "StartViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudCrashReporting/AVOSCloudCrashReporting.h>
@interface StartViewController ()

@property (nonatomic, retain) NSArray *guideArray;

@end

@implementation StartViewController

@synthesize startImageView;
@synthesize startScrollView;
@synthesize pageControl;
@synthesize guideArray;

#pragma mark - Private Methods
- (void)showPannel
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowPannelViewNotification object:nil];
}

- (void)showGuide
{
    [self.view addAnimationWithType:kCATransitionFade subtype:nil];
    self.startImageView.hidden = YES;
}

#pragma mark - Gesture methods
- (void)swipeWithGesture:(UISwipeGestureRecognizer *)gesture
{
    if(self.startScrollView.contentOffset.x >= (self.guideArray.count-1)*ScreenWidth)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kIsWelcomeShown];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowPannelViewNotification object:@"fromGuide"];
    }
}

#pragma mark - UIViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // to do
    if(IsDevicePhone6P)
    {
        //self.startImageView.image = [UIImage imageNamed:@"v2ex_736h@2x.png"];
        self.guideArray = [NSArray arrayWithObjects:@"guidepage_1_736h@3x.png", @"guidepage_2_736h@3x.png",@"guidepage_3_736h@3x.png",@"guidepage_4_736h@3x.png", nil];
    }
    else if (IsDevicePhone6)
    {
        //self.startImageView.image = [UIImage imageNamed:@"v2ex_667h@2x.png"];
        self.guideArray = [NSArray arrayWithObjects:@"guidepage_1_667h@2x.png", @"guidepage_2_667h@2x.png",@"guidepage_3_667h@2x.png",@"guidepage_4_667h@2x.png",nil];
    }
    else if (IsDevicePhone5)
    {
        //self.startImageView.image = [UIImage imageNamed:@"v2ex_568h@2x.png"];
        self.guideArray = [NSArray arrayWithObjects:@"guidepage_1_568h@2x.png", @"guidepage_2_568h@2x.png",@"guidepage_3_568h@2x.png",@"guidepage_4_568h@2x.png",nil];
    }
    else
    {
        //self.startImageView.image = [UIImage imageNamed:@"v2ex_480h@2x.png"];
        self.guideArray = [NSArray arrayWithObjects:@"guidepage_1_480h@2x.png", @"guidepage_2_480h@2x.png",@"guidepage_3_480h@2x.png",@"guidepage_4_480h@2x.png",nil];
    }
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:kIsWelcomeShown] isEqualToString:@"1"])
    {
        self.startScrollView.hidden = YES;
        self.pageControl.hidden = YES;
        [self performSelector:@selector(showPannel) withObject:nil];
    }
    else
    {
        self.startScrollView.hidden = NO;
        self.pageControl.hidden = NO;
        [self performSelector:@selector(showGuide) withObject:nil];
        NSInteger index = 0;
        for(NSString *imgName in self.guideArray)
        {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(index*ScreenWidth, 0, ScreenWidth, ScreenHeight)];
            imgView.image = [UIImage imageNamed:imgName];
            //imgView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            [self.startScrollView addSubview:imgView];
            index++;
        }
        [self.startScrollView setContentSize:CGSizeMake(ScreenWidth*self.guideArray.count, 0)];
        
        UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeWithGesture:)];
        swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        swipeGesture.delegate = self;
        [self.view addGestureRecognizer:swipeGesture];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)shouldAutorotate{
    return NO;
}

#pragma mark - ScrollView Delegate Methods
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = floor((scrollView.contentOffset.x - ScreenWidth / 2) / ScreenWidth) + 1;
    self.pageControl.currentPage = page;
}

#pragma mark - Status bar methods
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
