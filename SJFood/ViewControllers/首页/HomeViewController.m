//
//  HomeViewController.m
//  SJFood
//
//  Created by 叶帆 on 14/11/27.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize searchBar,searchDisplayController;

#pragma mark - Navigation Custom Method
- (void)rightItemTapped
{
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"取消"]) {
        [self.searchBar endEditing:YES];
        [self setRightNaviItemWithTitle:nil imageName:@"icon_message.png"];
    }
}

#pragma mark - Private Methods
- (void)loadSearchBar
{
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
    
    self.searchBar.delegate = self;
    self.searchDisplayController.delegate = self;
}

- (void)loadSubViews
{
    [self loadSearchBar];
}

#pragma mark - UIViewController Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadSubViews];
    self.navigationItem.titleView = self.searchBar;
    [self setRightNaviItemWithTitle:nil imageName:@"icon_message.png"];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.navigationItem.leftBarButtonItem = nil;
    [self setRightNaviItemWithTitle:@"取消" imageName:nil];
}

# pragma mark UISearchDisplayDelegate delegates
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    NSLog(@"Will begin search");
//    self.navigationItem.leftBarButtonItem = nil;
//    [self setRightNaviItemWithTitle:@"取消" imageName:nil];
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
    NSLog(@"Did begin search");
//    self.navigationItem.leftBarButtonItem = nil;
//    [self setRightNaviItemWithTitle:@"取消" imageName:nil];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    NSLog(@"Will end search");
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    NSLog(@"Did end search");
}

@end
