//
//  ShareViewController.m
//  SJFood
//
//  Created by 叶帆 on 14/12/7.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "ShareViewController.h"
#import "ShareTableViewCell.h"

#define kShareSettingMapFileName        @"ShareSettingMap"

@interface ShareViewController ()
@property (nonatomic, strong) NSMutableArray *shareArray;
@end

@implementation ShareViewController
@synthesize shareTableView;
@synthesize shareArray;

#pragma mark - Private Methods
- (void)loadFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:kShareSettingMapFileName ofType:@"plist"];
    self.shareArray = [NSMutableArray arrayWithContentsOfFile:path];
    [self.shareTableView reloadData];
}

#pragma mark - UIViewController Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"分享设置"];
    [self loadFile];
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shareArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ShareTableViewCellIdentifier = @"ShareTableViewCell";
    ShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ShareTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ShareTableViewCell" owner:self options:nil] lastObject];
    }
    NSDictionary *dict = [self.shareArray objectAtIndex:indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:[dict objectForKey:@"iconname"]];
    cell.titleLabel.text = [dict objectForKey:@"keyname"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
}

@end
