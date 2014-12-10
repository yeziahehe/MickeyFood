//
//  MyAccountViewController.m
//  SJFood
//
//  Created by 叶帆 on 14/12/6.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "MyAccountViewController.h"
#import "MyAccountTableViewCell.h"
#import "MyAccountImageTableViewCell.h"
#import "NicknameEditViewController.h"
#import "PasswordEditViewController.h"
#import "ShareViewController.h"

#define kMyAccountMapFileName           @"MyAccountMap"

@interface MyAccountViewController ()
@property (nonatomic, strong) NSArray *myAccountArray;
@property (nonatomic, strong) MineInfo *mineInfo;
@end

@implementation MyAccountViewController
@synthesize MyAccountTableView;
@synthesize myAccountArray,mineInfo;

#pragma mark - Private Methods
- (void)loadSubViews
{
    NSString *tempPath = [[NSBundle mainBundle] pathForResource:kMyAccountMapFileName ofType:@"plist"];
    self.myAccountArray = [NSArray arrayWithContentsOfFile:tempPath];
    self.mineInfo = [MemberDataManager sharedManager].mineInfo;
    [self.MyAccountTableView reloadData];
}

#pragma mark - Notification Methods
- (void)refreshAccountWithNotification:(NSNotification *)notification
{
    [self loadSubViews];
}

#pragma mark - UIViewController Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"我的账号"];
    [self loadSubViews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAccountWithNotification:) name:kRefreshAccoutNotification object:nil];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.myAccountArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.myAccountArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        static NSString *cellIdentity = @"MyAccountImageTableViewCell";
        MyAccountImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
        if (nil == cell)
        {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"MyAccountImageTableViewCell" owner:self options:nil];
            cell = [nibs lastObject];
        }
        NSString *titleString = [[self.myAccountArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.titleLabel.text = titleString;
        cell.iconImageView.cacheDir = kUserIconCacheDir;
        [cell.iconImageView aysnLoadImageWithUrl:self.mineInfo.userInfo.imgUrl placeHolder:@"icon_user_image_defult.png"];
        
        return cell;
    }
    
    static NSString *cellIdentity = @"MyAccountTableViewCell";
    MyAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (nil == cell)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"MyAccountTableViewCell" owner:self options:nil];
        cell = [nibs lastObject];
    }
    NSString *titleString = [[self.myAccountArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.titleLabel.text = titleString;
    cell.detailLabel.hidden = YES;
    if (indexPath.section == 0 && indexPath.row == 1) {
        cell.detailLabel.hidden = NO;
        cell.detailLabel.text = self.mineInfo.userInfo.nickname;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *titleString = [[self.myAccountArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([titleString isEqualToString:@"头像"])
    {
        
    }
    else if ([titleString isEqualToString:@"昵称"])
    {
        NicknameEditViewController *nicknameEditViewController = [[NicknameEditViewController alloc]initWithNibName:@"NicknameEditViewController" bundle:nil];
        [self.navigationController pushViewController:nicknameEditViewController animated:YES];
    }
    else if ([titleString isEqualToString:@"修改密码"])
    {
        PasswordEditViewController *passwordEditViewController = [[PasswordEditViewController alloc]initWithNibName:@"PasswordEditViewController" bundle:nil];
        [self.navigationController pushViewController:passwordEditViewController animated:YES];
    }
    else if ([titleString isEqualToString:@"分享设置"])
    {
        ShareViewController *shareViewController = [[ShareViewController alloc]initWithNibName:@"ShareViewController" bundle:nil];
        [self.navigationController pushViewController:shareViewController animated:YES];
    }
}

@end
