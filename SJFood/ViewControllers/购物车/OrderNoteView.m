//
//  OrderNoteView.m
//  SJFood
//
//  Created by 叶帆 on 15/5/7.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "OrderNoteView.h"

@implementation OrderNoteView

#pragma mark - NSNotification Methods
- (void)timeChangeNotification:(NSNotification *)notification
{
    if (notification.object) {
        self.timeLabel.text = notification.object;
    }
}

#pragma mark - IBAction Methods
- (IBAction)timeButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:kTimeNotification object:nil];
}

- (IBAction)noteButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:kNoteNotification object:nil];
    
}
#pragma mark - UIView methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(timeChangeNotification:) name:kTimeChangeNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
