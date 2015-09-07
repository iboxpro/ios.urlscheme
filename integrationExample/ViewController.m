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

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate setOpenUrlAction:^(NSObject *owner, NSString *data) {
        ViewController *this = (ViewController *)owner;
        ViewController2 *vc2 = [[ViewController2 alloc] initWithNibName:@"ViewController2" bundle:NULL];
        [vc2 setData:data];
        [this.navigationController pushViewController:vc2 animated:TRUE];
    } Owner:self];
    
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return TRUE;
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
    [url appendFormat:@"&caller=%@", [self urlEncode:@"integrationExample://payment"]];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}



-(NSString *)urlEncode:(NSString *)string
{
    return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)string, NULL, (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
}

@end