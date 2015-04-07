//
//  MyMessageViewController.h
//  SJFood
//
//  Created by 叶帆 on 14/12/6.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "BaseViewController.h"

@interface MyMessageViewController : BaseViewController

@property (nonatomic, strong) NSString *messageDetail;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;

@end
