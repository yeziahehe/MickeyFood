//
//  CourierDetailTableViewCell.h
//  SJFood
//
//  Created by 叶帆 on 15/3/30.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourierDetailTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *foodNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *foodPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *foodSpecLabel;
@property (strong, nonatomic) IBOutlet UILabel *foodCountLabel;

@end
