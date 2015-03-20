//
//  FoodRemarkViewController.h
//  SJFood
//
//  Created by 叶帆 on 15/3/19.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "BaseViewController.h"

@interface FoodRemarkViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UITableView *remarkTableView;
@property (strong, nonatomic) NSString *foodId;
@property (strong, nonatomic) IBOutlet UIView *messageFooterView;
@property (strong, nonatomic) IBOutlet UILabel *loadMessageLabel;

@end
