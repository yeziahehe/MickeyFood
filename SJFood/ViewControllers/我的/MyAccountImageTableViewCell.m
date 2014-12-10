//
//  MyAccountImageTableViewCell.m
//  SJFood
//
//  Created by 叶帆 on 14/12/10.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "MyAccountImageTableViewCell.h"

@implementation MyAccountImageTableViewCell
@synthesize titleLabel,iconImageView;

- (void)awakeFromNib {
    // Initialization code
    self.iconImageView.layer.cornerRadius = 17.f;
    self.iconImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
