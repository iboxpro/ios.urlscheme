//
//  ViewController2.m
//  integrationExample
//
//  Created by AxonMacMini on 18.12.14.
//  Copyright (c) 2014 DevReactor. All rights reserved.
//

#import "ViewController2.h"

@implementation ViewController2

@synthesize Data;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableString *data = [[NSMutableString alloc] init];
    if (Data && ![Data isEqual:@""])
    {
        NSArray *components = [Data componentsSeparatedByString:@"&"];
        for (NSString *component in components)
        {
            NSArray *keyValue = [component componentsSeparatedByString:@"="];
            if ([keyValue count] == 2)
            {
                NSString *key = [[keyValue objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSString *value = [[keyValue objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [data appendFormat:@"%@ = %@\n", key, value];
            }
        }
    }
    [txtData setText:data];
    
    [btnBack addTarget:self action:@selector(btnBackClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)btnBackClick
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

@end
