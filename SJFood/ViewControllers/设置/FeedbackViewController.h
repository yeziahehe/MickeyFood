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

- (IBAction)commitFeedbackButtonClicked:(id)sender;
@end
