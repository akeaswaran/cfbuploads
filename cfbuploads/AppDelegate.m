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
#import <RedditKit.h>

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
    
    [[RKClient sharedClient] setUserAgent:@"/r/CFBUploads app by /u/SHIVADOC"];
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

@end
