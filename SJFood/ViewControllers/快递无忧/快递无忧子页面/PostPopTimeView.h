//
//  PostPopTimeView.h
//  Post
//
//  Created by MiY on 15/6/9.
//  Copyright (c) 2015年 MiY. All rights reserved.
//

#import "PostSubView.h"

@interface PostPopTimeView : PostSubView

@property (strong, nonatomic) IBOutlet UITableView *timeChoseTableView;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *completeButton;

@end
