//
//  YFWebViewController.h
//  SJFood
//
//  Created by 叶帆 on 14/12/2.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

/**
 自定义的用于load本地/网络html资源的通用webview
 */

#import "BaseViewController.h"

typedef enum {
    kLocalHtml = 0,
    kRemoteHtml
}HtmlType;

typedef enum {
    kMinFontSize = -1,
    kMiddleFontSize = 0,
    kMaxFontSize
}FontSize;

@interface YFWebViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UIWebView *yfWebView;

/**
 *  必填，用于显示标题
 */
@property (nonatomic, copy) NSString *htmlTitle;
/**
 *  必填，显示html资源的本地/网络路径地址
 */
@property (nonatomic, copy) NSString *htmlPath;
/**
 *  非必填，默认kLocalHtml，显示html类型
 *  kLocalHtml  - 本地html资源
 *  kRemoteHtml - 网络html资源
 */
@property (nonatomic, assign) HtmlType htmlType;
/**
 *  非必填，默认NO. html资源是否已经有phone适配
 *  YES - html资源已经适配phone的样式，直接用于显示
 *  NO  - html资源没有适配phone，需要用本地的phone样式适配后显示
 */
@property (nonatomic, assign) BOOL isContainCSS;
/**
 *  非必填，默认kMiddleFontSize，加载html资源文字大小
 *  kMinFontSize    - 小号字体
 *  kMiddleFontSize - 中号字体
 *  kMaxFontSize    - 大号字体
 */
@property (nonatomic, assign) FontSize fontSize;

@end
