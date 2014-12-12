//
//  AddressTableViewCell.m
//  SJFood
//
//  Created by 叶帆 on 14/12/10.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "AddressTableViewCell.h"

@implementation AddressTableViewCell
@synthesize nameLabel,phoneLabel,addressLabel,rank,defaultAddressButton,defaultAddressLabel,editAddressButton;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
