//
//  ViewController.m
//  integrationExample
//
//  Created by AxonMacMini on 17.12.14.
//  Copyright (c) 2014 DevReactor. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "ViewController2.h"

@implementation ViewController

@synthesize SelectedReader = mSelectedReader;
@synthesize Purchases = mPurchases;
@synthesize Tags = mTags;

#pragma mark - ViewController methods
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setSelectedReader:@""];
    [self setPurchases:[[NSMutableArray alloc] init]];
    [self setTags:[[NSMutableDictionary alloc] init]];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate setOpenUrlAction:^(NSObject *owner, NSString *data) {
        ViewController *this = (ViewController *)owner;
        ViewController2 *vc2 = [[ViewController2 alloc] initWithNibName:@"ViewController2" bundle:NULL];
        [vc2 setData:data];
        [this.navigationController pushViewController:vc2 animated:TRUE];
    } Owner:self];
    
    mTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [mTapGestureRecognizer setNumberOfTapsRequired:1];
    [mTapGestureRecognizer setNumberOfTouchesRequired:1];
    
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [btnChooseReader addTarget:self action:@selector(btnChooseReaderClick) forControlEvents:UIControlEventTouchUpInside];
    [btnAddPurchase addTarget:self action:@selector(btnAddPurchaseClick) forControlEvents:UIControlEventTouchUpInside];
    [btnClearPurchases addTarget:self action:@selector(btnClearPurchasesClick) forControlEvents:UIControlEventTouchUpInside];
    [btnAddTag addTarget:self action:@selector(btnAddTagClick) forControlEvents:UIControlEventTouchUpInside];
    [btnClearTags addTarget:self action:@selector(btnClearTagsClick) forControlEvents:UIControlEventTouchUpInside];
    
    [txtEmail setText:@"oleg@oleg.oleg:ua_kiev"];
    [txtPassword setText:@"iniesta9"];
    [txtAmount setText:@"1256.00"];
    [txtDescription setText:@"desc"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self enableKeyboardObservers];
    [self.view addGestureRecognizer:mTapGestureRecognizer];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self disableKeyboardObservers];
    [super viewWillDisappear:animated];
}

#pragma mark - Keyboard observers
-(void)enableKeyboardObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:NULL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:NULL];
}

-(void)disableKeyboardObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Events
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return TRUE;
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    float bottomMargin = 260.0f;
    [ctrScrollBottom setConstant:bottomMargin];
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.view layoutIfNeeded];
    } completion:NULL];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [ctrScrollBottom setConstant:0.0f];
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.view layoutIfNeeded];
    } completion:NULL];
}

-(void)btnClick
{
    NSMutableString *url = [[NSMutableString alloc] init];
    [url appendString:@"ibox://payment?"];
    [url appendFormat:@"email=%@", [self urlEncode:txtEmail.text]];
    [url appendFormat:@"&password=%@", [self urlEncode:txtPassword.text]];
    [url appendFormat:@"&amount=%@", [self urlEncode:txtAmount.text]];
    [url appendFormat:@"&description=%@", [self urlEncode:txtDescription.text]];
    [url appendFormat:@"&receiptEmail=%@", [self urlEncode:txtReceiptEmail.text]];
    [url appendFormat:@"&receiptPhone=%@", [self urlEncode:txtReceiptPhone.text]];
    [url appendFormat:@"&extID=%@", @"12345"];
    if (mSelectedReader && ![mSelectedReader isEqualToString:@""])
        [url appendFormat:@"&readerType=%@", [self urlEncode:mSelectedReader]];
    [url appendFormat:@"&caller=%@", [self urlEncode:@"integrationExample://payment"]];
    
    NSMutableDictionary *auxData = [[NSMutableDictionary alloc] init];
    if (mPurchases && [mPurchases count])
    {
        [auxData setObject:mPurchases forKey:@"Purchases"];
    }
    
    if (mTags && [[mTags allKeys] count] &&
        ![segTagType selectedSegmentIndex])
    {
        [auxData setObject:mTags forKey:@"Tags"];
    }
    
    if (auxData && [[auxData allKeys] count])
    {
        NSError *error = NULL;
        NSData *jsonData = [NSJSONSerialization  dataWithJSONObject:auxData options:0 error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error && jsonString && ![jsonString isEqualToString:@""])
            [url appendFormat:@"&Purchases=%@", [self urlEncode:jsonString]];
    }
    
    // Test 1
    //NSString *url = @"ibox://payment?email=agent%40integration.demo&password=integration123&amount=150&description=test%20description&receiptEmail=mac%40devreactor.com&receiptPhone=&caller=integrationExample%3A%2F%2Fpayment";
    
    // Test 2
    //NSString *url = @"ibox://payment?email=oleg%40oleg.oleg&password=iniesta9&amount=150&description=test%20description&receiptEmail=mac%40devreactor.com&receiptPhone=&caller=integrationExample%3A%2F%2Fpayment";
    
    // Test with purchases
    //NSString *url = @"ibox://payment?email=oleg%40oleg.oleg&password=iniesta9&amount=1600&description=test%20description&receiptEmail=mac%40devreactor.com&receiptPhone=&caller=integrationExample%3A%2F%2Fpayment&Purchases=%7B%0D%0A%20%20%22Purchases%22%3A%20%5B%0D%0A%20%20%20%20%7B%0D%0A%20%20%20%20%20%20%22TaxCode%22%3A%20%5B%0D%0A%20%20%20%20%20%20%20%20%22VAT1800%22%0D%0A%20%20%20%20%20%20%5D%2C%0D%0A%20%20%20%20%20%20%22Title%22%3A%20%22%D0%9F%D0%BE%D0%B7%D0%B8%D1%86%D0%B8%D1%8F%2018%20%D0%BD%D0%B4%D1%81%22%2C%0D%0A%20%20%20%20%20%20%22Quantity%22%3A%203%2C%0D%0A%20%20%20%20%20%20%22Price%22%3A%20150.00%0D%0A%20%20%20%20%7D%2C%0D%0A%20%20%20%20%7B%0D%0A%20%20%20%20%20%20%22TaxCode%22%3A%20%5B%0D%0A%20%20%20%20%20%20%20%20%22VAT1000%22%0D%0A%20%20%20%20%20%20%5D%2C%0D%0A%20%20%20%20%20%20%22Title%22%3A%20%22%D0%9F%D0%BE%D0%B7%D0%B8%D1%86%D0%B8%D1%8F%2010%20%D0%BD%D0%B4%D1%81%22%2C%0D%0A%20%20%20%20%20%20%22Quantity%22%3A%203%2C%0D%0A%20%20%20%20%20%20%22Price%22%3A%20150.15%0D%0A%20%20%20%20%7D%2C%0D%0A%7B%0D%0A%20%20%20%20%20%20%22TaxCode%22%3A%20%5B%0D%0A%20%20%20%20%20%20%20%20%22VAT2000%22%0D%0A%20%20%20%20%20%20%5D%2C%0D%0A%20%20%20%20%20%20%22Title%22%3A%20%22%D0%9F%D0%BE%D0%B7%D0%B8%D1%86%D0%B8%D1%8F%2020%20%D0%BD%D0%B4%D1%81%22%2C%0D%0A%20%20%20%20%20%20%22Quantity%22%3A%201%2C%0D%0A%20%20%20%20%20%20%22Price%22%3A%20100.00%0D%0A%20%20%20%20%7D%2C%0D%0A%20%20%20%20%7B%0D%0A%20%20%20%20%20%20%22TaxCode%22%3A%20%5B%0D%0A%20%20%20%20%20%20%20%20%22VAT0000%22%0D%0A%20%20%20%20%20%20%5D%2C%0D%0A%20%20%20%20%20%20%22Title%22%3A%20%22%D0%9F%D0%BE%D0%B7%D0%B8%D1%86%D0%B8%D1%8F%200%20%D0%BD%D0%B4%D1%81%22%2C%0D%0A%20%20%20%20%20%20%22Quantity%22%3A%205%2C%0D%0A%20%20%20%20%20%20%22Price%22%3A%20100.00%0D%0A%20%20%20%20%7D%2C%0D%0A%20%20%20%20%7B%0D%0A%20%20%20%20%20%20%22TaxCode%22%3A%20%5B%0D%0A%20%20%20%20%20%20%20%20%0D%0A%20%20%20%20%20%20%5D%2C%0D%0A%20%20%20%20%20%20%22Title%22%3A%20%22%D0%9F%D0%BE%D0%B7%D0%B8%D1%86%D0%B8%D1%8F%20%D0%91%D0%B5%D0%B7%20%D0%BD%D0%B4%D1%81%22%2C%0D%0A%20%20%20%20%20%20%22Quantity%22%3A%201%2C%0D%0A%20%20%20%20%20%20%22Price%22%3A%2099.55%0D%0A%20%20%20%20%7D%0D%0A%20%20%5D%0D%0A%7D%20";
    
    //NSString *url = @"ibox://payment?email=oleg%40oleg.oleg&password=iniesta9&amount=1600&description=test%20description&receiptEmail=mac%40devreactor.com&receiptPhone=&caller=integrationExample%3A%2F%2Fpayment&Purchases=%7B%0D%0A%20%20%22Purchases%22%3A%20%5B%0A%20%20%20%20%7B%0A%20%20%20%20%20%20%22TaxCode%22%3A%20%5B%0A%20%20%20%20%20%20%20%20%22VAT1800%22%0A%20%20%20%20%20%20%5D%2C%0A%20%20%20%20%20%20%22Title%22%3A%20%22%D0%9F%D0%BE%D0%B7%D0%B8%D1%86%D0%B8%D1%8F%2018%20%D0%BD%D0%B4%D1%81%22%2C%0A%20%20%20%20%20%20%22Quantity%22%3A%203%2C%0A%20%20%20%20%20%20%22Price%22%3A%20150.00%0A%20%20%20%20%7D%2C%0A%20%20%20%20%7B%0A%20%20%20%20%20%20%22TaxCode%22%3A%20%5B%0A%20%20%20%20%20%20%20%20%22VAT1000%22%0A%20%20%20%20%20%20%5D%2C%0A%20%20%20%20%20%20%22Title%22%3A%20%22%D0%9F%D0%BE%D0%B7%D0%B8%D1%86%D0%B8%D1%8F%2010%20%D0%BD%D0%B4%D1%81%22%2C%0A%20%20%20%20%20%20%22Quantity%22%3A%203%2C%0A%20%20%20%20%20%20%22Price%22%3A%20150.15%0A%20%20%20%20%7D%2C%0A%7B%0A%20%20%20%20%20%20%221030%22%3A%20%22%D0%9F%D0%BE%D0%B7%D0%B8%D1%86%D0%B8%D1%8F%20%D1%82%22%2C%0A%20%20%20%20%20%20%221023%22%3A%201%2C%0A%20%20%20%20%20%20%221079%22%3A%20100.00%2C%0A%20%20%20%20%20%20%221199%22%3A%202%0A%20%20%20%20%7D%2C%0A%20%20%20%20%7B%0A%20%20%20%20%20%20%22TaxCode%22%3A%20%5B%0A%20%20%20%20%20%20%20%20%22VAT0000%22%0A%20%20%20%20%20%20%5D%2C%0A%20%20%20%20%20%20%22Title%22%3A%20%22%D0%9F%D0%BE%D0%B7%D0%B8%D1%86%D0%B8%D1%8F%200%20%D0%BD%D0%B4%D1%81%22%2C%0A%20%20%20%20%20%20%22Quantity%22%3A%205%2C%0A%20%20%20%20%20%20%22Price%22%3A%20100.00%0A%20%20%20%20%7D%2C%0A%20%20%20%20%7B%0A%20%20%20%20%20%20%22TaxCode%22%3A%20%5B%0A%20%20%20%20%20%20%20%20%0A%20%20%20%20%20%20%5D%2C%0A%20%20%20%20%20%20%22Title%22%3A%20%22%D0%9F%D0%BE%D0%B7%D0%B8%D1%86%D0%B8%D1%8F%20%D0%91%D0%B5%D0%B7%20%D0%BD%D0%B4%D1%81%22%2C%0A%20%20%20%20%20%20%22Quantity%22%3A%201%2C%0A%20%20%20%20%20%20%22Price%22%3A%2099.55%0A%20%20%20%20%7D%0A%20%20%5D%0A%7D%20";
    
    //NSString *url = @"ibox://payment?email=oleg%40oleg.oleg&password=iniesta9&amount=150&description=test%20description&receiptEmail=mac%40devreactor.com&receiptPhone=&caller=integrationExample%3A%2F%2Fpayment&Purchases=%7B%0D%0A%20%20%22Purchases%22%3A%20%5B%0D%0A%20%20%20%20%7B%0D%0A%20%20%20%20%20%20%22TaxCode%22%3A%20%5B%0D%0A%20%20%20%20%20%20%20%20%22VAT1800%22%0D%0A%20%20%20%20%20%20%5D%2C%0D%0A%20%20%20%20%20%20%22Title%22%3A%20%22%D0%9F%D0%BE%D0%B7%D0%B8%D1%86%D0%B8%D1%8F%201%22%2C%0D%0A%20%20%20%20%20%20%22Quantity%22%3A%202%2C%0D%0A%20%20%20%20%20%20%22Price%22%3A%20150.25%0D%0A%20%20%20%20%7D%2C%0D%0A%20%20%20%20%7B%0D%0A%20%20%20%20%20%20%22TaxCode%22%3A%20%5B%0D%0A%20%20%20%20%20%20%20%20%0D%0A%20%20%20%20%20%20%5D%2C%0D%0A%20%20%20%20%20%20%22Title%22%3A%20%22%D0%9F%D0%BE%D0%B7%D0%B8%D1%86%D0%B8%D1%8F%202%22%2C%0D%0A%20%20%20%20%20%20%22Quantity%22%3A%201%2C%0D%0A%20%20%20%20%20%20%22Price%22%3A%20100%0D%0A%20%20%20%20%7D%0D%0A%20%20%5D%0D%0A%7D";
    
    //NSString *url = @"ibox://payment?email=agent@mac.demo&password=123123123&amount=1200&description=test%20description&receiptemail=mac%40devreactor.com&receiptPhone=&caller=integrationExample%3A%2F%2Fpayment&Purchases=%7B%0A%22Purchases%22%3A%20%5B%7B%0A%22TaxCode%22%3A%20%5B%22VAT1800%22%5D%2C%0A%22Title%22%3A%20%22%D0%9F%D0%BE%D0%B7%D0%B8%D1%86%D0%B8%D1%8F%2018%20%D0%BD%D0%B4%D1%81%22%2C%0A%22Quantity%22%3A%203%2C%0A%22Price%22%3A%20150.00%0A%7D%2C%7B%0A%22TaxCode%22%3A%20%5B%22VAT1000%22%5D%2C%0A%22Title%22%3A%20%22%D0%9F%D0%BE%D0%B7%D0%B8%D1%86%D0%B8%D1%8F%2010%20%D0%BD%D0%B4%D1%81%22%2C%0A%22Quantity%22%3A%203%2C%0A%22Price%22%3A%20150.15%0A%7D%2C%7B%0A%22TaxCode%22%3A%20%5B%22VAT2000%22%5D%2C%0A%22Title%22%3A%20%22%D0%9F%D0%BE%D0%B7%D0%B8%D1%86%D0%B8%D1%8F%2020%20%D0%BD%D0%B4%D1%81%22%2C%0A%22Quantity%22%3A%201%2C%0A%22Price%22%3A%20100.20%0A%7D%2C%7B%0A%22TaxCode%22%3A%20%5B%22VAT0000%22%5D%2C%0A%22Title%22%3A%20%22%D0%9F%D0%BE%D0%B7%D0%B8%D1%86%D0%B8%D1%8F%200%20%D0%BD%D0%B4%D1%81%22%2C%0A%22Quantity%22%3A%205%2C%0A%22Price%22%3A%20100.15%0A%7D%2C%7B%0A%22TaxCode%22%3A%20%5B%5D%2C%0A%22Title%22%3A%20%22%D0%9F%D0%BE%D0%B7%D0%B8%D1%86%D0%B8%D1%8F%20%D0%91%D0%B5%D0%B7%20%D0%BD%D0%B4%D1%81%22%2C%0A%22Quantity%22%3A%201%2C%0A%22Price%22%3A%2099.55%0A%7D%2C%7B%0A%22TaxCode%22%3A%20%5B%22VAT10110%22%5D%2C%0A%22Title%22%3A%20%22%D0%9F%D0%BE%D0%B7%D0%B8%D1%86%D0%B8%D1%8F%20%D0%BD%D0%B4%D1%81%2010%2F110%22%2C%0A%22Quantity%22%3A%201%2C%0A%22Price%22%3A%20110.00%0A%7D%2C%7B%0A%22TaxCode%22%3A%20%5B%22VAT20120%22%5D%2C%0A%22Title%22%3A%20%22%D0%9F%D0%BE%D0%B7%D0%B8%D1%86%D0%B8%D1%8F%20%D0%BD%D0%B4%D1%81%2020%2F120%22%2C%0A%22Quantity%22%3A%201%2C%0A%22Price%22%3A%20240.00%0A%7D%5D%0A%7D";
    
    //NSString *url = @"ibox://payment?email=qunsuo%40test.demo&password=123123123&amount=1000&description=test%20description&receiptEmail=y.stupnitskaya%40smart-fin.ru&receiptPhone=%2B79685409773&PrinterFooter=testtesttest&caller=integrationExample%3A%2F%2Fpayment&Purchases=%7B%0D%0A%20%20%22Purchases%22%3A%20%5B%7B%0D%0A%20%20%20%20%20%20%22TaxCode%22%3A%20%5B%22VATNA%22%5D%2C%0D%0A%20%20%20%20%20%20%22Title%22%3A%20%22%D0%9F%D0%BE%D0%B7%D0%B8%D1%86%D0%B8%D1%8F%20%D0%B1%D0%B5%D0%B7%20%D0%BD%D0%B4%D1%81%22%2C%0D%0A%20%20%20%20%20%20%22Quantity%22%3A%203%2C%0D%0A%20%20%20%20%20%20%22Price%22%3A%20150.00%0D%0A%20%20%20%20%7D%5D%0D%0A%7D";
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

-(void)btnChooseReaderClick
{
    [txtDescription resignFirstResponder];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Reader type" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:NULL otherButtonTitles:@"CHIP&SIGN", @"CHIP&PIN", @"QPOSMINI", NULL];
    [actionSheet showInView:self.view];
}

-(void)btnAddPurchaseClick
{
    NSMutableDictionary *purchase = [[NSMutableDictionary alloc] init];
    if (![segTagType selectedSegmentIndex])
    {
        if ([txtPurchaseTitle text] && ![[txtPurchaseTitle text] isEqualToString:@""])
            [purchase setObject:[txtPurchaseTitle text] forKey:@"Title"];
        NSDecimalNumber *price = [[NSDecimalNumber alloc] initWithString:[txtPurchasePrice text]];
        if (price && ![price isEqual:[NSDecimalNumber notANumber]] && price.integerValue != 0)
            [purchase setObject:price forKey:@"Price"];
        NSDecimalNumber *quantity = [[NSDecimalNumber alloc] initWithString:[txtPurchaseQuantity text]];
        if (quantity && ![quantity isEqual:[NSDecimalNumber notANumber]] && quantity.integerValue != 0)
            [purchase setObject:quantity forKey:@"Quantity"];
        
        if ([txtPurchaseTax text] && ![[txtPurchaseTax text] isEqualToString:@""])
        {
            NSMutableArray *taxes = [[NSMutableArray alloc] init];
            [taxes addObject:[txtPurchaseTax text]];
            [purchase setObject:taxes forKey:@"TaxCode"];
        }
        
        [txtPurchaseTitle setText:NULL];
        [txtPurchasePrice setText:NULL];
        [txtPurchaseQuantity setText:NULL];
        [txtPurchaseTax setText:NULL];
    }
    else if ([segTagType selectedSegmentIndex] == 1)
    {
        for (int i = 0; i < [[mTags allKeys] count]; i++)
        {
            NSString *key = [[mTags allKeys] objectAtIndex:i];
            NSObject *value = [mTags objectForKey:key];
            if (value && ![value isEqual:[NSNull null]])
                [purchase setObject:value forKey:key];
        }
        
        [self btnClearTagsClick];
    }
    
    if ([[purchase allKeys] count])
        [mPurchases addObject:purchase];
    
    if (mPurchases && [mPurchases count])
    {
        NSError *error = NULL;
        NSData *jsonData = [NSJSONSerialization  dataWithJSONObject:mPurchases options:0 error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error && jsonString && ![jsonString isEqualToString:@""])
            [lblPurchasesData setText:jsonString];
    }
}

-(void)btnClearPurchasesClick
{
    [mPurchases removeAllObjects];
    [lblPurchasesData setText:@"No purchase data."];
}

-(void)btnAddTagClick
{
    if (![self stringIsNullOrEmty:[txtTagCode text]] &&
        ![self stringIsNullOrEmty:[txtTagValue text]])
    {
        NSString *tagValue = [txtTagValue text];
        NSCharacterSet *notDigits = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
        if ([tagValue rangeOfCharacterFromSet:notDigits].location == NSNotFound)
        {
            NSDecimalNumber *numericValue = [[NSDecimalNumber alloc] initWithString:tagValue];
            [mTags setObject:numericValue forKey:[txtTagCode text]];
        }
        else
        {
            [mTags setObject:tagValue forKey:[txtTagCode text]];
        }
        
        [txtTagCode setText:NULL];
        [txtTagValue setText:NULL];
        
        if (mTags && [[mTags allKeys] count])
        {
            NSError *error = NULL;
            NSData *jsonData = [NSJSONSerialization  dataWithJSONObject:mTags options:0 error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            if (!error && jsonString && ![jsonString isEqualToString:@""])
                [lblTagsData setText:jsonString];
        }
    }
}

-(void)btnClearTagsClick
{
    [mTags removeAllObjects];
    [lblTagsData setText:@"No tags data."];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *readerName = NULL;
    NSString *readerKey = NULL;
    if (buttonIndex == 0)
    {
        readerName = @"CHIP&SIGN";
        readerKey = @"BBPos_uEMVSwipe";
    }
    else if (buttonIndex == 1)
    {
        readerName = @"CHIP&PIN";
        readerKey = @"BBPos_WisePad";
    }
    else if (buttonIndex == 2)
    {
        readerName = @"QPOSMINI";
        readerKey = @"DSPREAD_QPOSMINI";
    }
    
    [txtReaderType setText:readerName];
    [self setSelectedReader:readerKey];
}

-(void)tap
{
    [txtEmail resignFirstResponder];
    [txtPassword resignFirstResponder];
    [txtAmount resignFirstResponder];
    [txtDescription resignFirstResponder];
    [txtReceiptEmail resignFirstResponder];
    [txtReceiptPhone resignFirstResponder];
    [txtReaderType resignFirstResponder];
    [txtPurchaseTitle resignFirstResponder];
    [txtPurchasePrice resignFirstResponder];
    [txtPurchaseQuantity resignFirstResponder];
    [txtPurchaseTax resignFirstResponder];
    [txtTagCode resignFirstResponder];
    [txtTagValue resignFirstResponder];
}

#pragma mark - Other methods
-(NSString *)urlEncode:(NSString *)string
{
    return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)string, NULL, (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
}

-(BOOL)stringIsNullOrEmty:(NSString *)string
{
    return (!string || [string isEqualToString:@""]);
}

@end
