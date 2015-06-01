//
//  HomeModuleView.m
//  SJFood
//
//  Created by 叶帆 on 15/3/18.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "HomeModuleView.h"
#import "FoodViewController.h"
#import "Masonry.h"
#import "TalkingViewController.h"
#import "PostViewController.h"
#import "CategoryViewController.h"

@interface HomeModuleView ()
@property (nonatomic, strong) NSString *foodTag;
@property (weak, nonatomic) IBOutlet UIButton *cloudShopButton;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UIButton *weeklyNewButton;
@property (weak, nonatomic) IBOutlet UIButton *discountButton;
@property (weak, nonatomic) IBOutlet UIButton *hotThingsButton;
@property (weak, nonatomic) IBOutlet UIButton *talkButton;

@end

@implementation HomeModuleView

#pragma mark - IBAction Methods
- (IBAction)homeButtonClicked:(UIButton *)sender {
    //1,2,4
    if (sender.tag == 1 || sender.tag == 2 || sender.tag == 4) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kSelectHomeButtonWithTagNotification object:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
    }
//    else if(sender.tag == 11) {
//        [[YFProgressHUD sharedProgressHUD] showWithMessage:@"更多功能正在开发中，敬请期待..." customView:nil hideDelay:3.f];
//    }
}

- (IBAction)cloudShopButtonClicked:(UIButton *)sender {

    [[NSNotificationCenter defaultCenter]postNotificationName:kSelectHomeButtonWithTagNotification object:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
    
}

- (IBAction)postButtonClicked:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:kPostButtonWithTagNotification object:[NSString stringWithFormat:@"%ld",(long)sender.tag]];

}

- (IBAction)talkButtonClicked:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:kTalkingBUttonWithTagNotification object:[NSString stringWithFormat:@"%ld",(long)sender.tag]];

}

#pragma mark - UIView methods
- (void)awakeFromNib
{
    [super awakeFromNib];
}

@end
