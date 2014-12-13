//
//  FeedbackViewController.h
//  SJFood
//
//  Created by 叶帆 on 14/12/6.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "BaseViewController.h"

@interface FeedbackViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UITextView *feedbackTextView;
@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (strong, nonatomic) IBOutlet UIButton *commitButton;


- (IBAction)commitFeedbackButtonClicked:(id)sender;
@end
