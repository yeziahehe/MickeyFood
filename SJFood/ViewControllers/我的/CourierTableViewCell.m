//
//  CourierTableViewCell.m
//  SJFood
//
//  Created by 叶帆 on 15/3/27.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "CourierTableViewCell.h"
#import "CourierDetailTableViewCell.h"
#import "OrderList.h"

@interface CourierTableViewCell ()
@property (nonatomic, strong) OrderList *orderList;
@property (nonatomic, strong) NSMutableArray *orderListArray;
@end

@implementation CourierTableViewCell
@synthesize orderIdLabel,dateLabel,totalPriceLabel,addressLabel,statusLabel,changeStatusButton,orderDetailTableView,phoneLabel,nameLabel,timeLabel,noteLabel,cellPhoneButton;
@synthesize orderList,orderListArray;

#pragma mark - Public Methods
- (void)reloadData:(NSMutableArray *)orderDetail
{
    self.orderListArray = orderDetail;
    [self.orderDetailTableView reloadData];
}

#pragma mark - UIView Methods
- (void)awakeFromNib {
    // Initialization code
    self.changeStatusButton.layer.cornerRadius = 5.f;
    self.changeStatusButton.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *UserInfoTableViewCellIdentifier = @"CourierDetailTableViewCell";
    CourierDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserInfoTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CourierDetailTableViewCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.orderList = [self.orderListArray objectAtIndex:indexPath.row];
    cell.foodNameLabel.text = self.orderList.foodName;
    cell.foodCountLabel.text = [NSString stringWithFormat:@"x%@",self.orderList.orderCount];
    if ([self.orderList.isDiscount isEqualToString:@"0"]) {
        cell.foodPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.orderList.price floatValue]];
    } else {
        cell.foodPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.orderList.discountPrice floatValue]];
    }
    cell.foodSpecLabel.text = self.orderList.specialName;
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
