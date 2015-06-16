//
//  PostComChoseView.m
//  SJFood
//
//  Created by MiY on 15/6/3.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "PostComChoseView.h"
#import "PostTableViewCell.h"

@interface PostComChoseView ()

@property (nonatomic, strong) NSMutableArray *comChoseArray;

@end

@implementation PostComChoseView

#pragma mark - Private
- (void)loadFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PostComChoseMap" ofType:@"plist"];
    self.comChoseArray = [NSMutableArray arrayWithContentsOfFile:path];
    [self.comChoseTableView reloadData];
}

#pragma mark - UIView methods
- (void)awakeFromNib
{
    
    [super awakeFromNib];
    [self loadFile];
    self.comChoseTableView.scrollEnabled = NO;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.comChoseArray count];
}

#pragma mark - UITableViewDataSource Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *postTableViewCellIdentifier = @"PostTableViewCell";

    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:postTableViewCellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PostTableViewCell" owner:self options:nil] lastObject];
    }
    NSDictionary *dict = [self.comChoseArray objectAtIndex:indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:[dict objectForKey:@"iconname"]];
    cell.titleLabel.text = [dict objectForKey:@"keyname"];
    
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showPostComWithNotification"
                                                        object:nil];
    
}

@end
