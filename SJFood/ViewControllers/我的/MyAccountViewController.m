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
#define kUploadImageDownloadKey         @"UploadImageDownloadKey"

@interface MyAccountViewController ()
@property (nonatomic, strong) NSArray *myAccountArray;
@property (strong, nonatomic) NSData *imageData;
@property (strong, nonatomic) NSString *imageFileName;
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

- (void)uploadImageRequestForImageFile:(NSData *)imageFile
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kUploadImageUrl];
    NSMutableDictionary *dict = kCommonParamsDict;
    [dict setObject:[MemberDataManager sharedManager].loginMember.phone forKey:@"phoneId"];
    [dict setObject:[YFCommonMethods base64StringFromData:imageFile length:0] forKey:@"image"];
    [[YFDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:dict
                                                            contentType:@"application/x-www-form-urlencoded"
                                                               delegate:self
                                                                purpose:kUploadImageDownloadKey];
    [[YFProgressHUD sharedProgressHUD] showActivityViewWithMessage:@"上传头像中..."];
}

#pragma mark - Notification Methods
- (void)refreshAccountWithNotification:(NSNotification *)notification
{
    [self loadSubViews];
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
    [self setNaviTitle:@"我的账号"];
    [self loadSubViews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAccountWithNotification:) name:kRefreshAccoutNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        if (IsIos8) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"上传头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                      style:UIAlertActionStyleCancel
                                                    handler:^(UIAlertAction *action) {
                                                    }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"拍照"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        //拍照
                                                        [YFMediaPicker sharedPicker].parentController = self;
                                                        [YFMediaPicker sharedPicker].delegate = self;
                                                        [YFMediaPicker sharedPicker].fileType = kPhotoType;
                                                        [[YFMediaPicker sharedPicker] takePhotoWithCamera];
                                                    }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"相册选取"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        //从相册选取
                                                        [YFMediaPicker sharedPicker].parentController = self;
                                                        [YFMediaPicker sharedPicker].delegate = self;
                                                        [YFMediaPicker sharedPicker].fileType = kPhotoType;
                                                        [[YFMediaPicker sharedPicker] getPhotoFromLibrary];
                                                    }]];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"上传头像"
                                                                     delegate:self
                                                            cancelButtonTitle:@"取消"
                                                       destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册选取",nil];
            [actionSheet showInView:self.view];
        }
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

#pragma mark - YFMediaPickerDelegate methods
- (void)didGetFileWithData:(YFMediaPicker *)mediaPicker
{
    //编辑过的图片尺寸640*640，大小约350KB，压缩为120*120大小的图片，约20KB
    //本地保存当前选中的图片，同时上传至服务器
    UIImage *originalImage = [UIImage imageWithData:mediaPicker.fileData];
    CGSize userIconSize = [UIImage equalScaleSizeForMaxSize:CGSizeMake(640.f, 640.f) actualSize:originalImage.size];
    UIImage *userIconImage = [originalImage imageByScalingProportionallyToSize:userIconSize];
    
    NSString *userIconDir = [DOCUMENTS_FOLDER stringByAppendingPathComponent:kUserIconCacheDir];
    NSString *userIconPath = [NSString stringWithFormat:@"%@/%@",userIconDir,mediaPicker.fileName];
    NSFileManager *manager = [NSFileManager defaultManager];
    if(![manager fileExistsAtPath:userIconDir])
        [manager createDirectoryAtPath:userIconDir withIntermediateDirectories:NO attributes:nil error:nil];
    NSData *userIconData = UIImageJPEGRepresentation(userIconImage, 1);
    [userIconData writeToFile:userIconPath atomically:NO];
    
    self.imageData = userIconData;
    self.imageFileName = mediaPicker.fileName;
    //上传图片请求
    [self uploadImageRequestForImageFile:self.imageData];
}

- (void)didGetFileFailedWithMessage:(NSString *)message
{
    [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:message hideDelay:2.0f];
}

#pragma mark - UIActionSheet Delegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //拍照
        [YFMediaPicker sharedPicker].parentController = self;
        [YFMediaPicker sharedPicker].delegate = self;
        [YFMediaPicker sharedPicker].fileType = kPhotoType;
        [[YFMediaPicker sharedPicker] takePhotoWithCamera];
    }else if (buttonIndex == 1) {
        //从相册选取
        [YFMediaPicker sharedPicker].parentController = self;
        [YFMediaPicker sharedPicker].delegate = self;
        [YFMediaPicker sharedPicker].fileType = kPhotoType;
        [[YFMediaPicker sharedPicker] getPhotoFromLibrary];
    }
}

#pragma mark - YFDownloaderDelegate Methods
- (void)downloader:(YFDownloader *)downloader completeWithNSData:(NSData *)data
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [str JSONValue];
    if ([downloader.purpose isEqualToString:kUploadImageDownloadKey])
    {
        if([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode])
        {
            [[YFProgressHUD sharedProgressHUD] showSuccessViewWithMessage:@"上传头像成功" hideDelay:2.f];
            [self loadSubViews];
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
            message = @"上传头像失败";
        [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:message hideDelay:2.f];
    }
}

- (void)downloader:(YFDownloader *)downloader didFinishWithError:(NSString *)message
{
    NSLog(@"%@",message);
    [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:kNetWorkErrorString hideDelay:2.f];
}


@end
