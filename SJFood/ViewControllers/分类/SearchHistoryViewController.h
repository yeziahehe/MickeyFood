//
//  SearchHistoryViewController.h
//  SJFood
//
//  Created by 叶帆 on 14/12/17.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchHistoryViewController : UIViewController
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *searchHistoryTableView;
@property (strong, nonatomic) IBOutlet UIView *clearSearchHistoryView;
@property (strong, nonatomic) IBOutlet UIView *noSearchHistoryView;

- (IBAction)clearSearchButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
@end
