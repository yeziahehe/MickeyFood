//
//  ImagesContainView.m
//  SJFood
//
//  Created by 叶帆 on 15/3/18.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "ImagesContainView.h"

@implementation ImagesContainView

@synthesize cycleScrollView,pageControl;
@synthesize delegate;
@synthesize productAdArray;

#pragma mark - Public methods
- (void)reloadWithProductAds:(NSArray *)productAds
{
    self.productAdArray = productAds;
    self.pageControl.numberOfPages = productAds.count;
    self.pageControl.currentPage = 0;
    
    NSMutableArray *images = [NSMutableArray array];
    for(AdModel *productAd in productAds)
    {
        [images addObject:productAd.imgUrl];
    }
    [self.cycleScrollView reloadWithImages:images placeHolder:@"loading_square.png" cacheDir:kFoodIconCacheDir];
    if (self.pageControl.numberOfPages == 1) {
        self.cycleScrollView.scrollEnabled = NO;
    }
    else
        self.cycleScrollView.scrollEnabled = YES;
}

#pragma mark - UIView methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.cycleScrollView.cycleDelegate = self;
    self.cycleScrollView.delegate = self.cycleScrollView.cycleDelegate;
}

#pragma mark - YFCycleScrollViewDelegate methods
- (void)didCycleScrollViewTappedWithIndex:(NSInteger)index
{
    //根据产品imageName找到产品id
    if([self.delegate respondsToSelector:@selector(didTappedWithProductAd:)])
        [self.delegate didTappedWithProductAd:[self.productAdArray objectAtIndex:index]];
}

- (void)scrollViewDidEndDecelerating:(YFCycleScrollView *)scrollView
{
    NSInteger page = floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2) / scrollView.frame.size.width) + 1;
    if(page == 0)
    {
        [scrollView setContentOffset:CGPointMake((scrollView.cycleArray.count-2)*scrollView.frame.size.width, 0)];
        self.pageControl.currentPage = scrollView.cycleArray.count-3;
    }
    else if(page == scrollView.cycleArray.count-1)
    {
        [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width, 0)];
        self.pageControl.currentPage = 0;
    }
    else
    {
        self.pageControl.currentPage = page-1;
    }
}

@end
