//
//  UserView.h
//  SJFood
//
//  Created by 叶帆 on 14/12/5.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "UserInfoSubView.h"

@interface UserView : UserInfoSubView

@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;

- (IBAction)deleveryButtonClicked:(id)sender;
- (IBAction)receiveButtonClicked:(id)sender;
- (IBAction)commentButtonClicked:(id)sender;
- (IBAction)refundButtonClicked:(id)sender;

@end
