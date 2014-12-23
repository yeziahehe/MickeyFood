//
//  FoodDetailViewController.h
//  SJFood
//
//  Created by 叶帆 on 14/12/20.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "BaseViewController.h"

@interface FoodDetailViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (strong, nonatomic) NSString *foodId;

@end
