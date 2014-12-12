//
//  AddressEditViewController.h
//  SJFood
//
//  Created by 叶帆 on 14/12/12.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "BaseViewController.h"
#import "Address.h"

@interface AddressEditViewController : BaseViewController<UIAlertViewDelegate>

@property (strong, nonatomic) Address *editAddress;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *schoolAreaTextField;
@property (strong, nonatomic) IBOutlet UITextField *addressTextField;

- (IBAction)deleteAddressButtonClicked:(id)sender;

@end
