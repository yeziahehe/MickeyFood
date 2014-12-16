//
//  CategoryTableView.m
//  SJFood
//
//  Created by 叶帆 on 14/12/16.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "CategoryTableView.h"
#import "CategoryTableViewCell.h"
#import "FoodCategory.h"

@interface CategoryTableView ()
@property (nonatomic, strong) NSMutableArray *categoryTableArray;
@property (nonatomic, strong) FoodCategory *foodCategory;
@end

@implementation CategoryTableView
@synthesize categoryTableView;
@synthesize categoryTableArray,foodCategory;

#pragma mark - Public Methods
- (void)reloadWithCategory:(NSMutableArray *)category
{
    self.categoryTableArray = category;
    [self.categoryTableView zeroSeparatorInset];
    self.categoryTableView.tableFooterView = [UIView new];
    [self.categoryTableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.categoryTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
}

#pragma mark - UIView Methods
- (void)awakeFromNib
{
    [super awakeFromNib];
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.categoryTableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"CategoryTableViewCell";
    CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (nil == cell)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"CategoryTableViewCell" owner:self options:nil];
        cell = [nibs lastObject];
        UIImageView *selectedView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab_select_bg.png"]];
        cell.selectedBackgroundView = selectedView;
    }
    self.foodCategory = [self.categoryTableArray objectAtIndex:indexPath.row];
    [cell zeroSeparatorInset];
    cell.titleLabel.textColor = kMainBlackColor;
    cell.titleLabel.text = self.foodCategory.category;
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kCategoryTableViewSelectedNotificaition object:[NSNumber numberWithInteger:indexPath.row]];
}

@end
