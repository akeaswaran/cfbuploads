//
//  FirstViewController.m
//  cfbuploads
//
//  Created by Akshay Easwaran on 11/20/15.
//  Copyright © 2015 Akshay Easwaran. All rights reserved.
//

#import "TopVideosViewController.h"
#import "FavoritesViewController.h"

#import <RedditKit.h>
#import <XCDYouTubeKit.h>
#import <HexColors.h>
#import <DFCache.h>
#import "ApolloDB.h"
#import "SettingsViewController.h"

@interface TopVideosViewController () {
    NSMutableArray *links;
    DFCache *visitedCache;
    DFCache *savedCache;
}
@end

@implementation TopVideosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshData];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.tintColor = [UIColor darkGrayColor];
    self.title = @"Top 25 Videos";
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView setBackgroundColor:[UIColor hx_colorWithHexString:@"#090909"]];
    [self.tableView setSeparatorColor:[UIColor darkGrayColor]];
    visitedCache = [[DFCache alloc] initWithName:@"visitedCache"];
    savedCache = [[DFCache alloc] initWithName:@"savedCache"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable) name:@"clearedAll" object:nil];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings"] style:UIBarButtonItemStylePlain target:self action:@selector(openSettings)];
}

-(void)openSettings {
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
    settingsViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissVC)];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:settingsViewController] animated:YES completion:nil];
}

-(void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)updateTable {
    [self.tableView reloadData];
}

-(NSDateFormatter*)dateFormatter {
    static dispatch_once_t onceToken;
    static NSDateFormatter *dateFormatter;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMMM d, YYYY"];
    });
    return dateFormatter;
}

-(void)refreshData {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[RKClient sharedClient] linksInSubredditWithName:@"cfbuploads" category:RKSubredditCategoryHot pagination:[RKPagination paginationWithLimit:25] completion:^(NSArray *collection, RKPagination *pagination, NSError *error) {
        if (!error) {
            links = [NSMutableArray arrayWithArray:collection];
            for (RKLink *link in collection) {
                if ([link.title.lowercaseString containsString:@"request"] || link.stickied) {
                    [links removeObject:link];
                }
            }
        
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        } else {
            NSLog(@"ERROR: %@", error);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return links.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoCell"];
    RKLink *link = links[indexPath.row];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"VideoCell"];
        UIView *bgView = [[UIView alloc] initWithFrame:cell.frame];
        [bgView setBackgroundColor:[UIColor hx_colorWithHexString:@"#1A1A1A"]];
        cell.selectedBackgroundView = bgView;
        cell.backgroundColor = [UIColor hx_colorWithHexString:@"#090909"];
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
    }
    
    [cell.textLabel setText:link.title];
    [cell.detailTextLabel setText:[[self dateFormatter] stringFromDate:link.created]];
    if ([visitedCache cachedObjectForKey:link.fullName]) {
        [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //left intentionally empty for row actions to work
}

-(NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    RKLink *link = links[indexPath.row];
    NSDictionary *savedDB = [savedCache cachedObjectForKey:@"savedDB"];
    NSString *saveString = @"Save";
    if ([savedDB objectForKey:link.fullName]) {
        saveString = @"Unsave";
    }
    
    UITableViewRowAction *favAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:saveString handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if (![savedDB objectForKey:link.fullName]) {
            NSLog(@"SAVE");
            [[ApolloDB sharedManager] setObject:@{@"fullName" : link.fullName,
                                                  @"title" : link.title,
                                                  @"url" : link.URL.absoluteString,
                                                  @"created" : [[self dateFormatter] stringFromDate:link.created]
                                                  } forKey:link.fullName];
        } else {
            NSLog(@"UNSAVE");
            [[ApolloDB sharedManager] removeObjectForKey:link.fullName];
        }
        
        NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[[ApolloDB sharedManager] allData]];
        [dataDict removeObjectForKey:@"apdbStatus"];
        NSLog(@"PRESAVE: %@", dataDict);
        [savedCache storeObject:dataDict forKey:@"savedDB"];
        NSLog(@"SAVED: %@", [savedCache cachedObjectForKey:@"savedDB"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"savedUpdate" object:[savedCache cachedObjectForKey:@"savedDB"]];
        [self.tableView reloadData];
    }];
    return @[favAction];
}

-(NSString*)cleanYTURL:(NSURL*)url {
    NSString *clean = [[[[[[[[url.absoluteString stringByReplacingOccurrencesOfString:@"https://www.youtube.com/watch?v=" withString:@""] stringByReplacingOccurrencesOfString:@"youtube.com/watch?v=" withString:@""] stringByReplacingOccurrencesOfString:@"www.youtube.com/watch?v=" withString:@""] stringByReplacingOccurrencesOfString:@"http://www.youtube.com/watch?v=" withString:@""]stringByReplacingOccurrencesOfString:@"https://youtu.be/" withString:@""] stringByReplacingOccurrencesOfString:@"http://youtu.be/" withString:@""] stringByReplacingOccurrencesOfString:@"youtu.be/" withString:@""] stringByReplacingOccurrencesOfString:@"https://m." withString:@""];
    return clean;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RKLink *link = links[indexPath.row];
    if (![visitedCache cachedObjectForKey:link.fullName]) {
        [visitedCache storeObject:[NSNumber numberWithBool:YES] forKey:link.fullName];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell.textLabel setTextColor:[UIColor darkGrayColor]];
        [self.tableView reloadData];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([link.URL.absoluteString containsString:@"youtube"] || [link.URL.absoluteString containsString:@"youtu.be"]) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:[self cleanYTURL:link.URL]];
        [self presentViewController:videoPlayerViewController animated:YES completion:^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
    } else {
        SFSafariViewController *webController = [[SFSafariViewController alloc] initWithURL:link.URL entersReaderIfAvailable:YES];
        [self presentViewController:webController animated:YES completion:nil];
    }
}

@end
