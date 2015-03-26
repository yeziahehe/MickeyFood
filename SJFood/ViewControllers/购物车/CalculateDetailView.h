//
//  CalculateDetailView.h
//  SJFood
//
//  Created by 叶帆 on 15/3/25.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "CalculateSubView.h"

@interface CalculateDetailView : CalculateSubView

@property (strong, nonatomic) IBOutlet UITableView *orderListTableView;
@property (strong, nonatomic) IBOutlet UILabel *foodNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (strong, nonatomic) NSString *totalPrice;
- (void)reloadData:(NSMutableArray *)orderList;

@end
