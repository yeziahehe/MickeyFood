//
//  UserView.h
//  SJFood
//
//  Created by 叶帆 on 14/12/5.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "UserInfoSubView.h"

@interface UserView : UserInfoSubView

@property (strong, nonatomic) IBOutlet YFAsynImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIView *deliveryView;
@property (strong, nonatomic) IBOutlet UIView *receiveView;
@property (strong, nonatomic) IBOutlet UIView *commentView;

- (IBAction)loginButtonClicked:(id)sender;
- (IBAction)deleveryButtonClicked:(id)sender;
- (IBAction)receiveButtonClicked:(id)sender;
- (IBAction)commentButtonClicked:(id)sender;

@end
