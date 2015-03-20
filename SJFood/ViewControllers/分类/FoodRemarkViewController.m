//
//  FoodRemarkViewController.m
//  SJFood
//
//  Created by 叶帆 on 15/3/19.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "FoodRemarkViewController.h"
#import "FoodRemarkTableViewCell.h"
#import "FoodComment.h"

#define kLastIdInit                 @"0"
#define kGetCommentsDownloadKey     @"GetCommentsDownloadKey"

@interface FoodRemarkViewController ()
@property (nonatomic, strong) NSMutableArray *remarkArray;
@property (nonatomic, strong) NSString *lastestId;
@property (nonatomic, strong) FoodComment *foodComment;
@end

@implementation FoodRemarkViewController
@synthesize remarkTableView,remarkArray,foodId;
@synthesize lastestId;
@synthesize messageFooterView,loadMessageLabel;
@synthesize foodComment;

#pragma mark - Private Methods
- (void)loadSubViews
{
    [self.remarkTableView reloadData];
}

- (void)requstForRemarkWithFoodId:(NSString *)foodIdString withPage:(NSString *)page
{
    if (page == nil) {
        page = @"0";
    }
    self.lastestId = page;
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kGetCommentsUrl];
    NSMutableDictionary *dict = kCommonParamsDict;
    [dict setObject:foodIdString forKey:@"foodId"];
    [dict setObject:page forKey:@"page"];
    [[YFDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:dict
                                                            contentType:@"application/x-www-form-urlencoded"
                                                               delegate:self
                                                                purpose:kGetCommentsDownloadKey];
}

- (void)refreshFooter
{
    NSString *more = kLastIdInit;
    if (self.remarkArray.count != 0) {
        more = self.lastestId;
    }
    [self requstForRemarkWithFoodId:self.foodId withPage:more];
}

#pragma mark - BaseViewController Methods
- (void)extraItemTapped
{
    [self.remarkTableView setContentOffset:CGPointMake(0, -self.remarkTableView.contentInset.top) animated:YES];
}

#pragma mark - UIViewController Methods
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [[YFProgressHUD sharedProgressHUD] stoppedNetWorkActivity];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"评论详情"];
    self.remarkTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.lastestId = kLastIdInit;
    self.remarkArray = [NSMutableArray arrayWithCapacity:0];
    self.remarkTableView.tableFooterView = [UIView new];
    [self.remarkTableView addFooterWithTarget:self action:@selector(refreshFooter)];
    [[YFProgressHUD sharedProgressHUD] showActivityViewWithMessage:@"加载中..."];
    [self requstForRemarkWithFoodId:self.foodId withPage:kLastIdInit];
}

- (void)dealloc
{
    [[YFDownloaderManager sharedManager] cancelDownloaderWithDelegate:self purpose:nil];
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.remarkArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *FoodRemarkTableViewCellIdentifier = @"FoodRemarkTableViewCell";
    FoodRemarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FoodRemarkTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FoodRemarkTableViewCell" owner:self options:nil] lastObject];
    }
    self.foodComment = [self.remarkArray objectAtIndex:indexPath.row];
    cell.userIconImage.cacheDir = kUserIconCacheDir;
    [cell.userIconImage aysnLoadImageWithUrl:self.foodComment.imgUrl placeHolder:@"loading_square.png"];
    cell.gradeLabel.text = [NSString stringWithFormat:@"%@星",self.foodComment.grade];
    cell.nicknameLabel.text = self.foodComment.nickName;
    cell.dateLabel.text = self.foodComment.date;
    cell.remarkLabel.text = self.foodComment.comment;
    
    CGRect cellFrame = cell.frame;
    CGFloat height = [YFCommonMethods measureHeightOfUILabel:cell.remarkLabel];
    CGRect detailFrame = cell.remarkLabel.frame;
    detailFrame.size.height = height;
    cell.remarkLabel.frame = detailFrame;
    cellFrame.size.height += height-21.f;
    cell.frame = cellFrame;
    return cell;
}

#pragma mark - UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:self.remarkTableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - YFDownloaderDelegate Methods
- (void)downloader:(YFDownloader *)downloader completeWithNSData:(NSData *)data
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [str JSONValue];
    if ([downloader.purpose isEqualToString:kGetCommentsDownloadKey])
    {
        [self.remarkTableView footerEndRefreshing];
        [[YFProgressHUD sharedProgressHUD] stoppedNetWorkActivity];
        if([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode])
        {
            NSMutableArray *valueArray = [dict objectForKey:@"foodComments"];
            
            if ([self.lastestId isEqualToString:kLastIdInit])
            {
                //第一次加载
                [self.remarkTableView setContentOffset:CGPointMake(0, -self.remarkTableView.contentInset.top) animated:NO];
                if (valueArray.count == 0)
                {
                    [self.remarkTableView removeFooter];
                    self.loadMessageLabel.text = @"暂无评论";
                    self.remarkTableView.tableFooterView = self.messageFooterView;
                }
                else
                {
                    for (NSDictionary *valueDict in valueArray) {
                        FoodComment *fc = [[FoodComment alloc]initWithDict:valueDict];
                        [self.remarkArray addObject:fc];
                    }
                    self.lastestId = @"1";
                    if (valueArray.count < 10)
                    {
                        [self.remarkTableView removeFooter];
                        self.loadMessageLabel.text = @"已加载全部评论";
                        self.remarkTableView.tableFooterView = self.messageFooterView;
                    }
                }
            }
            else
            {
                //下拉获取更多
                if (valueArray.count == 0)
                {
                    [self.remarkTableView removeFooter];
                    self.loadMessageLabel.text = @"已加载全部评论";
                    self.remarkTableView.tableFooterView = self.messageFooterView;
                }
                else
                {
                    for (NSDictionary *valueDict in valueArray) {
                        FoodComment *fc = [[FoodComment alloc]initWithDict:valueDict];
                        [self.remarkArray addObject:fc];
                    }
                    NSString *previousId = [NSString stringWithFormat:@"%ldd",[self.lastestId integerValue] + 1];
                    self.lastestId = previousId;
                    if (valueArray.count < 10)
                    {
                        [self.remarkTableView removeFooter];
                        self.loadMessageLabel.text = @"已加载全部评论";
                        self.remarkTableView.tableFooterView = self.messageFooterView;
                    }

                }
            }
            [self loadSubViews];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if ([message isKindOfClass:[NSNull class]])
            {
                message = @"";
            }
            if(message.length == 0)
                message = @"加载失败";
            [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:message hideDelay:2.f];
        }
    }
}

- (void)downloader:(YFDownloader *)downloader didFinishWithError:(NSString *)message
{
    [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:kNetWorkErrorString hideDelay:2.f];
}

@end
