//
//  SecondViewController.m
//  cfbuploads
//
//  Created by Akshay Easwaran on 11/20/15.
//  Copyright © 2015 Akshay Easwaran. All rights reserved.
//

#import "FavoritesViewController.h"

#import <DFCache.h>
#import <RedditKit.h>
#import <HexColors.h>
#import "ApolloDB.h"
#import <XCDYouTubeKit.h>

@interface FavoritesViewController ()
{
    NSMutableArray *links;
    DFCache *visitedCache;
    DFCache *savedCache;
    NSDictionary *savedData;
}
@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Saved";
    visitedCache = [[DFCache alloc] initWithName:@"visitedCache"];
    savedCache = [[DFCache alloc] initWithName:@"savedCache"];
    [self refreshData:[savedCache cachedObjectForKey:@"savedDB"]];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView setBackgroundColor:[UIColor hx_colorWithHexString:@"#090909"]];
    [self.tableView setSeparatorColor:[UIColor darkGrayColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshViaNotification:) name:@"savedUpdate" object:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear All" style:UIBarButtonItemStylePlain target:self action:@selector(clearAllSaved)];
    if (links.count > 0) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    } else {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
    
}

-(void)clearAllSaved {
    [links removeAllObjects];
    [self.tableView reloadData];
    [savedCache removeAllObjects];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clearedAll" object:nil];
    NSLog(@"LINKS SAVED: %@", links);
    NSLog(@"TOTAL: %li", links.count);
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
}

-(void)refreshViaNotification:(NSNotification*)notification {
    [self refreshData:notification.object];
}

-(void)refreshData:(NSDictionary*)savedDB {
    savedData = savedDB;
    links = [NSMutableArray arrayWithArray:[savedData allValues]];
    NSLog(@"LINKS SAVED: %@", links);
    [self.tableView reloadData];
    NSLog(@"TOTAL: %li", links.count);
    if (links.count > 0) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    } else {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return links.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoCell"];
    NSDictionary *link = links[indexPath.row];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"VideoCell"];
        UIView *bgView = [[UIView alloc] initWithFrame:cell.frame];
        [bgView setBackgroundColor:[UIColor hx_colorWithHexString:@"#1A1A1A"]];
        cell.selectedBackgroundView = bgView;
        cell.backgroundColor = [UIColor hx_colorWithHexString:@"#090909"];
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
    }
    
    [cell.textLabel setText:link[@"title"]];
    [cell.detailTextLabel setText:link[@"created"]];
    if ([visitedCache cachedObjectForKey:link[@"fullName"]]) {
        [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //left intentionally empty for row actions to work
}

-(NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *link = links[indexPath.row];
    NSDictionary *savedDB = [savedCache cachedObjectForKey:@"savedDB"];
    NSString *saveString = @"Save";
    if ([savedDB objectForKey:link[@"fullName"]]) {
        saveString = @"Unsave";
    }
    
    UITableViewRowAction *favAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:saveString handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if (![savedDB objectForKey:link[@"fullName"]]) {
            NSLog(@"SAVE");
            [[ApolloDB sharedManager] setObject:@{@"fullName" : link[@"fullName"],
                                                  @"title" : link[@"title"],
                                                  @"url" : link[@"url"],
                                                  @"created" : link[@"created"]
                                                  } forKey:link[@"fullName"]];
        } else {
            NSLog(@"UNSAVE");
            [[ApolloDB sharedManager] removeObjectForKey:link[@"fullName"]];
        }
        
        NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[[ApolloDB sharedManager] allData]];
        [dataDict removeObjectForKey:@"apdbStatus"];
        [savedCache storeObject:[dataDict copy] forKey:@"savedDB"];
        [self refreshData:[savedCache cachedObjectForKey:@"savedDB"]];
        [self.tableView reloadData];
    }];
    return @[favAction];
}

-(NSString*)cleanYTURL:(NSURL*)url {
    NSString *clean = [[[[[[[[url.absoluteString stringByReplacingOccurrencesOfString:@"https://www.youtube.com/watch?v=" withString:@""] stringByReplacingOccurrencesOfString:@"youtube.com/watch?v=" withString:@""] stringByReplacingOccurrencesOfString:@"www.youtube.com/watch?v=" withString:@""] stringByReplacingOccurrencesOfString:@"http://www.youtube.com/watch?v=" withString:@""]stringByReplacingOccurrencesOfString:@"https://youtu.be/" withString:@""] stringByReplacingOccurrencesOfString:@"http://youtu.be/" withString:@""] stringByReplacingOccurrencesOfString:@"youtu.be/" withString:@""] stringByReplacingOccurrencesOfString:@"https://m." withString:@""];
    return clean;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *link = links[indexPath.row];
    if (![visitedCache cachedObjectForKey:link[@"fullName"]]) {
        [visitedCache storeObject:[NSNumber numberWithBool:YES] forKey:link[@"fullName"]];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell.textLabel setTextColor:[UIColor darkGrayColor]];
        [self.tableView reloadData];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([link[@"url"] containsString:@"youtube"]) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:[self cleanYTURL:[NSURL URLWithString:link[@"url"]]]];
        [self presentViewController:videoPlayerViewController animated:YES completion:^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
    } else {
        SFSafariViewController *webController = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:link[@"url"]]entersReaderIfAvailable:YES];
        [self presentViewController:webController animated:YES completion:nil];
    }
}

@end
