//
//  SpecView.m
//  SJFood
//
//  Created by 叶帆 on 14/12/24.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "SpecView.h"

#define kCreateOrderDownloadKey     @"CreateOrderDownloadKey"

@interface SpecView ()
@property (nonatomic, strong) NSMutableArray *countForSpecArray;
@property (nonatomic, strong) NSString *foodCount;
@property (nonatomic, strong) NSString *specId;
@property (nonatomic, strong) NSString *foodId;
@end

@implementation SpecView
@synthesize screenImageView,specDetailView;
@synthesize iconImageView,foodTitleLabel,priceLabel,buyNumButton,restLabel,specHeaderView;
@synthesize countForSpecArray,specButton1,specButton2,specButton3,foodCount,specId,foodId;

#pragma mark - Public Methods
- (void)reloadWithFoodDetail:(FoodDetail *)foodDetail
{
    self.foodId = foodDetail.foodId;
    self.iconImageView.cacheDir = kUserIconCacheDir;
    [self.iconImageView aysnLoadImageWithUrl:foodDetail.imgUrl placeHolder:@"loading_square.png"];
    self.foodTitleLabel.text = foodDetail.name;
    if ([foodDetail.isDiscount isEqualToString:@"1"]) {
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[foodDetail.discountPrice floatValue]];
    }
    else {
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[foodDetail.price floatValue]];
    }
    self.restLabel.text = [NSString stringWithFormat:@"%@件",foodDetail.foodCount];
    
    self.countForSpecArray = [NSMutableArray arrayWithCapacity:foodDetail.foodSpecial.count];
    if (foodDetail.foodSpecial.count == 0) {
        [[YFProgressHUD sharedProgressHUD] showWithMessage:@"获取口味失败" customView:nil hideDelay:2.f];
    } else if (foodDetail.foodSpecial.count == 1) {
        FoodSpec *foodSpec = [foodDetail.foodSpecial objectAtIndex:0];
        //[self.specButton1 setTitle:foodSpec.name forState:UIControlStateNormal];
        self.specButton1.tag = [foodSpec.specialId integerValue];
        [self.countForSpecArray addObject:foodSpec.foodCount];
        [self.specButton1 addTarget:self action:@selector(specButton1Clicked:) forControlEvents:UIControlEventTouchUpInside];
    } else if (foodDetail.foodSpecial.count == 2) {
        FoodSpec *foodSpec = [foodDetail.foodSpecial objectAtIndex:0];
        [self.specButton1 setTitle:foodSpec.name forState:UIControlStateNormal];
        self.specButton1.tag = [foodSpec.specialId integerValue];
        [self.countForSpecArray addObject:foodSpec.foodCount];
        [self.specButton1 addTarget:self action:@selector(specButton1Clicked:) forControlEvents:UIControlEventTouchUpInside];
        FoodSpec *foodSpecplus = [foodDetail.foodSpecial objectAtIndex:1];
        self.specButton2.hidden = NO;
        [self.specButton2 setTitle:foodSpecplus.name forState:UIControlStateNormal];
        self.specButton2.tag = [foodSpecplus.specialId integerValue];
        [self.countForSpecArray addObject:foodSpecplus.foodCount];
        [self.specButton2 addTarget:self action:@selector(specButton2Clicked:) forControlEvents:UIControlEventTouchUpInside];
    } else if (foodDetail.foodSpecial.count == 3) {
        FoodSpec *foodSpec = [foodDetail.foodSpecial objectAtIndex:0];
        [self.specButton1 setTitle:foodSpec.name forState:UIControlStateNormal];
        self.specButton1.tag = [foodSpec.specialId integerValue];
        [self.countForSpecArray addObject:foodSpec.foodCount];
        [self.specButton1 addTarget:self action:@selector(specButton1Clicked:) forControlEvents:UIControlEventTouchUpInside];
        FoodSpec *foodSpecplus = [foodDetail.foodSpecial objectAtIndex:1];
        self.specButton2.hidden = NO;
        [self.specButton2 setTitle:foodSpecplus.name forState:UIControlStateNormal];
        self.specButton2.tag = [foodSpecplus.specialId integerValue];
        [self.countForSpecArray addObject:foodSpecplus.foodCount];
        [self.specButton2 addTarget:self action:@selector(specButton2Clicked:) forControlEvents:UIControlEventTouchUpInside];
        FoodSpec *foodSpecpluss = [foodDetail.foodSpecial objectAtIndex:2];
        self.specButton3.hidden = NO;
        [self.specButton3 setTitle:foodSpecpluss.name forState:UIControlStateNormal];
        self.specButton3.tag = [foodSpecpluss.specialId integerValue];
        [self.countForSpecArray addObject:foodSpecpluss.foodCount];
        [self.specButton3 addTarget:self action:@selector(specButton3Clicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect progressFrame = CGRectMake(20, 30, ScreenWidth - 40, ScreenHeight - 60);
        self.screenImageView.frame = progressFrame;
    } completion:nil];
    [self bringSubviewToFront:specDetailView];
    [specDetailView addAnimationWithType:kCATransitionPush subtype:kCATransitionFromTop];
}

#pragma mark - IBAction Methods
- (IBAction)backButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kSpecChooseNotification object:nil];
}
- (IBAction)cancelButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kSpecChooseNotification object:nil];
}

- (IBAction)confirmButtonClicked:(id)sender {
    if ([self.specId isEqualToString:@"-1"]) {
        [[YFProgressHUD sharedProgressHUD] showWithMessage:@"请选择口味" customView:nil hideDelay:2.f];
    } else if (![[MemberDataManager sharedManager] isLogin]) {
        [[YFProgressHUD sharedProgressHUD] showWithMessage:@"请先登录再添加到购物车" customView:nil hideDelay:2.f];
    } else {
        NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kCreateOrderUrl];
        NSMutableDictionary *dict = kCommonParamsDict;
        [dict setObject:self.foodId forKey:@"foodId"];
        [dict setObject:[MemberDataManager sharedManager].loginMember.phone forKey:@"phoneId"];
        [dict setObject:self.foodCount forKey:@"foodCount"];
        [dict setObject:self.specId forKey:@"foodSpecial"];
        [[YFDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                                 postParams:dict
                                                                contentType:@"application/x-www-form-urlencoded"
                                                                   delegate:self
                                                                    purpose:kCreateOrderDownloadKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:kSpecChooseNotification object:nil];
    }
}

- (void)specButton1Clicked:(UIButton *)button
{
    specButton1.selected = YES;
    specButton2.selected = NO;
    specButton3.selected = NO;
    self.specId = [NSString stringWithFormat:@"%ld",(long)button.tag];
    self.restLabel.text = [NSString stringWithFormat:@"%@件",[self.countForSpecArray objectAtIndex:0]];
}

- (void)specButton2Clicked:(UIButton *)button
{
    specButton1.selected = NO;
    specButton2.selected = YES;
    specButton3.selected = NO;
    self.specId = [NSString stringWithFormat:@"%ld",(long)button.tag];
    self.restLabel.text = [NSString stringWithFormat:@"%@件",[self.countForSpecArray objectAtIndex:1]];
}

- (void)specButton3Clicked:(UIButton *)button
{
    specButton1.selected = NO;
    specButton2.selected = NO;
    specButton3.selected = YES;
    self.specId = [NSString stringWithFormat:@"%ld",(long)button.tag];
    self.restLabel.text = [NSString stringWithFormat:@"%@件",[self.countForSpecArray objectAtIndex:2]];
}

- (IBAction)addNumberButtonClicked:(id)sender {
    if ([self.foodCount integerValue] > [self.restLabel.text integerValue]) {
        [[YFProgressHUD sharedProgressHUD] showWithMessage:@"已增加到最大库存" customView:nil hideDelay:2.f];
    } else {
        self.foodCount = [NSString stringWithFormat:@"%d",[self.foodCount intValue] + 1];
        [self.buyNumButton setTitle:self.foodCount forState:UIControlStateNormal];
    }
}

- (IBAction)reduceNumberButtonClicked:(id)sender {
    if ([self.foodCount isEqualToString:@"1"]) {
        [[YFProgressHUD sharedProgressHUD] showWithMessage:@"已减少到最小数量" customView:nil hideDelay:2.f];
    } else {
        self.foodCount = [NSString stringWithFormat:@"%d",[self.foodCount intValue] - 1];
        [self.buyNumButton setTitle:self.foodCount forState:UIControlStateNormal];
    }
}

#pragma mark - UIView Methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.specHeaderView.layer.shadowOffset = CGSizeZero;
    self.specHeaderView.layer.shadowOpacity = 0.75f;
    self.specHeaderView.layer.shadowRadius = 5.f;
    self.specHeaderView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.specHeaderView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.layer.bounds].CGPath;
    self.specHeaderView.clipsToBounds = NO;
    self.countForSpecArray = [NSMutableArray arrayWithCapacity:0];
    self.foodCount = @"1";
    self.specId = @"-1";
}

- (void)dealloc
{
    [[YFDownloaderManager sharedManager] cancelDownloaderWithDelegate:self purpose:nil];
}

#pragma mark - YFDownloaderDelegate Methods
- (void)downloader:(YFDownloader *)downloader completeWithNSData:(NSData *)data
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [str JSONValue];
    if ([downloader.purpose isEqualToString:kCreateOrderDownloadKey])
    {
        if([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode])
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:kRefreshShoppingCarNotification object:nil];
            [[YFProgressHUD sharedProgressHUD] showWithMessage:@"添加购物车成功，请去购物车结算" customView:nil hideDelay:3.f];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if ([message isKindOfClass:[NSNull class]])
            {
                message = @"";
            }
            if(message.length == 0)
                message = @"添加购物车失败";
            [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:message hideDelay:2.f];
        }
    }
}

- (void)downloader:(YFDownloader *)downloader didFinishWithError:(NSString *)message
{
    [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:kNetWorkErrorString hideDelay:2.f];
}

@end
