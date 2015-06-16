//
//  PostPopView.h
//  Post
//
//  Created by MiY on 15/6/8.
//  Copyright (c) 2015年 MiY. All rights reserved.
//

#import "PostSubView.h"

@interface PostPopView : PostSubView

@property (strong, nonatomic) IBOutlet UITableView *comChoseTableView;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *completeButton;

- (void)requestForDeliverInfo;

@end
