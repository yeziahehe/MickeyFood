//
//  PostPopTableViewCell.m
//  Post
//
//  Created by MiY on 15/6/8.
//  Copyright (c) 2015年 MiY. All rights reserved.
//

#import "PostPopTableViewCell.h"

@implementation PostPopTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.tintColor = [UIColor colorWithRed:80/255.0 green:211/255.0 blue:191/255.0 alpha:1];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
