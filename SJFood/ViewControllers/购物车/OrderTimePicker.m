//
//  OrderTimePicker.m
//  SJFood
//
//  Created by 叶帆 on 15/5/7.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "OrderTimePicker.h"

@interface OrderTimePicker()
@property (nonatomic, strong) NSMutableArray *pickViewInputArray;
@property (nonatomic, strong) NSString *currentHour;
@property (nonatomic, strong) NSString *currentMinute;
@end

@implementation OrderTimePicker
@synthesize orderTimePicker,delegate;
@synthesize pickViewInputArray;
@synthesize currentHour,currentMinute;

#pragma mark - Public methods
- (void)getCurrentHour
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH"];
    NSString *hour = [formatter stringFromDate:[NSDate date]];
    self.currentHour = hour;
}

- (void)getCurrentMinute
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"mm"];
    NSString *minute = [formatter stringFromDate:[NSDate date]];
    self.currentMinute = minute;
}

- (void)reload
{
    [self.pickViewInputArray addObject:@"立即配送"];
    [self getCurrentHour];
    [self getCurrentMinute];
    if ([self.currentMinute intValue] < 30) {
        [self initInputArrayWithHour:[self.currentHour intValue] minute:@"30"];
    } else {
        [self initInputArrayWithHour:[self.currentHour intValue]+1 minute:@"00"];
    }
    [self.orderTimePicker reloadAllComponents];
}

- (void)initInputArrayWithHour:(int )hour minute:(NSString *)minute
{
    while (hour <= 21) {
        [self.pickViewInputArray addObject:[NSString stringWithFormat:@"%d:%@",hour,minute]];
        if (hour == 21 && [minute isEqualToString:@"30"]) {
            break;
        } else {
            if ([minute isEqualToString:@"00"]) {
                minute = @"30";
            } else {
                hour++;
                minute = @"00";
            }
        }
    }
}

#pragma mark - UIView methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.pickViewInputArray = [NSMutableArray arrayWithCapacity:0];
}

#pragma mark - IBActions Methods
- (IBAction)timeCancelButtonClicked:(id)sender {
    [self.delegate didTextCanceled];
}

- (IBAction)timeDoneButtonClicked:(id)sender {
    NSInteger row = [self.orderTimePicker selectedRowInComponent:0];
    NSString *str = [self.pickViewInputArray objectAtIndex:row];
    [self.delegate didTextConfirmed:str];

}

#pragma mark - UIPickerViewDataSource methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickViewInputArray.count;
}

#pragma mark - UIPickerViewDelegate methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.pickViewInputArray objectAtIndex:row];
}
@end
