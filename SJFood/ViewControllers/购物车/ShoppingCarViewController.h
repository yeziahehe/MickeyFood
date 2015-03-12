//
//  ShoppingCarViewController.h
//  SJFood
//
//  Created by 叶帆 on 15/2/2.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "BaseMenuViewController.h"

@interface ShoppingCarViewController : BaseMenuViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView *shoppingCarTableView;
@property (strong, nonatomic) IBOutlet UIView *noFoodView;
@property (strong, nonatomic) IBOutlet UIView *calculateFoodView;
@property (strong, nonatomic) IBOutlet UIButton *totalPriceButton;
@property (strong, nonatomic) IBOutlet UILabel *totalPriceLabel;
- (IBAction)addFoodButtonClicked:(id)sender;
- (void)requestForShoppingCar;
- (void)loadSubViews;

@end
