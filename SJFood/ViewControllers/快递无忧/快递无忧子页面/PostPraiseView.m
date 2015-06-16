//
//  PostPraiseView.m
//  SJFood
//
//  Created by MiY on 15/6/3.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "PostPraiseView.h"
@interface PostPraiseView ()



@end
@implementation PostPraiseView

- (void)awakeFromNib
{
    [super awakeFromNib];
  
    [self.slider setMinimumTrackImage:[UIImage imageNamed:@"full_progress_bar.png"] forState:UIControlStateNormal];
    [self.slider setMaximumTrackImage:[UIImage imageNamed:@"empty_progress_bar.png"] forState:UIControlStateNormal];
    [self.slider setThumbImage:[UIImage imageNamed:@"price_button.png"] forState:UIControlStateNormal];
    
    //=================================
    int integer = (int)self.slider.value;
    
    CGFloat leftX = self.slider.frame.origin.x;
    CGFloat width = self.slider.frame.size.width;
    CGFloat x = leftX + width / 11.f * integer + 0.2 * integer;
    CGFloat y = self.slider.frame.origin.y - 20.f;
    
//    NSLog(@"GGGGGGGGGGGGGGGGG====================================\n\n\n\n\n\n\n ========================%f  %f", x, y);
    
    CGRect frame = CGRectMake(x, y, 25.f, 18.f);
    UIImageView *priceView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pricetag.png"]];
    priceView.frame = frame;
    
    CGRect rect = CGRectMake(4.5, 3, 18, 10);
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:rect];
    priceLabel.font = [UIFont systemFontOfSize:10];
    priceLabel.textColor = [UIColor whiteColor];
    priceLabel.text = [NSString stringWithFormat:@"%d元", integer];
    [priceView addSubview:priceLabel];
    
    [self addSubview:priceView];
    
    //===================================

    [self.slider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    
}

- (void)sliderValueChanged
{
    int integer = (int)self.slider.value;
    
    float decimal = self.slider.value - integer;
    if (decimal >= 0.5) {
        [self.slider setValue:(float)++integer animated:YES];
    }
    else {
        [self.slider setValue:(float)integer animated:YES];
    }
    
    CGFloat leftX = self.slider.frame.origin.x;
    CGFloat width = self.slider.frame.size.width;
    CGFloat x = leftX + width / 11.f * integer + 0.2 * integer;
    CGFloat y = self.slider.frame.origin.y - 20.f;
//    NSLog(@"YY %f  %f", x, y);
    CGRect frame = CGRectMake(x, y, 25.f, 18.f);
    
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    UIImageView *priceView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pricetag.png"]];
    priceView.frame = frame;
    
    CGRect rect;
    if (integer >= 10) {
        rect = CGRectMake(1.5, 3, 23, 10);
    } else {
        rect = CGRectMake(4.5, 3, 18, 10);
    }
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:rect];
    priceLabel.font = [UIFont systemFontOfSize:10];
    priceLabel.textColor = [UIColor whiteColor];
    priceLabel.text = [NSString stringWithFormat:@"%d元", integer];
    [priceView addSubview:priceLabel];
    
    [self addSubview:priceView];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sliderValueChanged"
                                                        object:[NSString stringWithFormat:@"%d", integer]];
}

@end
