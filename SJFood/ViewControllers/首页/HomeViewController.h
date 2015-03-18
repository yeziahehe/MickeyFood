//
//  HomeViewController.h
//  SJFood
//
//  Created by 叶帆 on 14/11/27.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "BaseMenuViewController.h"
#import "ImagesContainView.h"

@interface HomeViewController : BaseMenuViewController<UISearchBarDelegate,ImagesContainViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;

@end
