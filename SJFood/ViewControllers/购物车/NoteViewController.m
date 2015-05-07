//
//  NoteViewController.m
//  SJFood
//
//  Created by 叶帆 on 15/5/7.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "NoteViewController.h"

@interface NoteViewController ()

@end

@implementation NoteViewController
@synthesize noteTextView,contentScrollView,commitButton;

#pragma mark - Private methods
- (NSString *)checkFieldValid
{
    if(noteTextView.text.length < 1)
        return @"请输入订单备注";
    return nil;
}

#pragma mark - IBAction Methods
- (IBAction)commitButtonClicked:(id)sender {
    [self.noteTextView resignFirstResponder];
    NSString *validString = [self checkFieldValid];
    if(validString)
    {
        [[YFProgressHUD sharedProgressHUD] showWithMessage:validString customView:nil hideDelay:4.f];
    }
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:kNoteChangeNotification object:noteTextView.text];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UIView Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"意见反馈"];
    [self.noteTextView becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self.contentScrollView setContentSize:CGSizeMake(ScreenWidth, self.commitButton.frame.origin.y + self.commitButton.frame.size.height + 15.f)];
}

- (void)dealloc
{
    [[YFDownloaderManager sharedManager] cancelDownloaderWithDelegate:self purpose:nil];
}

#pragma mark - Keyboard Notification methords
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.contentScrollView.contentInset = UIEdgeInsetsMake(self.contentScrollView.contentInset.top, self.contentScrollView.contentInset.left, keyboardSize.height, self.contentScrollView.contentInset.right);
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.contentScrollView.contentInset = UIEdgeInsetsMake(self.contentScrollView.contentInset.top, self.contentScrollView.contentInset.left, 0, self.contentScrollView.contentInset.right);
}


#pragma mark - UITextViewDelegate methods
- (void)resignAllField
{
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignAllField];
}

@end
