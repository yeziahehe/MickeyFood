//
//  CalculateDetailView.m
//  SJFood
//
//  Created by 叶帆 on 15/3/25.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "CalculateDetailView.h"
#import "OrderDetailTableViewCell.h"
#import "ShoppingCar.h"

@interface CalculateDetailView ()
@property (nonatomic ,strong) NSMutableArray *orderListArray;
@property (nonatomic, strong) ShoppingCar *shoppingCar;
@end

@implementation CalculateDetailView
@synthesize orderListArray,orderListTableView,shoppingCar;
@synthesize foodNumberLabel,totalPriceLabel,totalPrice;

#pragma mark - Public Methods
- (void)reloadData:(NSMutableArray *)orderList
{
    self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%@",self.totalPrice];
    self.orderListArray = orderList;
    self.foodNumberLabel.text = [NSString stringWithFormat:@"共%lu件商品",(unsigned long)self.orderListArray.count];
    self.orderListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.orderListTableView reloadData];
}

#pragma mark - UIView methods
- (void)awakeFromNib
{
    [super awakeFromNib];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *UserInfoTableViewCellIdentifier = @"OrderDetailTableViewCell";
    OrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserInfoTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderDetailTableViewCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.shoppingCar = [self.orderListArray objectAtIndex:indexPath.row];
    cell.iconImageView.cacheDir = kUserIconCacheDir;
    [cell.iconImageView aysnLoadImageWithUrl:self.shoppingCar.imageUrl placeHolder:@"loading_square.png"];
    cell.foodNameLabel.text = self.shoppingCar.name;
    cell.foodCountLabel.text = [NSString stringWithFormat:@"x%@",self.shoppingCar.orderCount];
    if ([self.shoppingCar.isDiscount isEqualToString:@"0"]) {
        cell.foodPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.shoppingCar.price floatValue]];
    } else {
        cell.foodPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.shoppingCar.discountPrice floatValue]];
    }
    cell.foodSpecLabel.text = self.shoppingCar.specialName;
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
