//
//  SettingsViewController.m
//  cfbuploads
//
//  Created by Akshay Easwaran on 11/23/15.
//  Copyright © 2015 Akshay Easwaran. All rights reserved.
//

#import "SettingsViewController.h"

#import <HexColors.h>
#import <DFCache.h>
#import "SUBLicenseViewController.h"

@interface SettingsViewController () {
    DFCache *visitedCache;
    DFCache *savedCache;
}
@end

@implementation SettingsViewController

-(instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Settings";
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView setBackgroundColor:[UIColor hx_colorWithHexString:@"#090909"]];
    [self.tableView setSeparatorColor:[UIColor darkGrayColor]];
    visitedCache = [[DFCache alloc] initWithName:@"visitedCache"];
    savedCache = [[DFCache alloc] initWithName:@"savedCache"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 1) {
        return 4;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ButtonCell"];
            UIView *bgView = [[UIView alloc] initWithFrame:cell.frame];
            [bgView setBackgroundColor:[UIColor hx_colorWithHexString:@"#1A1A1A"]];
            cell.selectedBackgroundView = bgView;
            cell.backgroundColor = [UIColor hx_colorWithHexString:@"#090909"];
            [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
            [cell.textLabel setTextColor:[UIColor whiteColor]];
            [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"Licenses"];
        }
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ButtonCell"];
            UIView *bgView = [[UIView alloc] initWithFrame:cell.frame];
            [bgView setBackgroundColor:[UIColor hx_colorWithHexString:@"#1A1A1A"]];
            cell.selectedBackgroundView = bgView;
            
            cell.backgroundColor = [UIColor hx_colorWithHexString:@"#090909"];
            [cell.textLabel setTextColor:self.view.tintColor];
        }
        
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"Icons provided by Icons8"];
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        } else if (indexPath.row == 1) {
            [cell.textLabel setText:@"Content from /r/CFBUploads"];
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        } else if (indexPath.row == 2) {
            [cell.textLabel setText:@"App Icon from /r/CFB"];
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        } else {
            [cell.textLabel setText:@"Developer Website"];
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        
        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            SUBLicenseViewController *licensesViewController = [[SUBLicenseViewController alloc] init];
            [self.navigationController pushViewController:licensesViewController animated:YES];
        }
    } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Do you want to open this link in Safari?" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if (indexPath.row == 0) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://icons8.com/"]];
                } else if (indexPath.row == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://reddit.com/r/cfbuploads"]];
                } else if (indexPath.row == 2) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://reddit.com/r/cfb"]];
                } else {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://akeaswaran.me/"]];
                }
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        
    }
}

@end
