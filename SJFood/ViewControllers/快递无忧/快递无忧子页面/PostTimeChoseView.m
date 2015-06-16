//
//  PostTimeChoseView.m
//  SJFood
//
//  Created by MiY on 15/6/3.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "PostTimeChoseView.h"
#import "PostTableViewCell.h"

@interface PostTimeChoseView ()

@property (nonatomic, strong) NSMutableArray *timeChoseArray;

@end

@implementation PostTimeChoseView


- (void)loadFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PostTimeChoseMap" ofType:@"plist"];
    self.timeChoseArray = [NSMutableArray arrayWithContentsOfFile:path];
    
    [self.timeChoseTableView reloadData];
}


#pragma mark - UIView methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self loadFile];
    self.timeChoseTableView.scrollEnabled = NO;    
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.timeChoseArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *postTableViewCellIdentifier = @"PostTableViewCell";
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:postTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PostTableViewCell" owner:self options:nil] lastObject];
    }
    NSDictionary *dict = [self.timeChoseArray objectAtIndex:indexPath.row];
    
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showTimeChoseWithNotification"
                                                        object:nil];
    
}


@end
