//
//  OrderTimePicker.h
//  SJFood
//
//  Created by 叶帆 on 15/5/7.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderTimePickerViewDelegate;

@interface OrderTimePicker : UIView

@property (strong, nonatomic) IBOutlet UIPickerView *orderTimePicker;
@property (nonatomic, assign) id<OrderTimePickerViewDelegate> delegate;
- (void)reload;
- (IBAction)timeCancelButtonClicked:(id)sender;
- (IBAction)timeDoneButtonClicked:(id)sender;

@end

@protocol OrderTimePickerViewDelegate <NSObject>
- (void)didTextCanceled;
- (void)didTextConfirmed:(NSString *)textValue;
@end
