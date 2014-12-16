//
//  CategoryTableViewCell.m
//  SJFood
//
//  Created by 叶帆 on 14/12/16.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "CategoryTableViewCell.h"

@implementation CategoryTableViewCell
@synthesize titleLabel,rightLine;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (self.selected) {
        self.titleLabel.textColor = kMainProjColor;
        self.rightLine.hidden = YES;
    }
    else {
        self.titleLabel.textColor = kMainBlackColor;
        self.rightLine.hidden = NO;
    }
}

@end
