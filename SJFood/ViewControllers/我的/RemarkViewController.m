//
//  RemarkViewController.m
//  SJFood
//
//  Created by 叶帆 on 15/3/26.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "RemarkViewController.h"

#define kCreateCommentDownloaderKey         @"CreateCommentDownloaderKey"

@interface RemarkViewController ()
@property (nonatomic, strong) NSString *grade;
@end

@implementation RemarkViewController
@synthesize orderDetails,contentScrollView;
@synthesize nameLabel,foodImageVIew,commentTextView,commentButton;
@synthesize firstStarButton,scondStarButton,thirdStarButton,fourthStarButton,fifthStarButton;

#pragma mark - Pricate Methods
- (void)loadSubViews
{
    self.grade = @"0";
    self.nameLabel.text = self.orderDetails.name;
    self.foodImageVIew.cacheDir = kUserIconCacheDir;
    [self.foodImageVIew aysnLoadImageWithUrl:self.orderDetails.imageUrl placeHolder:@"loading_square.png"];
}

- (NSString *)checkFieldValid
{
    if([self.grade isEqualToString:@"0"])
        return @"请选择评分等级";
    return nil;
}

#pragma mark - IBAction Methods
- (IBAction)commentButtonClicked:(id)sender {
    [self.commentTextView resignFirstResponder];
    NSString *validString = [self checkFieldValid];
    if(validString)
    {
        [[YFProgressHUD sharedProgressHUD] showWithMessage:validString customView:nil hideDelay:4.f];
    }
    else
    {
        if (commentTextView.text.length <= 0) {
            commentTextView.text = @"";
        }
        NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kCreateCommentUrl];
        NSMutableDictionary *dict = kCommonParamsDict;
        [dict setObject:[MemberDataManager sharedManager].loginMember.phone forKey:@"phoneId"];
        [dict setObject:self.orderDetails.foodId forKey:@"foodId"];
        [dict setObject:self.orderDetails.orderId forKey:@"orderId"];
        [dict setObject:self.grade forKey:@"grade"];
        [dict setObject:self.commentTextView.text forKey:@"comment"];
        [[YFDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                                 postParams:dict
                                                                contentType:@"application/x-www-form-urlencoded"
                                                                   delegate:self purpose:kCreateCommentDownloaderKey];
    }
}

- (IBAction)starButtonClicked:(UIButton *)sender {
    self.grade = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    switch (sender.tag) {
        case 1:
        {
            self.firstStarButton.selected = YES;
            self.scondStarButton.selected = NO;
            self.thirdStarButton.selected = NO;
            self.fourthStarButton.selected = NO;
            self.fifthStarButton.selected = NO;
        }
            break;
            
        case 2:
        {
            self.firstStarButton.selected = YES;
            self.scondStarButton.selected = YES;
            self.thirdStarButton.selected = NO;
            self.fourthStarButton.selected = NO;
            self.fifthStarButton.selected = NO;
        }
            break;
            
        case 3:
        {
            self.firstStarButton.selected = YES;
            self.scondStarButton.selected = YES;
            self.thirdStarButton.selected = YES;
            self.fourthStarButton.selected = NO;
            self.fifthStarButton.selected = NO;
        }
            break;
            
        case 4:
        {
            self.firstStarButton.selected = YES;
            self.scondStarButton.selected = YES;
            self.thirdStarButton.selected = YES;
            self.fourthStarButton.selected = YES;
            self.fifthStarButton.selected = NO;
        }
            break;
            
        case 5:
        {
            self.firstStarButton.selected = YES;
            self.scondStarButton.selected = YES;
            self.thirdStarButton.selected = YES;
            self.fourthStarButton.selected = YES;
            self.fifthStarButton.selected = YES;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UIViewController Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"评价订单"];
    [self loadSubViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self.contentScrollView setContentSize:CGSizeMake(ScreenWidth, self.commentButton.frame.origin.y + self.commentButton.frame.size.height + 15.f)];
}

- (void)dealloc
{
    [[YFDownloaderManager sharedManager] cancelDownloaderWithDelegate:self purpose:nil];
}

#pragma mark - Keyboard Notification methords
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.contentScrollView.contentInset = UIEdgeInsetsMake(self.contentScrollView.contentInset.top, self.contentScrollView.contentInset.left, keyboardSize.height, self.contentScrollView.contentInset.right);
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.contentScrollView.contentInset = UIEdgeInsetsMake(self.contentScrollView.contentInset.top, self.contentScrollView.contentInset.left, 0, self.contentScrollView.contentInset.right);
}


#pragma mark - UITextViewDelegate methods
- (void)resignAllField
{
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignAllField];
}

#pragma mark - YFDownloaderDelegate Methods
- (void)downloader:(YFDownloader *)downloader completeWithNSData:(NSData *)data
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [str JSONValue];
    if ([downloader.purpose isEqualToString:kCreateCommentDownloaderKey])
    {
        if([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode])
        {
            [[YFProgressHUD sharedProgressHUD] showSuccessViewWithMessage:@"提交成功" hideDelay:2.f];
            [[NSNotificationCenter defaultCenter] postNotificationName:kCommentSuccessNotification object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if ([message isKindOfClass:[NSNull class]])
            {
                message = @"";
            }
            if(message.length == 0)
                message = @"提交失败";
            [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:message hideDelay:2.f];
        }
    }
}

- (void)downloader:(YFDownloader *)downloader didFinishWithError:(NSString *)message
{
    [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:kNetWorkErrorString hideDelay:2.f];
}

@end
