//
//  SecondViewController.h
//  cfbuploads
//
//  Created by Akshay Easwaran on 11/20/15.
//  Copyright © 2015 Akshay Easwaran. All rights reserved.
//

#import <UIKit/UIKit.h>

@import SafariServices;

@interface FavoritesViewController : UITableViewController

-(void)refreshData:(NSDictionary*)savedDB;
@end

