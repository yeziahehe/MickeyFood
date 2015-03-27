//
//  CourierOrderView.m
//  SJFood
//
//  Created by 叶帆 on 15/3/27.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "CourierOrderView.h"
#import "UserInfoTableViewCell.h"

#define kCourierOrderMapFileName           @"CourierOrderMap"

@interface CourierOrderView ()
@property (nonatomic, strong) NSMutableArray *courierOrderArray;
@end

@implementation CourierOrderView
@synthesize courierOrderArray,courierOrderTableView;

#pragma mark - Private Methods
- (void)loadFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:kCourierOrderMapFileName ofType:@"plist"];
    self.courierOrderArray = [NSMutableArray arrayWithContentsOfFile:path];
    [self.courierOrderTableView reloadData];
}

#pragma mark - UIView Methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self loadFile];
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.courierOrderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *UserInfoTableViewCellIdentifier = @"UserInfoTableViewCell";
    UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserInfoTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoTableViewCell" owner:self options:nil] lastObject];
    }
    NSDictionary *dict = [self.courierOrderArray objectAtIndex:indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:[dict objectForKey:@"iconname"]];
    cell.titleLabel.text = [dict objectForKey:@"keyname"];
    return cell;
}

#pragma mark - UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self showLoginViewController]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowUserInfoViewNotification object:[[self.courierOrderArray objectAtIndex:indexPath.row] objectForKey:@"classname"]];
    }
}
@end
