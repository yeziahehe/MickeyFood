//
//  ImagesContainView.h
//  SJFood
//
//  Created by 叶帆 on 15/3/18.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeSubView.h"
#import "AdModel.h"

@protocol ImagesContainViewDelegate;

@interface ImagesContainView : HomeSubView<YFCycleScrollViewDelegate>
@property (strong, nonatomic) IBOutlet YFCycleScrollView *cycleScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, assign) id<ImagesContainViewDelegate> delegate;
@property (strong, nonatomic) NSArray *productAdArray;

- (void)reloadWithProductAds:(NSArray *)productAds;
@end

@protocol ImagesContainViewDelegate <NSObject>

- (void)didTappedWithProductAd:(AdModel *)productAd;

@end
