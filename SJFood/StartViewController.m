//
//  StartViewController.m
//  SJFood
//
//  Created by 叶帆 on 14/11/25.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "StartViewController.h"

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
    if(self.startScrollView.contentOffset.x >= (self.guideArray.count-1)*self.startScrollView.frame.size.width)
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
        self.startImageView.image = [UIImage imageNamed:@"v2ex_736h@2x.png"];
        self.guideArray = [NSArray arrayWithObjects:@"v2ex_736h@2x.png", @"v2ex_736h@2x.png",@"v2ex_736h@2x.png",nil];
    }
    else if (IsDevicePhone6)
    {
        self.startImageView.image = [UIImage imageNamed:@"v2ex_667h@2x.png"];
        self.guideArray = [NSArray arrayWithObjects:@"v2ex_667h@2x.png", @"v2ex_667h@2x.png",@"v2ex_667h@2x.png",nil];
    }
    else if (IsDevicePhone5)
    {
        self.startImageView.image = [UIImage imageNamed:@"v2ex_568h@2x.png"];
        self.guideArray = [NSArray arrayWithObjects:@"v2ex_736h@2x.png", @"v2ex_736h@2x.png",@"v2ex_736h@2x.png",nil];
    }
    else
    {
        self.startImageView.image = [UIImage imageNamed:@"v2ex_480h@2x.png"];
        self.guideArray = [NSArray arrayWithObjects:@"v2ex_736h@2x.png", @"v2ex_736h@2x.png",@"v2ex_736h@2x.png",nil];
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
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(index*self.startScrollView.frame.size.width, 0, self.startScrollView.frame.size.width, self.startScrollView.frame.size.height)];
            imgView.image = [UIImage imageNamed:imgName];
            imgView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            [self.startScrollView addSubview:imgView];
            index++;
        }
        [self.startScrollView setContentSize:CGSizeMake(self.startScrollView.frame.size.width*self.guideArray.count, [UIScreen mainScreen].bounds.size.height)];
        
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
    NSInteger page = floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2) / scrollView.frame.size.width) + 1;
    self.pageControl.currentPage = page;
}

#pragma mark - Status bar methods
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
