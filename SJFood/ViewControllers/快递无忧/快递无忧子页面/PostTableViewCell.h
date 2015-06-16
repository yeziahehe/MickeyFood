//
//  PostTableViewCell.h
//  Post
//
//  Created by MiY on 15/6/4.
//  Copyright (c) 2015年 MiY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;

@end
