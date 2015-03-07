//
//  ShoppingCarViewController.h
//  SJFood
//
//  Created by 叶帆 on 15/2/2.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "BaseMenuViewController.h"

@interface ShoppingCarViewController : BaseMenuViewController
@property (strong, nonatomic) IBOutlet UITableView *shoppingCarTableView;
@property (strong, nonatomic) IBOutlet UIView *noFoodView;
- (IBAction)addFoodButtonClicked:(id)sender;

@end
