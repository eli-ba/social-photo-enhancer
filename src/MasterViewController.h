//
//  MasterViewController.h
//
//  Created by Anass Bouassaba on 29/01/15.
//  Copyright (c) 2015 Anass Bouassaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property DetailViewController *detailViewController;
@property UIActivityIndicatorView *activityIndicator;
@property (readonly) NSMutableArray *albums;

@end
