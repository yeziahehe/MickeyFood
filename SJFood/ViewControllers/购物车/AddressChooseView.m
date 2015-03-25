//
//  AddressChooseView.m
//  SJFood
//
//  Created by 叶帆 on 15/3/25.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "AddressChooseView.h"

@interface AddressChooseView()
@property (nonatomic, strong)Address *selectedAddress;
@end

@implementation AddressChooseView
@synthesize nameLabel,numberLabel,addressLabel;
@synthesize selectedAddress;

#pragma mark - Public Methods
- (void)reloadData:(Address *)address
{
    self.selectedAddress = address;
    self.nameLabel.text = address.name;
    self.numberLabel.text = address.phone;
    self.addressLabel.text = address.address;
}

#pragma mark - IBAction Methods
- (IBAction)addListButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kAddressViewShowNotification object:self.selectedAddress];
}

#pragma mark - UIView methods
- (void)awakeFromNib
{
    [super awakeFromNib];
}

@end
