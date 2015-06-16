//
//  PostUserInfoView.m
//  SJFood
//
//  Created by MiY on 15/6/3.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "PostUserInfoView.h"

@interface PostUserInfoView ()
@property (nonatomic, strong)Address *selectedAddress;
@end

@implementation PostUserInfoView

#pragma mark - Public Methods
- (void)reloadData:(Address *)address
{
    self.selectedAddress = address;
    self.nameLabel.text = address.name;
    self.numberLabel.text = address.phone;
    self.addressLabel.text = address.address;
    NSLog(@"\n\n\n\n\n\n\n\n%@ %@ %@", address.name, address.phone, address.address);
}

#pragma mark - IBAction Methods
- (IBAction)addListButtonClicked:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kAddressViewShowNotification object:self.selectedAddress];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

@end
