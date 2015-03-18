//
//  HomeViewController.m
//  SJFood
//
//  Created by 叶帆 on 14/11/27.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "HomeViewController.h"
#import "SearchHistoryViewController.h"
#import "FoodViewController.h"

@interface HomeViewController ()
@property (strong, nonatomic) UISearchBar *searchBar;
@end

@implementation HomeViewController

@synthesize searchBar;

#pragma mark - Private Methods
- (void)loadSearchBar
{
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    [self.searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.searchBar sizeToFit];
    [self.searchBar setPlaceholder:@"搜索美食"];
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    UITextField *searchField = [self.searchBar valueForKey:@"_searchField"];
    // Change search bar text color
    searchField.textColor = [UIColor whiteColor];
    // Change the search bar placeholder text color
    [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    // Change the search icon
    UIImage *image = [UIImage imageNamed: @"icon_search.png"];
    UIImageView *iView = [[UIImageView alloc] initWithImage:image];
    iView.frame = CGRectMake(0, 0, 16, 16);
    searchField.leftView  = iView;
    self.navigationItem.titleView = self.searchBar;
}

- (void)loadSubViews
{
    [self loadSearchBar];
}

#pragma mark - NSNotification Methods
- (void)foodSearchWithNotification:(NSNotification *)notification
{
    FoodViewController *foodViewController = [[FoodViewController alloc] initWithNibName:@"FoodViewController" bundle:nil];
    [foodViewController requestForFoodSearchWithCategoryId:nil foodTag:notification.object sortId:@"0" page:@"0"];
    [self.navigationController pushViewController:foodViewController animated:YES];
}

#pragma mark - UIViewController Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadSubViews];
    [self setRightNaviItemWithTitle:nil imageName:@"icon_message.png"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foodSearchWithNotification:) name:kFoodSearchNotification object:nil];
}


#pragma mark - UISearchBar Delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    SearchHistoryViewController *searchHistoryViewController = [[SearchHistoryViewController alloc] initWithNibName:@"SearchHistoryViewController" bundle:nil];
    [self presentViewController:searchHistoryViewController animated:NO completion:nil];
    return NO;
}


@end
