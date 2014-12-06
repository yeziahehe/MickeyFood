//
//  OrderInfoView.m
//  SJFood
//
//  Created by 叶帆 on 14/12/5.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "OrderInfoView.h"
#import "UserInfoTableViewCell.h"

#define kOrderInfoMapFileName           @"OrderInfoMap"

@interface OrderInfoView ()
@property (nonatomic, strong) NSMutableArray *orderInfoArray;
@end

@implementation OrderInfoView
@synthesize orderInfoTableView;
@synthesize orderInfoArray;

#pragma mark - Private
- (void)loadFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:kOrderInfoMapFileName ofType:@"plist"];
    self.orderInfoArray = [NSMutableArray arrayWithContentsOfFile:path];
    [self.orderInfoTableView reloadData];
}

#pragma mark - UIView methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self loadFile];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *UserInfoTableViewCellIdentifier = @"UserInfoTableViewCell";
    UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserInfoTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoTableViewCell" owner:self options:nil] lastObject];
    }
    NSDictionary *dict = [self.orderInfoArray objectAtIndex:indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:[dict objectForKey:@"iconname"]];
    cell.titleLabel.text = [dict objectForKey:@"keyname"];
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
