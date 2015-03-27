//
//  SendOrderView.m
//  SJFood
//
//  Created by 叶帆 on 15/3/27.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "SendOrderView.h"
#import "UserInfoTableViewCell.h"

#define kSendOrderMapFileName           @"SendOrderMap"

@interface SendOrderView ()
@property (nonatomic, strong) NSMutableArray *sendOrderArray;
@end

@implementation SendOrderView
@synthesize sendOrderArray,sendOrderTableView;

#pragma mark - Private Methods
- (void)loadFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:kSendOrderMapFileName ofType:@"plist"];
    self.sendOrderArray = [NSMutableArray arrayWithContentsOfFile:path];
    [self.sendOrderTableView reloadData];
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
    return self.sendOrderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *UserInfoTableViewCellIdentifier = @"UserInfoTableViewCell";
    UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserInfoTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoTableViewCell" owner:self options:nil] lastObject];
    }
    NSDictionary *dict = [self.sendOrderArray objectAtIndex:indexPath.row];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowUserInfoViewNotification object:[[self.sendOrderArray objectAtIndex:indexPath.row] objectForKey:@"classname"]];
    }
}


@end
