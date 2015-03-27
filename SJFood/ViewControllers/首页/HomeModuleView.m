//
//  HomeModuleView.m
//  SJFood
//
//  Created by 叶帆 on 15/3/18.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "HomeModuleView.h"
#import "FoodViewController.h"

@interface HomeModuleView ()
@property (nonatomic, strong) NSString *foodTag;
@end

@implementation HomeModuleView

#pragma mark - IBAction Methods
- (IBAction)homeButtonClicked:(UIButton *)sender {
    //1,2,4
    if (sender.tag == 1 || sender.tag == 2 || sender.tag == 4) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kSelectHomeButtonWithTagNotification object:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
    }
    else {
        switch (sender.tag) {
            case 0:
                self.foodTag = @"特色口味";
                break;
                
            case 3:
                self.foodTag = @"爆款";
                break;
                
            case 5:
                self.foodTag = @"肉干 肉脯";
                break;
                
            case 6:
                self.foodTag = @"坚果 炒货";
                break;
                
            case 7:
                self.foodTag = @"饼干 糕点";
                break;
                
            case 8:
                self.foodTag = @"蜜饯 果干";
                break;
                
            case 9:
                self.foodTag = @"糖果 布丁";
                break;
                
            case 10:
                self.foodTag = @"咖啡 饮料";
                break;
                
            default:
                break;
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:kSelectHomeButtonNotification object:self.foodTag];
    }
}

#pragma mark - UIView methods
- (void)awakeFromNib
{
    [super awakeFromNib];
}

@end
