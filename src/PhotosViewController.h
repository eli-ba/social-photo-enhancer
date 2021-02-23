//
//  DetailViewController.h
//
//  Created by Anass Bouassaba on 29/01/15.
//  Copyright (c) 2015 Anass Bouassaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface PhotosViewController : UITableViewController

@property NSDictionary *albumData;
@property (readonly) NSMutableArray *photos;
@property UIActivityIndicatorView *activityIndicator;

@end

