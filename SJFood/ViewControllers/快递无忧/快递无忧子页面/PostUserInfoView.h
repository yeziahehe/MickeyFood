//
//  PostUserInfoView.h
//  SJFood
//
//  Created by MiY on 15/6/3.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "PostSubView.h"
#import "Address.h"

@interface PostUserInfoView : PostSubView

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;

- (void)reloadData:(Address *)address;

@end
