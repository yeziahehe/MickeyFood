//
//  CategoryCollectionViewCell.h
//  SJFood
//
//  Created by 叶帆 on 14/12/16.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet YFAsynImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) NSString *categoryId;

@end
