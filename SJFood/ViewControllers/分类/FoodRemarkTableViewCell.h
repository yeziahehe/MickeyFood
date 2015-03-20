//
//  FoodRemarkTableViewCell.h
//  SJFood
//
//  Created by 叶帆 on 15/3/20.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodRemarkTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet YFAsynImageView *userIconImage;
@property (strong, nonatomic) IBOutlet UILabel *remarkLabel;
@property (strong, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *gradeLabel;

@end
