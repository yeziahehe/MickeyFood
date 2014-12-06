//
//  UserEditView.m
//  SJFood
//
//  Created by 叶帆 on 14/12/5.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "UserEditView.h"
#import "UserInfoTableViewCell.h"

#define kUserEditMapFileName        @"UserEditMap"

@interface UserEditView ()
@property (nonatomic, strong) NSMutableArray *userEditArray;
@end

@implementation UserEditView
@synthesize userEditTableView;
@synthesize userEditArray;

#pragma mark - Private
- (void)loadFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:kUserEditMapFileName ofType:@"plist"];
    self.userEditArray = [NSMutableArray arrayWithContentsOfFile:path];
    [self.userEditTableView reloadData];
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
    return self.userEditArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *UserInfoTableViewCellIdentifier = @"UserInfoTableViewCell";
    UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserInfoTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoTableViewCell" owner:self options:nil] lastObject];
    }
    NSDictionary *dict = [self.userEditArray objectAtIndex:indexPath.row];
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
    if ([self showLoginViewController]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowUserInfoViewNotification object:[[self.userEditArray objectAtIndex:indexPath.row] objectForKey:@"classname"]];
    }
}

@end
