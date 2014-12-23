//
//  FoodParamView.m
//  SJFood
//
//  Created by 叶帆 on 14/12/21.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "FoodParamView.h"

@implementation FoodParamView
@synthesize saleNumLabel,gradeLabel,commentLabel;

#pragma mark - Public Methods
- (void)reloadWithFoodDetail:(FoodDetail *)foodDetail
{
    self.saleNumLabel.text = foodDetail.saleNumber;
    self.gradeLabel.text = [NSString stringWithFormat:@"%.1f",[foodDetail.grade floatValue]];
    self.commentLabel.text = foodDetail.commentNumber;
}

#pragma mark - UIView methods
- (void)awakeFromNib
{
    [super awakeFromNib];
}

@end
