//
//  COAppDelegate.m
//  codestock
//
//  Created by Adam Byram on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CodeStockAppDelegate.h"
#import "COSpeakerListViewController.h"
#import "COSessionListViewController.h"
#import "CORoomListViewController.h"
#import "CODataManager.h"

@implementation CodeStockAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    UINavigationController *sessionListController = [[UINavigationController alloc] initWithRootViewController:[[COSessionListViewController alloc] initWithNibName:@"COSessionListViewController" bundle:nil]];
    [sessionListController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    sessionListController.tabBarItem.title = @"Sessions";
    
    UINavigationController *speakerListController = [[UINavigationController alloc] initWithRootViewController:[[COSpeakerListViewController alloc] initWithNibName:@"COSpeakerListViewController" bundle:nil]];
    [speakerListController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    speakerListController.tabBarItem.title = @"Speakers";
    
    UINavigationController *roomListController = [[UINavigationController alloc] initWithRootViewController:[[CORoomListViewController alloc] initWithNibName:@"CORoomListViewController" bundle:nil]];
    [roomListController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    roomListController.tabBarItem.title = @"Rooms";
    
    self.tabBarController = [[UITabBarController alloc] init];
    [self.tabBarController setViewControllers:[NSArray arrayWithObjects:sessionListController, speakerListController, roomListController, nil]];
    self.tabBarController.delegate = self;
    self.window.rootViewController = self.tabBarController;

    [self performSelector:@selector(startDataManager) withObject:nil afterDelay:0.1];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)startDataManager
{
    [[CODataManager sharedInstance] startup];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
