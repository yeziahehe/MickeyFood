//
//  AddressListViewController.m
//  SJFood
//
//  Created by 叶帆 on 15/3/26.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "AddressListViewController.h"
#import "AddressViewController.h"
#import "AddressListTableViewCell.h"

@interface AddressListViewController ()

@end

@implementation AddressListViewController
@synthesize addressArray,selectedAddress,addListTableView;

#pragma mark - NSNotification Methods
- (void)refreshTableViewDataWithNotification:(NSNotification *)notification
{
    self.addressArray = notification.object;
    self.addListTableView.tableFooterView = [UIView new];
    [self.addListTableView reloadData];
}

#pragma mark - BaseViewController Methods
- (void)rightItemTapped
{
    AddressViewController *addressViewController = [[AddressViewController alloc]initWithNibName:@"AddressViewController" bundle:nil];
    [self.navigationController pushViewController:addressViewController animated:YES];
}

#pragma mark - UIView Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"选择收货地址"];
    [self setRightNaviItemWithTitle:@"管理" imageName:nil];
    self.addListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.addListTableView reloadData];
    self.addListTableView.tableFooterView = [UIView new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableViewDataWithNotification:) name:kReloadRefreshAddressNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.addressArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"AddressListTableViewCell";
    AddressListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (nil == cell)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"AddressListTableViewCell" owner:self options:nil];
        cell = [nibs lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Address *address = [self.addressArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = address.name;
    cell.numberLabel.text = address.phone;
    if ([address.tag isEqualToString:@"0"]) {
        cell.addressLabel.text = [NSString stringWithFormat:@"[默认]%@",address.address];
    } else {
        cell.addressLabel.text = address.address;
    }
    if ([address.rank isEqualToString:self.selectedAddress.rank]) {
        cell.isDefualtImage.hidden = NO;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //选择
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:kSelectAddressNotification object:[self.addressArray objectAtIndex:indexPath.row]];
}

@end
