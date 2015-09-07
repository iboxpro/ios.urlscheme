//
//  AppDelegate.h
//  integrationExample
//
//  Created by AxonMacMini on 17.12.14.
//  Copyright (c) 2014 DevReactor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
@private void (^mOpenUrlAction)(NSObject *, NSString *);
@private NSObject *mOpenUrlActionOwner;
}

@property (strong, nonatomic) UIWindow *window;

-(void)setOpenUrlAction:(void (^)(NSObject *, NSString *))action Owner:(NSObject *)owner;

@end

