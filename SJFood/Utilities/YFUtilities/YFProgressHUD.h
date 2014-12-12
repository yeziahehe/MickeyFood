//
//  YFProgressHUD.h
//  YFUtilities
//
//  Created by 叶帆 on 14-7-21.
//  Copyright (c) 2014年 yefan. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
    基于MBProgressHUD封装的hud的进度条显示功能
    将一个全局的hud加入到keyWindow中，所有的show/hide操作只是设置hud的alpha属性
    hud一直存在于keyWindow的subviews中
 
 */

#define HUD_IMAGE_SUCCESS      [UIImage imageNamed:@"YFProgressHUD.bundle/success.png"]
#define HUD_IMAGE_ERROR        [UIImage imageNamed:@"YFProgressHUD.bundle/error.png"]

@class MBProgressHUD;

@interface YFProgressHUD : NSObject

@property(nonatomic, strong)MBProgressHUD *hud;
/**
    初始化方法
    @return YFProgressHUD类本身
 */
+ (YFProgressHUD *)sharedProgressHUD;

/**
    图文混杂（图在上，文字在下）的方式展示hud，并设置隐藏时间
    该方式显示hud是不会覆盖window下面view的touch事件，hud.userTouchEnable = NO
    该方法使用时每次切换customView的时候都会重新load全局hud的indicator，以保证hud的indicator在custom模式下即时更新
    @param message hud中显示的文字，message是nil的时候不显示hud
    @param customView hud中显示的图片，可以是ActivitiView(MBProgressHUDModeIndeterminate),也可以是自定义的图片(MBProgressHUDModeCustomView),当customView是nil的时候隐藏上面的图片展示
    @param delay hud隐藏时间
 */
- (void)showWithMessage:(NSString *)startMessage customView:(UIView *)customView hideDelay:(CGFloat)delay;
/**
    加载Activity的hud，不隐藏，需要调用stop方法隐藏
    区别于startedNetWorkActivityWithText，该方式显示hud是不会覆盖window下面view的touch事件，hud.userTouchEnable = NO;
    注意：该方法需要在viewDidDisappear中添加[[YFProgressHUD sharedProgressHUD] stoppedNetWorkActivity];目的是防止用户在请求未完成前就返回而导致页面销毁但hud未消失的情况
 */
- (void)showActivityViewWithMessage:(NSString *)startMessage;
/**
    成功时图文混杂的hud，图片为默认的对号图片"success.png"
    @param startMessage hud中显示的文字，message是nil的时候不显示hud
    @param delay        hud隐藏时间
 */
- (void)showSuccessViewWithMessage:(NSString *)startMessage hideDelay:(CGFloat)delay;

/**
    失败时图文混杂的hud，图片为默认的对号图片"error.png"
    @param startMessage hud中显示的文字，message是nil的时候不显示hud
    @param delay        hud隐藏时间
 */
- (void)showFailureViewWithMessage:(NSString *)startMessage hideDelay:(CGFloat)delay;

/**
    用ActivityView显示hud，永不隐藏，需要调用stop方法隐藏
    该方式显示hud是会覆盖window下面view的touch事件，hud.userTouchEnable = YES
 */
- (void)startedNetWorkActivityWithText:(NSString *)text;
- (void)stoppedNetWorkActivity;

/**
    加入MBProgressHUDModeDeterminate和MBProgressHUDModeCustomView混合使用的hud
    @param message MBProgressHUDModeDeterminate模式显示的文字
    @param endMessage MBProgressHUDModeCustomView结束显示的文字
    @returns nil
 */
- (void)showMixedWithLoading:(NSString *)message end:(NSString *)endMessage;

@end
