//
//  AddressChooseView.h
//  SJFood
//
//  Created by 叶帆 on 15/3/25.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "CalculateSubView.h"
#import "Address.h"

@interface AddressChooseView : CalculateSubView
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;

- (void)reloadData:(Address *)address;

@end
