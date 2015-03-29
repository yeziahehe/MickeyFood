//
//  SettingViewController.m
//  SJFood
//
//  Created by 叶帆 on 14/12/6.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"
#import "WelcomeViewController.h"
#import "AboutAppViewController.h"

#define kSettingMapFileName         @"SettingMap"

@interface SettingViewController ()
@property (nonatomic, strong) NSArray *menuArray;
@property (nonatomic, strong) NSString *isNewVersion;
@end

@implementation SettingViewController
@synthesize settingTableView,logoutView,messageView;
@synthesize menuArray,isNewVersion;

#pragma mark - Private Methods
- (void)loadSubViews
{
    NSString *tempPath = [[NSBundle mainBundle] pathForResource:kSettingMapFileName ofType:@"plist"];
    self.menuArray = [NSArray arrayWithContentsOfFile:tempPath];
    [self refreshSetting];
}

- (void)refreshSetting
{
    if ([[MemberDataManager sharedManager] isLogin])
    {
        self.settingTableView.tableFooterView = self.logoutView;
    }
    else
    {
        self.settingTableView.tableFooterView = [UIView new];
    }
    [self.settingTableView reloadData];
}

#pragma mark - IBAction Methods
- (IBAction)logoutButtonClicked:(id)sender {
    if (IsIos8) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"退出"
                                                                       message:@"确定退出登录？"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action) {
                                                }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action) {
                                                    [[MemberDataManager sharedManager] logout];
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:kUserChangeNotification object:nil];
                                                    [self.tabBarController setSelectedIndex:0];
                                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                                }]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退出" message:@"确定退出登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1;
        [alert show];
    }
}

#pragma mark - UIViewController Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"设置"];
    [self loadSubViews];
}

#pragma mark - AlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 1)
        {
            [[MemberDataManager sharedManager] logout];
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserChangeNotification object:nil];
            [self.tabBarController setSelectedIndex:0];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    else if (alertView.tag == 2)
    {
        if (buttonIndex == 1)
        {
            [[YFProgressHUD sharedProgressHUD] showMixedWithLoading:@"清除缓存..." end:@"清理完成"];
            [YFAppBackgroudConfiger clearAllCachesWhenBiggerThanSize:0];
        }
    }
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.menuArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.menuArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"SettingTableViewCell";
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (nil == cell)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"SettingTableViewCell" owner:self options:nil];
        cell = [nibs lastObject];
    }
    
    NSString *titleString = [[self.menuArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    cell.detailLabel.hidden = YES;
    cell.titleLabel.text = titleString;
    
    if ((indexPath.section == 1) || indexPath.section == 0)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if (indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSInteger notifyTypes;
        if (IsIos8) {
            notifyTypes = [[[UIApplication sharedApplication] currentUserNotificationSettings] types];
        } else {
            notifyTypes =  [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        }
        cell.detailLabel.hidden = NO;
        if(notifyTypes & UIRemoteNotificationTypeAlert)
        {
            cell.detailLabel.text = @"已开启";
            cell.detailLabel.textColor = [UIColor colorWithRed:79.f/255.0 green:160.f/255.0 blue:97.f/255.0 alpha:1.0];
        }
        else
        {
            cell.detailLabel.text = @"未开启";
            cell.detailLabel.textColor = [UIColor colorWithRed:255.f/255.0 green:124.f/255.0 blue:106.f/255.0 alpha:1.0];
        }
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return self.messageView;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return self.messageView.frame.size.height;
    }
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
    NSString *titleString = [[self.menuArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([titleString isEqualToString:@"清除缓存"])
    {
        if (IsIos8) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"清除缓存"
                                                                           message:@"是否清除缓存？"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                    }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        [[YFProgressHUD sharedProgressHUD] showMixedWithLoading:@"清除缓存..." end:@"清理完成"];
                                                        [YFAppBackgroudConfiger clearAllCachesWhenBiggerThanSize:0];
                                                    }]];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"清除缓存" message:@"是否清除缓存？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 2;
            [alertView show];
        }
    }
    else if ([titleString isEqualToString:@"欢迎页面"])
    {
        WelcomeViewController *welcomeViewCtroller = [[WelcomeViewController alloc]initWithNibName:@"WelcomeViewController" bundle:nil];
        [self.navigationController pushViewController:welcomeViewCtroller animated:YES];
    }
    else if ([titleString isEqualToString:@"给我评分"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:kAppRateUrl, kAppAppleId]]];
    }
    else if ([titleString isEqualToString:@"关于我们"])
    {
        AboutAppViewController *aboutAppViewController = [[AboutAppViewController alloc]initWithNibName:@"AboutAppViewController" bundle:nil];
        [self.navigationController pushViewController:aboutAppViewController animated:YES];
    }
}

@end
