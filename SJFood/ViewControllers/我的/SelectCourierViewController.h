//
//  SelectCourierViewController.h
//  SJFood
//
//  Created by 叶帆 on 15/3/28.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "BaseViewController.h"

@interface SelectCourierViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UITableView *selectCourierTableView;
@property (strong, nonatomic) IBOutlet UIView *noCourierView;
@property (strong, nonatomic) NSString *courierName;
@property (strong, nonatomic) NSString *togetherId;

@end
