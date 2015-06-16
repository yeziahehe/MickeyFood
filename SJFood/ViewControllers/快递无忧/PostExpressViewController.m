//
//  PostExpressViewController.m
//  SJFood
//
//  Created by MiY on 15/6/10.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "PostExpressViewController.h"

#import "PostSubView.h"

#import "PostUserInfoView.h"
#import "PostComChoseView.h"
#import "PostInfoView.h"
#import "PostPraiseView.h"
#import "PostTimeChoseView.h"
#import "PostPayView.h"
#import "PostSubmitButtonView.h"

#import "NoticeView.h"
#import "PostPopView.h"
#import "PostPopTimeView.h"

#import "PostTableViewCell.h"
#import "PostPopTableViewCell.h"

#import "AddressListViewController.h"
#import "AddressAddViewController.h"

#define kSubViewGap                     10.f
#define ScreenWidth                     [UIScreen mainScreen].bounds.size.width
#define ScreenHeight                    [UIScreen mainScreen].bounds.size.height
#define kGetAddressDownloaderKey        @"GetAddressDownloaderKey"

@interface PostExpressViewController () <UITextViewDelegate>

@property (nonatomic, strong) NSMutableArray *subViewArray;     //子视图数组

@property (nonatomic, strong) PostInfoView *postInfoView;       //快递短信内容TextView

@property (nonatomic, strong) NoticeView *noticeView;           //公告视图
@property (nonatomic, strong) PostPopView *comChoseView;        //快递公司选择视图
@property (nonatomic, strong) PostPopTimeView *timeChoseView;   //配送时间选择视图
@property (nonatomic, strong) UIView *background;   //darkGray背景

@property (nonatomic, strong) NSString *buffer;     //company和time的缓存
@property (nonatomic, strong) NSString *company;    //快递公司
@property (nonatomic, strong) NSString *time;       //取订单时间
@property (nonatomic, strong) NSString *price;      //订单总价
@property (nonatomic, strong) NSString *postInfo;   //快递短信内容
@property (nonatomic, strong) NSString *phoneID;    //用户手机号
@property (nonatomic, strong) NSString *kindOfPay;  //支付方式，还未写

@property (nonatomic, strong) NSMutableArray *addressArray; //地址集合
@property (nonatomic, strong) NSString *rank;               //当前地址

@property BOOL flag;    //标记，避免重复request，导致个人信息重复加载
@end

@implementation PostExpressViewController


#pragma mark - Private Methods
- (void)loadSubViews:(Address *)address
{
    for (UIView *subView in self.contentScrollView.subviews)
    {
        if ([subView isKindOfClass:[PostSubView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PostMap" ofType:@"plist"];
    self.subViewArray = [NSMutableArray arrayWithContentsOfFile:path];
    
    //加载子视图
    CGFloat originY = 0.f;
    for (NSString *classString in self.subViewArray) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:classString owner:self options:nil];
        PostSubView *postSubView = [nibs lastObject];
        CGRect rect = postSubView.frame;
        rect.origin.y = originY;
        rect.origin.x = 0.0f;
        if ([postSubView isKindOfClass:[PostUserInfoView class]]) {
            PostUserInfoView *puiv = (PostUserInfoView *)postSubView;
            
            rect.size.height = puiv.frame.size.height;
            NSLog(@"\n\n\n\n\n\n\n\n\n%f", puiv.frame.size.height);
            rect.size.width = ScreenWidth;
            originY = rect.origin.y + rect.size.height + kSubViewGap;
            
            [(PostUserInfoView *)postSubView reloadData:address];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:kReloadRefreshAddressNotification object:self.addressArray];
            
        }
        else if ([postSubView isKindOfClass:[PostComChoseView class]]) {
            PostComChoseView *pccv = (PostComChoseView *)postSubView;
            
            rect.size.height = pccv.comChoseTableView.contentSize.height-1.f;
            rect.size.width = ScreenWidth;
            originY = rect.origin.y + rect.size.height + kSubViewGap;
            
        }
        else if ([postSubView isKindOfClass:[PostInfoView class]]) {
            self.postInfoView = (PostInfoView *)postSubView;
            rect.size.height = self.postInfoView.frame.size.height;
            rect.size.width = ScreenWidth;
            originY = rect.origin.y + rect.size.height + 1.f;
            self.postInfoView.frame = rect;
            [self.contentScrollView addSubview:self.postInfoView];
            
            self.postInfoView.infoTextView.delegate = self;
            
            continue;
        }
        else if ([postSubView isKindOfClass:[PostPraiseView class]]) {
            PostPraiseView *ppv = (PostPraiseView *)postSubView;
            rect.size.height = ppv.frame.size.height;
            rect.size.width = ScreenWidth;
            originY = rect.origin.y + rect.size.height + kSubViewGap;
        }
        else if ([postSubView isKindOfClass:[PostTimeChoseView class]]) {
            PostTimeChoseView *ptcv = (PostTimeChoseView *)postSubView;
            rect.size.height = ptcv.timeChoseTableView.contentSize.height - 1.f;
            rect.size.width = ScreenWidth;
            originY = rect.origin.y + rect.size.height + kSubViewGap;
        }
        else if ([postSubView isKindOfClass:[PostPayView class]]) {
            PostPayView *ppv = (PostPayView *)postSubView;
            rect.size.height = ppv.payTableView.contentSize.height - 1.f;
            rect.size.width = ScreenWidth;
            originY = rect.origin.y + rect.size.height + kSubViewGap + 15.f;
        }
        else if ([postSubView isKindOfClass:[PostSubmitButtonView class]])
        {
            PostSubmitButtonView *psbv = (PostSubmitButtonView *)postSubView;
            rect.size.height = psbv.button.frame.size.height;
            rect.size.width = ScreenWidth;
            originY = rect.origin.y + rect.size.height + kSubViewGap;
            
            [psbv.button addTarget:self
                            action:@selector(submit:)
                  forControlEvents:UIControlEventTouchUpInside];
        }
        postSubView.frame = rect;
        [self.contentScrollView addSubview:postSubView];
    }
    
    [self.contentScrollView setContentSize:CGSizeMake(ScreenWidth, originY + 1.f)];
    
}

- (void)refreshUserInfoView:(Address *)address      //只刷新用户信息界面
{
    for (PostSubView *postSubView in self.contentScrollView.subviews) {
        if ([postSubView isKindOfClass:[PostUserInfoView class]]) {
            
            [(PostUserInfoView *)postSubView reloadData:address];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:kReloadRefreshAddressNotification object:self.addressArray];
            
            return;
        }
    }
}

- (Address *)loadDefualtAddress     //加载默认地址
{
    //找到默认地址
    for (Address *address in self.addressArray) {
        if ([address.tag isEqualToString:@"0"]) {
            self.rank = address.rank;
            return address;
        }
    }
    return nil;
}

- (void)tipToAddAddress     //添加默认地址
{
    //提示添加地址
    if (IsIos8) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:@"未添加默认地址，去添加？"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action) {
                                                    [self.navigationController popViewControllerAnimated:YES];
                                                }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action) {
                                                    AddressAddViewController *addressAddViewController = [[AddressAddViewController alloc]initWithNibName:@"AddressAddViewController" bundle:nil];
                                                    [self.navigationController pushViewController:addressAddViewController animated:YES];
                                                }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"未添加默认地址，去添加？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

- (void)requestForPostOrder
{
    [[YFProgressHUD sharedProgressHUD] showActivityViewWithMessage:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,@"package/getDeliverCom.do"];
    NSMutableDictionary *dict = kCommonParamsDict;
    [dict setObject:self.price forKey:@"price"];
    [dict setObject:self.rank forKey:@"rank"];
    [dict setObject:self.time forKey:@"reserveTime"];
    [dict setObject:@"20150615000000" forKey:@"createTime"];
    [dict setObject:self.company forKey:@"deliverType"];
    [dict setObject:self.postInfo forKey:@"message"];
    [dict setObject:[MemberDataManager sharedManager].loginMember.phone forKey:@"phoneId"];
    [[YFDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:dict
                                                            contentType:@"application/x-www-form-urlencoded"
                                                               delegate:self
                                                                purpose:@"postOrder"];
}

- (void)requestForAddressInfo
{
    [[YFProgressHUD sharedProgressHUD] showActivityViewWithMessage:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kGetAddressInfoUrl];
    NSMutableDictionary *dict = kCommonParamsDict;
    [dict setObject:[MemberDataManager sharedManager].loginMember.phone forKey:@"phoneId"];
    [[YFDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:dict
                                                            contentType:@"application/x-www-form-urlencoded"
                                                               delegate:self
                                                                purpose:kGetAddressDownloaderKey];
}

#pragma mark - UITextView Delegate Methods
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView       //开始输入前
{
    if ([textView.text isEqualToString:@"友情提醒：请务必将快递公司短信粘贴在下面备注栏，否则无法提供代取服务（请勿重复下单）"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text      //输入中
{
    if ([text isEqualToString:@"\n"]) {
        self.postInfo = textView.text;
        [textView resignFirstResponder];        //当输入回车时，去除第一响应者
        return NO;
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView        //结束输入后
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"友情提醒：请务必将快递公司短信粘贴在下面备注栏，否则无法提供代取服务（请勿重复下单）";
        textView.textColor = [UIColor grayColor];
        
    }
}

#pragma mark - Notification Methods
- (void)showPostComWithNotification:(NSNotification *)notification
{
    CGFloat width = self.comChoseView.frame.size.width;
    CGFloat height = self.comChoseView.frame.size.height;
    
    [self.navigationController.view addSubview:self.background];
    
    [self.navigationController.view addSubview:self.comChoseView];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.comChoseView setFrame:CGRectMake(0, ScreenHeight - height, width, height)];
    }];
    [self.comChoseView requestForDeliverInfo];
}

- (void)showTimeChoseWithNotification:(NSNotification *)notification
{
    CGFloat width = self.timeChoseView.frame.size.width;
    CGFloat height = self.timeChoseView.frame.size.height;
    
    [self.navigationController.view addSubview:self.background];
    
    [self.navigationController.view addSubview:self.timeChoseView];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.timeChoseView setFrame:CGRectMake(0, ScreenHeight - height, width, height)];
    }];
}

- (void)ChoseKindOfPostPay:(NSNotification *)notification
{
    self.kindOfPay = (NSString *)notification.object;
}

- (void)ChosePostCom:(NSNotification *)notification
{
    self.buffer = (NSString *)notification.object;
}

- (void)ChosePostTime:(NSNotification *)notification
{
    self.buffer = (NSString *)notification.object;
    
}

//================ YFDownLoad Notification ===============
- (void)sliderValueChanged:(NSNotification *)notification
{
    self.price = (NSString *)notification.object;
}

- (void)refreshAddressInfoWithNotification:(NSNotification *)notification
{
    [self requestForAddressInfo];
}

- (void)addressViewShowNotification:(NSNotification *)notification
{
    AddressListViewController *addressListViewController = [[AddressListViewController alloc]initWithNibName:@"AddressListViewController" bundle:nil];
    addressListViewController.addressArray = self.addressArray;
    addressListViewController.selectedAddress = notification.object;
    [self.navigationController pushViewController:addressListViewController animated:YES];
}

- (void)selectAddressNotification:(NSNotification *)notification
{
    Address *address = notification.object;
    self.rank = address.rank;
    [self loadSubViews:address];
}

#pragma mark - Initialize
- (UIView *)background
{
    if (!_background) {
        _background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, [UIScreen mainScreen].bounds.size.height)];
        _background.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.5];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(removeSubView:)];
        singleTap.numberOfTapsRequired = 1;
        [_background addGestureRecognizer:singleTap];
        
    }
    return _background;
}

- (NoticeView *)noticeView
{
    if (!_noticeView) {
        _noticeView = [[[NSBundle mainBundle] loadNibNamed:@"NoticeView" owner:self options:nil] lastObject];
        CGRect rect = _noticeView.frame;
        
        rect.size.width = ScreenWidth - 40.f;
        rect.origin.x = 20.f;
        rect.origin.y = (ScreenHeight - rect.size.height) / 2.f;
        
        _noticeView.frame = CGRectMake(ScreenWidth/2.0, ScreenHeight/2, 0, 0);
        
        [_noticeView.returnButton addTarget:self
                                     action:@selector(removeSubView:)
                           forControlEvents:UIControlEventTouchUpInside];
    }
    return _noticeView;
}

- (PostPopView *)comChoseView
{
    if (!_comChoseView) {
        _comChoseView = [[[NSBundle mainBundle] loadNibNamed:@"PostPopView" owner:self options:nil] lastObject];
        CGFloat width = ScreenWidth;
        CGFloat height = _comChoseView.frame.size.height;
        CGRect frame = CGRectMake(0, ScreenHeight, width, height);
        
        //===========add information=============
        
        
        
        
        //=======================================
        [_comChoseView setFrame:frame];
        [_comChoseView.cancelButton addTarget:self
                                       action:@selector(cancel:)
                             forControlEvents:UIControlEventTouchUpInside];
        [_comChoseView.completeButton addTarget:self
                                         action:@selector(complete:)
                               forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _comChoseView;
}

- (PostPopTimeView *)timeChoseView
{
    if (!_timeChoseView) {
        _timeChoseView = [[[NSBundle mainBundle] loadNibNamed:@"PostPopTimeView" owner:self options:nil] lastObject];
        CGFloat width = ScreenWidth;
        CGFloat height = _timeChoseView.frame.size.height;
        CGRect frame = CGRectMake(0, ScreenHeight, width, height);
        
        [_timeChoseView setFrame:frame];
        [_timeChoseView.cancelButton addTarget:self
                                        action:@selector(cancel:)
                              forControlEvents:UIControlEventTouchUpInside];
        [_timeChoseView.completeButton addTarget:self
                                          action:@selector(complete:)
                                forControlEvents:UIControlEventTouchUpInside];
    }
    return _timeChoseView;
}

#pragma mark - Universal AND IBAciton
- (IBAction)cancel:(id)sender
{
    CGFloat comWidth = self.comChoseView.frame.size.width;
    CGFloat comHeight = self.comChoseView.frame.size.height;
    CGFloat timeWidth = self.timeChoseView.frame.size.width;
    CGFloat timeHeight = self.timeChoseView.frame.size.height;
    
    for (PostSubView *postSubView in self.navigationController.view.subviews) {
        
        if ([postSubView isKindOfClass:[PostPopView class]]) {
            for (PostSubView *postSubView in self.contentScrollView.subviews) {
                
                if ([postSubView isKindOfClass:[PostComChoseView class]]) {
                    PostComChoseView *pccv = (PostComChoseView *)postSubView;
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    PostTableViewCell *cell = (PostTableViewCell *)[pccv.comChoseTableView cellForRowAtIndexPath:indexPath];
                    cell.infoLabel.text = self.company;
                    
                    [UIView animateWithDuration:0.2
                                     animations:^{
                                         [self.comChoseView setFrame:CGRectMake(0, ScreenHeight, comWidth, comHeight)];
                                     }
                                     completion:^(BOOL finished){
                                         if (finished) {
                                             [self.comChoseView removeFromSuperview];
                                             self.comChoseView = nil;
                                             
                                         }
                                     }];
                    
                    [self.background removeFromSuperview];
                    
                    return;
                }
            }
        }
        
        
        if ([postSubView isKindOfClass:[PostPopTimeView class]]) {
            for (PostSubView *postSubView in self.contentScrollView.subviews) {
                
                if ([postSubView isKindOfClass:[PostTimeChoseView class]]) {
                    PostTimeChoseView *ptcv = (PostTimeChoseView *)postSubView;
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    PostTableViewCell *cell = (PostTableViewCell *)[ptcv.timeChoseTableView cellForRowAtIndexPath:indexPath];
                    cell.infoLabel.text = self.time;
                    
                    [UIView animateWithDuration:0.2
                                     animations:^{
                                         [self.timeChoseView setFrame:CGRectMake(0, ScreenHeight, timeWidth, timeHeight)];
                                     }
                                     completion:^(BOOL finished){
                                         if (finished) {
                                             [self.timeChoseView removeFromSuperview];
                                             self.timeChoseView = nil;
                                         }
                                     }];
                    [self.background removeFromSuperview];
                    
                    return;
                }
            }
        }
    }
}

- (IBAction)complete:(id)sender
{
    CGFloat comWidth = self.comChoseView.frame.size.width;
    CGFloat comHeight = self.comChoseView.frame.size.height;
    CGFloat timeWidth = self.timeChoseView.frame.size.width;
    CGFloat timeHeight = self.timeChoseView.frame.size.height;
    
    for (PostSubView *postSubView in self.navigationController.view.subviews) {
        
        if ([postSubView isKindOfClass:[PostPopView class]]) {
            for (PostSubView *postSubView in self.contentScrollView.subviews) {
                
                if ([postSubView isKindOfClass:[PostComChoseView class]]) {
                    PostComChoseView *pccv = (PostComChoseView *)postSubView;
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    PostTableViewCell *cell = (PostTableViewCell *)[pccv.comChoseTableView cellForRowAtIndexPath:indexPath];
                    cell.infoLabel.text = self.buffer;
                    self.company = self.buffer;
                    
                    [UIView animateWithDuration:0.2
                                     animations:^{
                                         [self.comChoseView setFrame:CGRectMake(0, ScreenHeight, comWidth, comHeight)];
                                     }
                                     completion:^(BOOL finished){
                                         if (finished) {
                                             [self.comChoseView removeFromSuperview];
                                             self.comChoseView = nil;
                                             
                                         }
                                     }];
                    
                    [self.background removeFromSuperview];
                    
                    return;
                }
            }
        }
        
        if ([postSubView isKindOfClass:[PostPopTimeView class]]) {
            for (PostSubView *postSubView in self.contentScrollView.subviews) {
                
                if ([postSubView isKindOfClass:[PostTimeChoseView class]]) {
                    PostTimeChoseView *ptcv = (PostTimeChoseView *)postSubView;
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    PostTableViewCell *cell = (PostTableViewCell *)[ptcv.timeChoseTableView cellForRowAtIndexPath:indexPath];
                    cell.infoLabel.text = self.buffer;
                    self.time = self.buffer;
                    
                    [UIView animateWithDuration:0.2
                                     animations:^{
                                         [self.timeChoseView setFrame:CGRectMake(0, ScreenHeight, timeWidth, timeHeight)];
                                     }
                                     completion:^(BOOL finished){
                                         if (finished) {
                                             [self.timeChoseView removeFromSuperview];
                                             self.timeChoseView = nil;
                                         }
                                     }];
                    [self.background removeFromSuperview];
                    
                    return;
                }
            }
        }
    }
}

- (IBAction)removeSubView:(id)sender
{
    CGFloat comWidth = self.comChoseView.frame.size.width;
    CGFloat comHeight = self.comChoseView.frame.size.height;
    CGFloat timeWidth = self.timeChoseView.frame.size.width;
    CGFloat timeHeight = self.timeChoseView.frame.size.height;
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self.comChoseView setFrame:CGRectMake(0, ScreenHeight, comWidth, comHeight)];
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             [self.comChoseView removeFromSuperview];
                         }
                     }];
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self.timeChoseView setFrame:CGRectMake(0, ScreenHeight, timeWidth, timeHeight)];
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             [self.timeChoseView removeFromSuperview];
                         }
                     }];
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self.noticeView setFrame:CGRectMake(ScreenWidth - 20.f, 44.f, 0, 0)];
                         //以下缩放动画，建议动画时间0.3，要用就注释掉下面滑退动画
                         //[self.noticeView setFrame:CGRectMake(ScreenWidth/2.0, ScreenHeight/2, 0, 0)];
                         //以下滑退动画，还是喜欢这个
                         [self.noticeView setFrame:CGRectMake(ScreenWidth, (ScreenHeight - 200.f)/2.f, ScreenWidth-40.f, 200.f)];
                         
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             [self.noticeView removeFromSuperview];
                             
                             self.noticeView = nil;
                            
                         }
                     }];
    [self.background removeFromSuperview];
}

- (void)rightItemTapped
{
    BOOL flag = NO;
    for (PostSubView *postSubView in self.contentScrollView.subviews) {
        if ([postSubView isKindOfClass:[NoticeView class]]) {
            flag = YES;
        }
    }
    if (flag == NO) {
        
        [self.navigationController.view addSubview:self.background];
        [self.navigationController.view addSubview:self.noticeView];
        
        [UIView animateWithDuration:0.4
                              delay:0.1
             usingSpringWithDamping:0.6
              initialSpringVelocity:1.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.noticeView setFrame:CGRectMake(20.f, (ScreenHeight - 200.f)/2.f, ScreenWidth-40.f, 200.f)];
                         }
                         completion:nil];
    }
    
}

- (BOOL)showLoginViewController
{
    if ([[MemberDataManager sharedManager] isLogin])
    {
        return YES;
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowLoginViewNotification object:nil];
        return NO;
    }
}


#pragma mark - Submit Button Methods
- (IBAction)submit:(id)sender       //提交按钮
{
    if (self.price == nil) {
        self.price = [NSString stringWithFormat:@"1"];
    }

    NSString *message = @"";
    if (self.time == nil) {
        message = @"请选择配送时间!";
        [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:message hideDelay:2.f];
    } else if (self.company == nil) {
        message = @"请选择快递公司!";
        [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:message hideDelay:2.f];
    } else if (self.postInfo == nil) {
        message = @"请填写快递信息!";
        [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:message hideDelay:2.f];
    } else {
        [self requestForPostOrder];
    }
}


#pragma mark - ViewController Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.flag = YES;
    
    UINavigationBar *bar = self.navigationController.navigationBar;
    UIColor *myColor = [UIColor colorWithRed:80/255.0 green:211/255.0 blue:191/255.0 alpha:1];
    
    [self.view setTintColor:myColor];
    bar.tintColor = [UIColor whiteColor];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [bar setBarTintColor:myColor];
    
    [self setRightNaviItemWithTitle:@"公告" imageName:nil];
    [self setNaviTitle:@"快递无忧"];
    
    [self loadSubViews:[self loadDefualtAddress]];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPostComWithNotification:)
                                                 name:@"showPostComWithNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTimeChoseWithNotification:)
                                                 name:@"showTimeChoseWithNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChoseKindOfPostPay:)
                                                 name:@"ChoseKindOfPostPay"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChosePostCom:)
                                                 name:@"ChosePostCom"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChosePostTime:)
                                                 name:@"ChosePostTime"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sliderValueChanged:)
                                                 name:@"sliderValueChanged"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressViewShowNotification:)
                                                 name:kAddressViewShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAddressInfoWithNotification:)
                                                 name:kRefreshAddressNotification
                                               object:nil];
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectAddressNotification:)
                                                 name:kSelectAddressNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //重新设置导航栏颜色
    UINavigationBar *bar = self.navigationController.navigationBar;
    UIColor *myColor = [UIColor colorWithRed:80/255.0 green:211/255.0 blue:191/255.0 alpha:1];
    bar.tintColor = [UIColor whiteColor];
    [self.view setTintColor:myColor];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [bar setBarTintColor:myColor];
    
    if ([MemberDataManager sharedManager].loginMember.phone == nil) {
        [self loadSubViews:[self loadDefualtAddress]];
    }
    else {
        if (self.flag == YES) {
            [self requestForAddressInfo];
            self.flag = NO;
        }
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[YFDownloaderManager sharedManager]cancelDownloaderWithDelegate:self purpose:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - YFDownloaderDelegate Methods
- (void)downloader:(YFDownloader *)downloader completeWithNSData:(NSData *)data
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [str JSONValue];

    if ([downloader.purpose isEqualToString:kGetAddressDownloaderKey])
    {
        if ([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode])
        {
            [[YFProgressHUD sharedProgressHUD] stoppedNetWorkActivity];
            self.addressArray = [NSMutableArray arrayWithCapacity:0];
            NSArray *valueArray = [dict objectForKey:@"receivers"];
            for(NSDictionary *valueDict in valueArray)
            {
                Address *address = [[Address alloc] initWithDict:valueDict];
                [self.addressArray addObject:address];
            }
            if (self.addressArray.count > 0) {
                //找到默认地址
                [self refreshUserInfoView:[self loadDefualtAddress]];
            } else {
                //提示添加地址
                [self tipToAddAddress];
            }
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if ([message isKindOfClass:[NSNull class]])
            {
                message = @"";
            }
            if(message.length == 0)
                message = @"收货地址获取失败";
            [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:message hideDelay:2.f];
        }
    }
    else if ([downloader.purpose isEqualToString:@"postOrder"]) {
        if ([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode])
        {
           // [[YFProgressHUD sharedProgressHUD] stoppedNetWorkActivity];
            NSString *message = @"提交成功！";
            [[YFProgressHUD sharedProgressHUD] showSuccessViewWithMessage:message hideDelay:2.f];
        }
    }

}

- (void)downloader:(YFDownloader *)downloader didFinishWithError:(NSString *)message
{
    [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:kNetWorkErrorString hideDelay:2.f];
}


@end
