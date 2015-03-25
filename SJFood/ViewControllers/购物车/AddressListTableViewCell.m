//
//  AddressListTableViewCell.m
//  SJFood
//
//  Created by 叶帆 on 15/3/26.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "AddressListTableViewCell.h"

@implementation AddressListTableViewCell
@synthesize nameLabel,numberLabel,accessoryType,isDefualtImage;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
