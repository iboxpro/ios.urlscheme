//
//  ViewController2.h
//  integrationExample
//
//  Created by AxonMacMini on 18.12.14.
//  Copyright (c) 2014 DevReactor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController2 : UIViewController
{
    __weak IBOutlet UIButton *btnBack;
    __weak IBOutlet UITextView *txtData;
}

@property (strong, nonatomic) NSString *Data;

@end
