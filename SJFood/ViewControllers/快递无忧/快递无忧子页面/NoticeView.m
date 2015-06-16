//
//  NoticeView.m
//  Post
//
//  Created by MiY on 15/6/8.
//  Copyright (c) 2015年 MiY. All rights reserved.
//

#import "NoticeView.h"

@implementation NoticeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    self.tintColor = [UIColor colorWithRed:80/255.0 green:211/255.0 blue:191/255.0 alpha:1];
    self.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.5];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.f;
    self.backgroundColor = [UIColor whiteColor];

    
}

@end
