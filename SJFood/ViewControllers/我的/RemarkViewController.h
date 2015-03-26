//
//  RemarkViewController.h
//  SJFood
//
//  Created by 叶帆 on 15/3/26.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderDetails.h"

@interface RemarkViewController : BaseViewController

@property (nonatomic, strong)OrderDetails *orderDetails;
@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet YFAsynImageView *foodImageVIew;
@property (strong, nonatomic) IBOutlet UITextView *commentTextView;
@property (strong, nonatomic) IBOutlet UIButton *firstStarButton;
@property (strong, nonatomic) IBOutlet UIButton *scondStarButton;
@property (strong, nonatomic) IBOutlet UIButton *thirdStarButton;
@property (strong, nonatomic) IBOutlet UIButton *fourthStarButton;
@property (strong, nonatomic) IBOutlet UIButton *fifthStarButton;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;

- (IBAction)commentButtonClicked:(id)sender;
- (IBAction)starButtonClicked:(UIButton *)sender;
@end
