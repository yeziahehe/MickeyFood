//
//  FoodCommentView.h
//  SJFood
//
//  Created by 叶帆 on 14/12/21.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "FoodDetailSubView.h"

@interface FoodCommentView : FoodDetailSubView
@property (strong, nonatomic) IBOutlet UILabel *gradeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *firstStarImageView;
@property (strong, nonatomic) IBOutlet UIImageView *secondStarImageView;
@property (strong, nonatomic) IBOutlet UIImageView *thirdStarImageView;
@property (strong, nonatomic) IBOutlet UIImageView *furthStarImageView;
@property (strong, nonatomic) IBOutlet UIImageView *fifthStarImageView;
@property (strong, nonatomic) IBOutlet UILabel *commentNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *specLabel;

- (IBAction)specButtonClicked:(id)sender;
- (IBAction)commentButtonClicked:(id)sender;

@end
