//
//  OrderTableViewCell.m
//  SJFood
//
//  Created by 叶帆 on 15/3/23.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "OrderTableViewCell.h"
#import "OrderDetailTableViewCell.h"
#import "OrderDetails.h"

@interface OrderTableViewCell ()
@property (nonatomic, strong)OrderDetails *orderDetails;
@property (strong, nonatomic) NSMutableArray *orderDetailArray;
@end

@implementation OrderTableViewCell
@synthesize orderDetailTableView,orderDateLabel,orderStatusLabel,orderStatusChangeButton,orderDetailArray,orderTotalPriceLabel;
@synthesize orderDetails;

#pragma mark - Public Methods
- (void)reloadData:(NSMutableArray *)orderDetail
{
    self.orderDetailArray = orderDetail;
    self.orderDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.orderDetailTableView reloadData];
}

#pragma mark - UIView Methods
- (void)awakeFromNib {
    // Initialization code
    self.orderStatusChangeButton.layer.cornerRadius = 9.f;
    self.orderStatusChangeButton.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderDetailArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *UserInfoTableViewCellIdentifier = @"OrderDetailTableViewCell";
    OrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserInfoTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderDetailTableViewCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.orderDetails = [self.orderDetailArray objectAtIndex:indexPath.row];
    cell.iconImageView.cacheDir = kUserIconCacheDir;
    [cell.iconImageView aysnLoadImageWithUrl:self.orderDetails.imageUrl placeHolder:@"loading_square.png"];
    cell.foodNameLabel.text = self.orderDetails.name;
    cell.foodCountLabel.text = [NSString stringWithFormat:@"x%@",self.orderDetails.orderCount];
    if ([self.orderDetails.isDiscount isEqualToString:@"0"]) {
        cell.foodPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.orderDetails.price floatValue]];
    } else {
        cell.foodPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.orderDetails.discountPrice floatValue]];
    }
    //cell.foodSpecLabel.text = ;
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
