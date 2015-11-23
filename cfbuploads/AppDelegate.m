//
//  AppDelegate.m
//  cfbuploads
//
//  Created by Akshay Easwaran on 11/20/15.
//  Copyright © 2015 Akshay Easwaran. All rights reserved.
//

#import "AppDelegate.h"
#import "TopVideosViewController.h"
#import "FavoritesViewController.h"

#import <HexColors.h>

@interface AppDelegate ()
@property (strong, nonatomic) UITabBarController *tabBarController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.tabBarController = [[UITabBarController alloc] init];
    UINavigationController *topVidsVC = [[UINavigationController alloc] initWithRootViewController:[[TopVideosViewController alloc] init]];
    [topVidsVC.tabBarItem setTitle:@"Top 25"];
    [topVidsVC.tabBarItem setImage:[UIImage imageNamed:@"charts"]];
    
    UINavigationController *favsVC = [[UINavigationController alloc] initWithRootViewController:[[FavoritesViewController alloc] init]];
    [favsVC.tabBarItem setTitle:@"Saved"];
    [favsVC.tabBarItem setImage:[UIImage imageNamed:@"topvids"]];
    
    [self.tabBarController setViewControllers:@[topVidsVC, favsVC]];
    [self.window setRootViewController:self.tabBarController];
    [self.window makeKeyAndVisible];
    [self setupAppearance];
    
    NSError *sessionError = nil;
    NSError *activationError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
    [[AVAudioSession sharedInstance] setActive: YES error: &activationError];
    return YES;
}

-(void)setupAppearance {
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UITabBar appearance] setBarStyle:UIBarStyleBlack];
    [[UITabBar appearance] setTintColor:[UIColor hx_colorWithHexString:@"#009740"]];
    [[UINavigationBar appearance] setTintColor:[UIColor hx_colorWithHexString:@"#009740"]];
    self.window.tintColor = [UIColor hx_colorWithHexString:@"#009740"];
    
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
