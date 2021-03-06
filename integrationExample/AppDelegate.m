//
//  AppDelegate.m
//  integrationExample
//
//  Created by AxonMacMini on 17.12.14.
//  Copyright (c) 2014 DevReactor. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString *decodedQuery = (__bridge NSString *) CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)[url query], CFSTR(""), kCFStringEncodingUTF8);
    
    if (mOpenUrlAction)
        mOpenUrlAction(mOpenUrlActionOwner, decodedQuery);
    
    return TRUE;
}

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setBackgroundColor:[UIColor redColor]];
    
    UINavigationController *nvc = [[UINavigationController alloc] init];
    [nvc setNavigationBarHidden:TRUE];
    [self.window setRootViewController:nvc];
    [self.window makeKeyAndVisible];
    
    ViewController *vc = [[ViewController alloc] initWithNibName:@"ViewController" bundle:NULL];
    [nvc pushViewController:vc animated:FALSE];
    
    return TRUE;
}

-(void)setOpenUrlAction:(void (^)(NSObject *, NSString *))action Owner:(NSObject *)owner
{
    mOpenUrlAction = action;
    mOpenUrlActionOwner = owner;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
