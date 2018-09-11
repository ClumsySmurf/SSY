//
//  AppDelegate.m
//  SSY
//
//  Created by John Hamilton on 1/16/13.
//  Copyright (c) 2013 SnapApps LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "Apptentive.h"
#import "GAI.h"


@implementation AppDelegate


#define LAST_PUSH_TIME = @"LAST_PUSH_TIME"

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [SSY sequences];
    return YES;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //[MKStoreManager sharedManager];
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    
    // Optional: set Logger to VERBOSE for debug information.
   // [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-51482239-1"];
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    return YES;
}


NSArray *messages () {
    return @[@"“We know... life with kids gets busy. Slow down with a Sing Song Yoga™  Sequence.",
             @"Busy kids love to slow down with Sing Song Yoga™",
             @"Haven’t seen you in a while. Give the Sing Song Yoga™ Bedtime Sequence a try."];
}
- (void)setupLocalPush
{
    NSString *msg = messages()[arc4random() % 2];
    NSLog(@"got msg: %@", msg);
    int time = 86400 * 14;

    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [[NSDate date] dateByAddingTimeInterval:time];
    notification.alertBody = msg;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
      [self setupLocalPush];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self setupLocalPush];
}

@end
