//
//  FoodViewController.h
//  SJFood
//
//  Created by 叶帆 on 14/12/17.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "BaseViewController.h"

@interface FoodViewController : BaseViewController<UISearchBarDelegate>
@property (nonatomic, strong) NSString *categoryId;
@property (strong, nonatomic) IBOutlet UIButton *sortByAllButton;
@property (strong, nonatomic) IBOutlet UIButton *sortByPriceButton;
@property (strong, nonatomic) IBOutlet UIButton *sortBySaleButton;
@property (strong, nonatomic) IBOutlet UITableView *foodTableView;

- (IBAction)sortByAllButtonClicked:(id)sender;
- (IBAction)sortByPriceButtonClicked:(id)sender;
- (IBAction)sortBySaleButtonClicked:(id)sender;
@end
