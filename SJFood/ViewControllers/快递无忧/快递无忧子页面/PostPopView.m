//
//  PostPopView.m
//  Post
//
//  Created by MiY on 15/6/8.
//  Copyright (c) 2015年 MiY. All rights reserved.
//

#import "PostPopView.h"
#import "PostPopTableViewCell.h"

@interface PostPopView ()

@property (nonatomic, strong) NSMutableArray *comChoseArray;

@end

@implementation PostPopView

#pragma mark - Private
- (void)requestForDeliverInfo
{
    [[YFProgressHUD sharedProgressHUD] showActivityViewWithMessage:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,@"package/getDeliverCom.do"];
    NSMutableDictionary *dict = kCommonParamsDict;
    
    [dict setObject:[MemberDataManager sharedManager].loginMember.phone forKey:@"phoneId"];
    [[YFDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:dict
                                                            contentType:@"application/x-www-form-urlencoded"
                                                               delegate:self
                                                                purpose:@"package"];
}

#pragma mark - UIView methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.tintColor = [UIColor colorWithRed:80/255.0 green:211/255.0 blue:191/255.0 alpha:1];

    self.comChoseTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.cancelButton.tintColor = [UIColor grayColor];
    [self.comChoseTableView reloadData];

}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.comChoseArray.count;
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

    NSDictionary *dict = [self.comChoseArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = [dict objectForKey:@"category"];
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    PostPopTableViewCell *cell = (PostPopTableViewCell *)[self.comChoseTableView cellForRowAtIndexPath:indexPath];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChosePostCom"
                                                        object:cell.titleLabel.text];
    
}


#pragma mark - YFDownload Delegate Methods
- (void)downloader:(YFDownloader *)downloader completeWithNSData:(NSData *)data
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [str JSONValue];
    
    if ([downloader.purpose isEqualToString:@"package"])
    {
        
        if([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode])
        {
            [[YFProgressHUD sharedProgressHUD] stoppedNetWorkActivity];
            
            self.comChoseArray = [dict objectForKey:@"deliverCom"];
            [self.comChoseTableView reloadData];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if ([message isKindOfClass:[NSNull class]])
            {
                message = @"";
            }
            if(message.length == 0)
                message = @"快递公司获取失败";
            [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:message hideDelay:2.f];
        }
    }
}


@end
