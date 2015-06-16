//
//  PostPayView.m
//  SJFood
//
//  Created by MiY on 15/6/3.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "PostPayView.h"
#import "PostTableViewCell.h"



@interface PostPayView ()

@property (nonatomic, strong) NSMutableArray *payChoseArray;

@end

@implementation PostPayView

#pragma mark - UIView methods

- (void)loadFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PostPayMap" ofType:@"plist"];
    self.payChoseArray = [NSMutableArray arrayWithContentsOfFile:path];
    
    [self.payTableView reloadData];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self loadFile];
    self.payTableView.scrollEnabled = NO;
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.payChoseArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *postTableViewCellIdentifier = @"PostTableViewCell";
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:postTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PostTableViewCell" owner:self options:nil] lastObject];
    }
    
    NSDictionary *dict = [self.payChoseArray objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = [dict objectForKey:@"keyname"];
    cell.iconImageView.image = [UIImage imageNamed:[dict objectForKey:@"iconname0"]];
    
    //改为无点击效果，看上去不可点击
    if ([cell.titleLabel.text isEqualToString:@"在线支付"]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return rowHeight;
}

#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChoseKindOfPostPay"
                                                        object:[[self.payChoseArray objectAtIndex:indexPath.row] objectForKey:@"keyname"]];
    
    PostTableViewCell *cell = (PostTableViewCell *)[self.payTableView cellForRowAtIndexPath:indexPath];

    NSDictionary *dict = [self.payChoseArray objectAtIndex:indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:[dict objectForKey:@"iconname1"]];
    
    NSIndexPath *otherIndexPath = [NSIndexPath indexPathForRow:(indexPath.row+1)%2 inSection:indexPath.section];

    PostTableViewCell *otherCell = (PostTableViewCell *)[self.payTableView cellForRowAtIndexPath:otherIndexPath];
    otherCell.iconImageView.image = [UIImage imageNamed:[dict objectForKey:@"iconname0"]];
}

//改为真正的不可点击
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //根据 NSIndexPath判定行是否可选。
    
    if (indexPath.row == 1)     //1是货到付款，0是在线支付
    {
        return indexPath;
    }
    else {
        return nil;
    }
}

@end
