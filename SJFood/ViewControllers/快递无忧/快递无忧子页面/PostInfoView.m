//
//  PostInfoView.m
//  SJFood
//
//  Created by MiY on 15/6/3.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "PostInfoView.h"
@interface PostInfoView ()

@property (strong, nonatomic) IBOutlet UITextView *postInfoTextView;

@end
@implementation PostInfoView

- (void)awakeFromNib
{
    [super awakeFromNib];
   
}

- (void)textViewDidChanege:(UITextView *)postInfoTextView
{
    
}

- (UITextView *)postInfoTextView
{
    if (!_postInfoTextView) {
        _postInfoTextView = [[UITextView alloc] init];
    }
    
    return _postInfoTextView;
}

@end
