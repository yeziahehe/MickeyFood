//
//  PostPopTimeView.m
//  Post
//
//  Created by MiY on 15/6/9.
//  Copyright (c) 2015年 MiY. All rights reserved.
//

#import "PostPopTimeView.h"
#import "PostPopTableViewCell.h"

@interface PostPopTimeView ()

@property (nonatomic, strong) NSMutableArray *timeChoseArray;

@end

@implementation PostPopTimeView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

#pragma mark - Private
- (void)loadFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PostTimeInfoMap" ofType:@"plist"];
    self.timeChoseArray = [NSMutableArray arrayWithContentsOfFile:path];
    self.cancelButton.tintColor = [UIColor grayColor];
    [self.timeChoseTableView reloadData];
}

#pragma mark - UIView methods
- (void)awakeFromNib
{
    
    [super awakeFromNib];
    self.tintColor = [UIColor colorWithRed:80/255.0 green:211/255.0 blue:191/255.0 alpha:1];
    //    self.comChoseTableView.layer.borderWidth = 0.f;
    //    self.comChoseTableView.separatorColor = [UIColor whiteColor];
    self.timeChoseTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self loadFile];
    //self.comChoseTableView.scrollEnabled = NO;
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.timeChoseArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *postPopTableViewCellIdentifier = @"PostPopTableViewCell";
    
    PostPopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:postPopTableViewCellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PostPopTableViewCell" owner:self options:nil] lastObject];
    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:80/255.0 green:211/255.0 blue:191/255.0 alpha:1];
    
    NSDictionary *dict = [self.timeChoseArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = [dict objectForKey:@"keyname"];
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];

    PostPopTableViewCell *cell = (PostPopTableViewCell *)[self.timeChoseTableView cellForRowAtIndexPath:indexPath];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChosePostTime"
                                                        object:cell.titleLabel.text];

    
}

@end
