//
//  NoteViewController.h
//  SJFood
//
//  Created by 叶帆 on 15/5/7.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "BaseViewController.h"

@interface NoteViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UITextView *noteTextView;
@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (strong, nonatomic) IBOutlet UIButton *commitButton;

@end
