//
//  YFBadgeView.m
//  SJFood
//
//  Created by 叶帆 on 14/12/8.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "YFBadgeView.h"

static const CGFloat YFBadgeViewHeight = 16.0f;
static const CGFloat YFBadgeViewTextSideMargin = 8.0f;
static const CGFloat YFBadgeViewCornerRadius = 10.0f;

@implementation YFBadgeView

#pragma mark - Init Methods
+ (void)applyCommonStyle
{
    YFBadgeView *badgeViewAppearanceProxy = YFBadgeView.appearance;
    
    badgeViewAppearanceProxy.backgroundColor = UIColor.clearColor;
    badgeViewAppearanceProxy.badgeAlignment = YFBadgeViewAlignmentTopRight;
    badgeViewAppearanceProxy.badgeBackgroundColor = kMainProjColor;
    badgeViewAppearanceProxy.badgeTextFont = [UIFont boldSystemFontOfSize:UIFont.systemFontSize];
    badgeViewAppearanceProxy.badgeTextColor = UIColor.whiteColor;
}

+ (void)initialize
{
    if (self == YFBadgeView.class)
    {
        [self applyCommonStyle];
    }
}

- (id)initWithParentView:(UIView *)parentView alignment:(YFBadgeViewPosition)alignment
{
    if ((self = [self initWithFrame:CGRectZero]))
    {
        self.badgeAlignment = alignment;
        [parentView addSubview:self];
    }
    return self;
}

#pragma mark - Layout Methods
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect newFrame = self.frame;
    const CGRect superviewBounds = self.superview.bounds;
    
    const CGFloat textWidth = [self sizeOfTextForCurrentSettings].width;
    
    const CGFloat viewWidth = textWidth + YFBadgeViewTextSideMargin ;
    const CGFloat viewHeight = YFBadgeViewHeight;
    
    const CGFloat superviewWidth = superviewBounds.size.width;
    const CGFloat superviewHeight = superviewBounds.size.height;
    
    newFrame.size.width = viewWidth;
    newFrame.size.height = viewHeight;
    
    switch (self.badgeAlignment) {
        case YFBadgeViewAlignmentTopRight:
            newFrame.origin.x = superviewWidth - (viewWidth / 2.0f);
            newFrame.origin.y = -viewHeight / 2.0f;
            break;
        case YFBadgeViewAlignmentCenterRight:
            newFrame.origin.x = superviewWidth - (viewWidth / 2.0f);
            newFrame.origin.y = (superviewHeight - viewHeight) / 2.0f;
            break;
        default:
            NSAssert(NO, @"Unimplemented JSBadgeAligment type %lul", (unsigned long)self.badgeAlignment);
    }
    
    self.bounds = CGRectIntegral(CGRectMake(0, 0, CGRectGetWidth(newFrame), CGRectGetHeight(newFrame)));
    self.center = CGPointMake(ceilf(CGRectGetMidX(newFrame)), ceilf(CGRectGetMidY(newFrame)));
    
    [self setNeedsDisplay];
}

#pragma mark - Private Methods
- (CGSize)sizeOfTextForCurrentSettings
{
    return [self.badgeText sizeWithAttributes:@{NSFontAttributeName:self.badgeTextFont}];
}

#pragma mark - Setters Methods
- (void)setBadgeAlignment:(YFBadgeViewPosition)badgeAlignment
{
    if (badgeAlignment != _badgeAlignment)
    {
        _badgeAlignment = badgeAlignment;
        [self setNeedsLayout];
    }
}

- (void)setBadgeText:(NSString *)badgeText
{
    if (badgeText != _badgeText)
    {
        _badgeText = [badgeText copy];
        
        [self setNeedsLayout];
    }
}

- (void)setBadgeTextColor:(UIColor *)badgeTextColor
{
    if (badgeTextColor != _badgeTextColor)
    {
        _badgeTextColor = badgeTextColor;
        
        [self setNeedsDisplay];
    }
}

- (void)setBadgeTextFont:(UIFont *)badgeTextFont
{
    if (badgeTextFont != _badgeTextFont)
    {
        _badgeTextFont = badgeTextFont;
        
        [self setNeedsDisplay];
    }
}

- (void)setBadgeBackgroundColor:(UIColor *)badgeBackgroundColor
{
    if (badgeBackgroundColor != _badgeBackgroundColor)
    {
        _badgeBackgroundColor = badgeBackgroundColor;
        
        [self setNeedsDisplay];
    }
}

#pragma mark - Drawing Methods
- (void)drawRect:(CGRect)rect
{
    const BOOL anyTextToDraw = (self.badgeText.length > 0);
    if (anyTextToDraw)
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        const CGRect rectToDraw = rect;
        UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:rectToDraw byRoundingCorners:(UIRectCorner)UIRectCornerAllCorners cornerRadii:CGSizeMake(YFBadgeViewCornerRadius, YFBadgeViewCornerRadius)];
        
        /* Background */
        CGContextSaveGState(ctx);
        {
            CGContextAddPath(ctx, borderPath.CGPath);
            CGContextSetFillColorWithColor(ctx, self.badgeBackgroundColor.CGColor);
            CGContextDrawPath(ctx, kCGPathFill);
        }
        CGContextRestoreGState(ctx);
        
        /* Text */
        CGContextSaveGState(ctx);
        {
            CGContextSetFillColorWithColor(ctx, self.badgeTextColor.CGColor);
            
            CGRect textFrame = rectToDraw;
            const CGSize textSize = [self sizeOfTextForCurrentSettings];
            
            textFrame.size.height = textSize.height;
            textFrame.origin.y = rectToDraw.origin.y + ceilf((rectToDraw.size.height - textFrame.size.height) / 2.0f);
            
            NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            /// Set line break mode
            paragraphStyle.lineBreakMode = NSLineBreakByClipping;
            /// Set text alignment
            paragraphStyle.alignment = NSTextAlignmentCenter;
            [self.badgeText drawInRect:textFrame withAttributes:@{NSFontAttributeName:self.badgeTextFont,NSParagraphStyleAttributeName: paragraphStyle,NSForegroundColorAttributeName: self.badgeTextColor}];
        }
        CGContextRestoreGState(ctx);
    }
}

@end
