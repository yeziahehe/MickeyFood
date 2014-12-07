//
//  WelcomeViewController.h
//  SJFood
//
//  Created by 叶帆 on 14/12/7.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "BaseViewController.h"

@interface WelcomeViewController : BaseViewController<UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *welcomeScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSArray *welcomeImageArray;

@end
