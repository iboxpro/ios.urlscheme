//
//  ViewController.h
//  integrationExample
//
//  Created by AxonMacMini on 17.12.14.
//  Copyright (c) 2014 DevReactor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate, UIActionSheetDelegate>
{
__weak IBOutlet UIButton *btn;
__weak IBOutlet UITextField *txtEmail;
__weak IBOutlet UITextField *txtPassword;
__weak IBOutlet UITextField *txtAmount;
__weak IBOutlet UITextField *txtDescription;
__weak IBOutlet UITextField *txtReceiptEmail;
__weak IBOutlet UITextField *txtReceiptPhone;
}

@end

