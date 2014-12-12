//
//  YFProgressHUD.m
//  YFUtilities
//
//  Created by 叶帆 on 14-7-21.
//  Copyright (c) 2014年 yefan. All rights reserved.
//

#import "YFProgressHUD.h"
#import "MBProgressHUD.h"

@implementation YFProgressHUD
@synthesize hud;

#pragma mark - Init methods
- (id)init
{
    if(self = [super init])
    {
        UIWindow *hudWindow = [[UIApplication sharedApplication].windows objectAtIndex:0];
        hud = [[MBProgressHUD alloc] initWithWindow:hudWindow];
        [hudWindow addSubview:hud];
        hud.userInteractionEnabled = NO;
    }
    return self;
}

+ (YFProgressHUD *)sharedProgressHUD
{
    static YFProgressHUD *_progressHUD = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _progressHUD = [[YFProgressHUD alloc] init];
    });
    return _progressHUD;
}

#pragma mark - Public methods
- (void)showWithMessage:(NSString *)message customView:(UIView *)customView hideDelay:(CGFloat)delay
{
    if(nil == message || [message isEqualToString:@""])
    {
        NSLog(@"YFProgressHUD显示空信息.");
        [hud hide:YES];
        return;
    }
    UIWindow *hudWindow = (UIWindow *)hud.superview;
    [hudWindow bringSubviewToFront:hud];
    hud.userInteractionEnabled = NO;
    UIView *cv = [[UIView alloc] init];
    cv.backgroundColor = [UIColor clearColor];
    if(!customView)
        hud.customView = cv;
    else
        hud.customView = customView;
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = message;
    [NSObject cancelPreviousPerformRequestsWithTarget:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:delay];
}

- (void)showSuccessViewWithMessage:(NSString *)startMessage hideDelay:(CGFloat)delay
{
    [self showWithMessage:startMessage customView:[[UIImageView alloc]initWithImage:HUD_IMAGE_SUCCESS] hideDelay:delay];
}

- (void)showFailureViewWithMessage:(NSString *)startMessage hideDelay:(CGFloat)delay
{
    [self showWithMessage:startMessage customView:[[UIImageView alloc]initWithImage:HUD_IMAGE_ERROR] hideDelay:delay];
}

- (void)showActivityViewWithMessage:(NSString *)startMessage
{
    if(nil == startMessage || [startMessage isEqualToString:@""])
    {
        NSLog(@"YFProgressHUD显示空信息.");
        [hud hide:YES];
        return;
    }
    UIWindow *hudWindow = (UIWindow *)hud.superview;
    [hudWindow bringSubviewToFront:hud];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = startMessage;
    [NSObject cancelPreviousPerformRequestsWithTarget:hud];
    [hud show:YES];
}

- (void)startedNetWorkActivityWithText:(NSString *)text
{
    if(nil == text || [text isEqualToString:@""])
    {
        NSLog(@"YFProgressHUD显示空信息.");
        [hud hide:YES];
        return;
    }
    UIWindow *hudWindow = (UIWindow *)hud.superview;
    [hudWindow bringSubviewToFront:hud];
    hud.userInteractionEnabled = YES;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = text;
    [NSObject cancelPreviousPerformRequestsWithTarget:hud];
    [hud show:YES];
}

- (void)stoppedNetWorkActivity
{
    [hud hide:YES];
}

- (void)showMixedWithLoading:(NSString *)startMessage end:(NSString *)endMessage
{
    if(nil == startMessage || [startMessage isEqualToString:@""])
    {
        NSLog(@"YFProgressHUD_Mixed显示空信息(startMessage).");
        [hud hide:YES];
        return;
    }
    if(nil == endMessage || [endMessage isEqualToString:@""])
    {
        NSLog(@"YFProgressHUD_Mixed显示空信息(endMessage).");
        [hud hide:YES];
        return;
    }
    UIWindow *hudWindow = (UIWindow *)hud.superview;
    [hudWindow bringSubviewToFront:hud];
    hud.userInteractionEnabled = YES;
    hud.mode = MBProgressHUDModeDeterminate;
    hud.labelText = startMessage;
    [NSObject cancelPreviousPerformRequestsWithTarget:hud];
    [hud showWhileExecuting:@selector(myProgressTask:) onTarget:self withObject:endMessage animated:YES];
}

#pragma mark - Private methods

- (void)myProgressTask:(NSString *)endMessage {
    // This just increases the progress indicator in a loop
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.01f;
        hud.progress = progress;
        usleep(10000);
    }
    __block UIImageView *imageView;
	dispatch_sync(dispatch_get_main_queue(), ^{
		UIImage *image = HUD_IMAGE_SUCCESS;
		imageView = [[UIImageView alloc] initWithImage:image];
	});
    hud.customView = imageView;
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = endMessage;
    sleep(2);
}

@end
