//
//  HomeViewController.h
//  SJFood
//
//  Created by 叶帆 on 14/11/27.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "BaseMenuViewController.h"

@interface HomeViewController : BaseMenuViewController<UISearchBarDelegate,UISearchDisplayDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchDisplayController;

@end
