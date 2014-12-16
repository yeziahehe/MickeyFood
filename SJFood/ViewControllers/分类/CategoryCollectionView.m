//
//  CategoryCollectionView.m
//  SJFood
//
//  Created by 叶帆 on 14/12/16.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "CategoryCollectionView.h"
#import "CategoryCollectionViewCell.h"
#import "FoodCategoryDetail.h"

#define kCellReuseIdentify      @"CategoryCollectionViewCell"

@interface CategoryCollectionView ()
@property (nonatomic, strong) NSMutableArray *categoryCollectionArray;
@property (nonatomic, strong) FoodCategoryDetail *foodCategoryDetail;
@end

@implementation CategoryCollectionView
@synthesize categoryCollectionView;
@synthesize categoryCollectionArray,foodCategoryDetail;

#pragma mark - Public Methods
- (void)reloadWithCategory:(NSMutableArray *)category
{
    self.categoryCollectionArray = category;
    [self.categoryCollectionView reloadData];
}

#pragma mark - UIView Mehtods
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.categoryCollectionView registerNib:[UINib nibWithNibName:@"CategoryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kCellReuseIdentify];
}

#pragma mark - UICollectionDataSource Methods
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.categoryCollectionArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentify forIndexPath:indexPath];
    self.foodCategoryDetail = [self.categoryCollectionArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = self.foodCategoryDetail.category;
    cell.categoryId = self.foodCategoryDetail.categoryId;
    cell.iconImageView.cacheDir = kFoodIconCacheDir;
    [cell.iconImageView aysnLoadImageWithUrl:self.foodCategoryDetail.imgUrl placeHolder:@"loading_square.png"];
    return cell;
}

#pragma mark - UICollectionViewDelegate methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
