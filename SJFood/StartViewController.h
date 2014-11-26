//
//  StartViewController.h
//  SJFood
//
//  Created by 叶帆 on 14/11/25.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartViewController : UIViewController<UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *startImageView;
@property (strong, nonatomic) IBOutlet UIScrollView *startScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@end
