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
__weak IBOutlet UIButton *btnChooseReader;
__weak IBOutlet UIButton *btnAddPurchase;
__weak IBOutlet UIButton *btnAddTag;
__weak IBOutlet UIButton *btnClearPurchases;
__weak IBOutlet UIButton *btnClearTags;
__weak IBOutlet UITextField *txtEmail;
__weak IBOutlet UITextField *txtPassword;
__weak IBOutlet UITextField *txtAmount;
__weak IBOutlet UITextField *txtDescription;
__weak IBOutlet UITextField *txtReceiptEmail;
__weak IBOutlet UITextField *txtReceiptPhone;
__weak IBOutlet UITextField *txtReaderType;
__weak IBOutlet UITextField *txtPurchaseTitle;
__weak IBOutlet UITextField *txtPurchasePrice;
__weak IBOutlet UITextField *txtPurchaseQuantity;
__weak IBOutlet UITextField *txtPurchaseTax;
__weak IBOutlet UITextField *txtTagCode;
__weak IBOutlet UITextField *txtTagValue;
__weak IBOutlet UISegmentedControl *segTagType;
__weak IBOutlet UILabel *lblPurchasesData;
__weak IBOutlet UILabel *lblTagsData;
    
__weak IBOutlet NSLayoutConstraint *ctrScrollBottom;
    
@private UITapGestureRecognizer *mTapGestureRecognizer;
}

@property (strong, nonatomic) NSString *SelectedReader;
@property (strong, nonatomic) NSMutableArray *Purchases;
@property (strong, nonatomic) NSMutableDictionary *Tags;

@end

