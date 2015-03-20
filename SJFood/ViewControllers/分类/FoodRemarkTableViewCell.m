//
//  FoodRemarkTableViewCell.m
//  SJFood
//
//  Created by 叶帆 on 15/3/20.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "FoodRemarkTableViewCell.h"

@implementation FoodRemarkTableViewCell
@synthesize userIconImage,remarkLabel,nicknameLabel,dateLabel,gradeLabel;

- (void)awakeFromNib {
    // Initialization code
    self.userIconImage.layer.cornerRadius = 20.f;
    self.userIconImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
