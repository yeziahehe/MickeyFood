//
//  FoodCommentView.m
//  SJFood
//
//  Created by 叶帆 on 14/12/21.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "FoodCommentView.h"

@implementation FoodCommentView
@synthesize gradeLabel,firstStarImageView,secondStarImageView,thirdStarImageView,furthStarImageView,fifthStarImageView,commentNumLabel,specLabel;

#pragma mark - IBAction Methods
- (IBAction)specButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kSpecViewShowNotification object:nil];
}

- (IBAction)commentButtonClicked:(id)sender {
}

#pragma mark - Public Methods
- (void)reloadWithFoodDetail:(FoodDetail *)foodDetail
{
    self.gradeLabel.text = [NSString stringWithFormat:@"%.1f",[foodDetail.grade floatValue]];

    float gradeNum = [foodDetail.grade floatValue];
    int starNum = [foodDetail.grade intValue]/1;
    if (starNum == 0) {
        float value = gradeNum - 0;
        if (0<= value <=.3) {
            self.firstStarImageView.image = [UIImage imageNamed:@"bg_star_empty"];
        } else if (.3< value <.7) {
            self.firstStarImageView.image = [UIImage imageNamed:@"bg_star_half"];
        } else if (0.7<value <1) {
            self.firstStarImageView.image = [UIImage imageNamed:@"bg_star_full"];
        }
        self.secondStarImageView.image = [UIImage imageNamed:@"bg_star_empty"];
        self.thirdStarImageView.image = [UIImage imageNamed:@"bg_star_empty"];
        self.furthStarImageView.image = [UIImage imageNamed:@"bg_star_empty"];
        self.fifthStarImageView.image = [UIImage imageNamed:@"bg_star_empty"];
    } else if (starNum == 1) {
        self.firstStarImageView.image = [UIImage imageNamed:@"bg_star_full"];
        float value = gradeNum - 1;
        if (0<= value <=.3) {
            self.secondStarImageView.image = [UIImage imageNamed:@"bg_star_empty"];
        } else if (.3< value <.7) {
            self.secondStarImageView.image = [UIImage imageNamed:@"bg_star_half"];
        } else if (0.7<value <1) {
            self.secondStarImageView.image = [UIImage imageNamed:@"bg_star_full"];
        }
        self.thirdStarImageView.image = [UIImage imageNamed:@"bg_star_empty"];
        self.furthStarImageView.image = [UIImage imageNamed:@"bg_star_empty"];
        self.fifthStarImageView.image = [UIImage imageNamed:@"bg_star_empty"];
    } else if (starNum == 2) {
        self.firstStarImageView.image = [UIImage imageNamed:@"bg_star_full"];
        self.secondStarImageView.image = [UIImage imageNamed:@"bg_star_full"];
        float value = gradeNum - 2;
        if (0<= value <=.3) {
            self.thirdStarImageView.image = [UIImage imageNamed:@"bg_star_empty"];
        } else if (.3< value <.7) {
            self.thirdStarImageView.image = [UIImage imageNamed:@"bg_star_half"];
        } else if (0.7<value <1) {
            self.thirdStarImageView.image = [UIImage imageNamed:@"bg_star_full"];
        }
        self.furthStarImageView.image = [UIImage imageNamed:@"bg_star_empty"];
        self.fifthStarImageView.image = [UIImage imageNamed:@"bg_star_empty"];
    } else if (starNum == 3) {
        self.firstStarImageView.image = [UIImage imageNamed:@"bg_star_full"];
        self.secondStarImageView.image = [UIImage imageNamed:@"bg_star_full"];
        self.thirdStarImageView.image = [UIImage imageNamed:@"bg_star_full"];
        float value = gradeNum - 3;
        if (0<= value <=.3) {
            self.furthStarImageView.image = [UIImage imageNamed:@"bg_star_empty"];
        } else if (.3< value <.7) {
            self.furthStarImageView.image = [UIImage imageNamed:@"bg_star_half"];
        } else if (0.7<value <1) {
            self.furthStarImageView.image = [UIImage imageNamed:@"bg_star_full"];
        }
        self.fifthStarImageView.image = [UIImage imageNamed:@"bg_star_empty"];
    } else if (starNum == 4) {
        self.firstStarImageView.image = [UIImage imageNamed:@"bg_star_full"];
        self.secondStarImageView.image = [UIImage imageNamed:@"bg_star_full"];
        self.thirdStarImageView.image = [UIImage imageNamed:@"bg_star_full"];
        self.furthStarImageView.image = [UIImage imageNamed:@"bg_star_full"];
        float value = gradeNum - 3;
        if (0<= value <=.3) {
            self.fifthStarImageView.image = [UIImage imageNamed:@"bg_star_empty"];
        } else if (.3< value <.7) {
            self.fifthStarImageView.image = [UIImage imageNamed:@"bg_star_half"];
        } else if (0.7<value <1) {
            self.fifthStarImageView.image = [UIImage imageNamed:@"bg_star_full"];
        }
    } else if (starNum == 5) {
        self.firstStarImageView.image = [UIImage imageNamed:@"bg_star_full"];
        self.secondStarImageView.image = [UIImage imageNamed:@"bg_star_full"];
        self.thirdStarImageView.image = [UIImage imageNamed:@"bg_star_full"];
        self.furthStarImageView.image = [UIImage imageNamed:@"bg_star_full"];
        self.fifthStarImageView.image = [UIImage imageNamed:@"bg_star_full"];
    }
    
    self.commentNumLabel.text = [NSString stringWithFormat:@"累计评价%@条",foodDetail.commentNumber];
    
}

#pragma mark - UIView methods
- (void)awakeFromNib
{
    [super awakeFromNib];
}


@end
