//
//  NSString+HtmlCss.m
//  SJFood
//
//  Created by 叶帆 on 14/12/2.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "NSString+HtmlCss.h"

@implementation NSString (HtmlCss)

+ (NSString *)adjustHtmlCSSForString:(NSString *)originalString
{
    // Adjust the CSS style of saved html file
    NSString *html = @"";
    NSString *adjustedHtml = @"";
    NSString *infoFilePath = [[NSBundle mainBundle] pathForResource:@"htmlTemplate" ofType:@"html"];
    adjustedHtml = [NSString stringWithContentsOfFile:infoFilePath encoding: NSUTF8StringEncoding error:nil];
    
    html = originalString;
    
    NSString *bodyPart = html;
    NSString *ajustedBodyPart = bodyPart;
    ajustedBodyPart = [ajustedBodyPart stringByReplacingOccurrencesOfString:@"\"width" withString:@"\"nonwidth"];
    ajustedBodyPart = [ajustedBodyPart stringByReplacingOccurrencesOfString:@" width" withString:@" nonwidth"];
    ajustedBodyPart = [ajustedBodyPart stringByReplacingOccurrencesOfString:@";width" withString:@";nonwidth"];
    ajustedBodyPart = [ajustedBodyPart stringByReplacingOccurrencesOfString:@"\"height" withString:@"\"nonheight"];
    ajustedBodyPart = [ajustedBodyPart stringByReplacingOccurrencesOfString:@" height" withString:@" nonheight"];
    ajustedBodyPart = [ajustedBodyPart stringByReplacingOccurrencesOfString:@";height" withString:@";nonheight"];
    
    ajustedBodyPart = [ajustedBodyPart stringByReplacingOccurrencesOfString:@"\"margin-left" withString:@"\"nonmargin-left"];
    ajustedBodyPart = [ajustedBodyPart stringByReplacingOccurrencesOfString:@" margin-left" withString:@" nonmargin-left"];
    ajustedBodyPart = [ajustedBodyPart stringByReplacingOccurrencesOfString:@";margin-left" withString:@";nonmargin-left"];
    ajustedBodyPart = [ajustedBodyPart stringByReplacingOccurrencesOfString:@"\"margin-right" withString:@"\"nonmargin-right"];
    ajustedBodyPart = [ajustedBodyPart stringByReplacingOccurrencesOfString:@" margin-right" withString:@" nonmargin-right"];
    ajustedBodyPart = [ajustedBodyPart stringByReplacingOccurrencesOfString:@";margin-right" withString:@";nonmargin-right"];
    
    ajustedBodyPart = [ajustedBodyPart stringByReplacingOccurrencesOfString:@"text-indent" withString:@"nontext-indent"];
    
    adjustedHtml = [adjustedHtml stringByReplacingOccurrencesOfString:@"%@" withString:ajustedBodyPart];
    //        }
    //    }
    return adjustedHtml;
}

@end
