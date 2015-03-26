//
//  CalculateViewController.h
//  SJFood
//
//  Created by 叶帆 on 15/3/25.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "BaseViewController.h"

@interface CalculateViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (strong, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (strong, nonatomic) NSString *totalPrice;
@property (strong, nonatomic) NSMutableArray *orderListArray;
@property (strong, nonatomic) NSMutableArray *orderCodeArray;

@end
