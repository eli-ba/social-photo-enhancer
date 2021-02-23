//
//  MasterViewController.m
//
//  Created by Anass Bouassaba on 29/01/15.
//  Copyright (c) 2015 Anass Bouassaba. All rights reserved.
//

#import "MasterViewController.h"
#import "PhotosViewController.h"
#import "PhotoTableViewCell.h"
#import "ImageHelper.h"
#import "UXHelper.h"

@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"My Albums";
    self.activityIndicator = [UXHelper centeredActivityIndicatorViewWithParentView:self.view];
    [self.activityIndicator startAnimating];
    [self loadAlbums];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIndentifier = @"AlbumCell";
    
    PhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (cell == nil) {
        cell = [[PhotoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
    }

    NSDictionary *albumData = [_albums objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [albumData objectForKey:@"name"];
    cell.imageView.image = [ImageHelper imageWithImage:[UIImage imageNamed:@"album_photo_placeholder.png"] scaledToSize: CGSizeMake(44, 44)];
    
    [FBRequestConnection startWithGraphPath: [NSString stringWithFormat:@"/%@", [albumData objectForKey:@"cover_photo_id"]]
                                 parameters: [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"small", @"type", nil]
                                 HTTPMethod: @"GET"
                          completionHandler: ^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error) {
                                  NSURL *imageURL = [NSURL URLWithString:[result objectForKey:@"picture"]];
                                  NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                                  UIImage *image = [UIImage imageWithData:imageData];
                                  if (image) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          PhotoTableViewCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                                          if (updateCell)
                                              updateCell.imageView.image = [ImageHelper imageWithImage:image scaledToSize: CGSizeMake(44, 44)];
                                      });
                                  }
                              }
                          }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotosViewController *photosViewController = [[PhotosViewController alloc] init];
    photosViewController.albumData = [_albums objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:photosViewController animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark - Logic

- (void)loadAlbums
{
    [FBRequestConnection startWithGraphPath:@"me/albums" parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            _albums = [[NSMutableArray alloc] init];
            NSArray *data = [result objectForKey:@"data"];
            for (int i = 0; i < data.count; i++) {
                NSDictionary *album = [data objectAtIndex:i];
                
                NSMutableDictionary *albumData = [[NSMutableDictionary alloc] init];
                [albumData setValue:[album objectForKey:@"name"] forKey:@"name"];
                [albumData setValue:[album objectForKey:@"id"] forKey:@"album_id"];
                [albumData setValue:[album objectForKey:@"cover_photo"] forKey:@"cover_photo_id"];
                [_albums addObject:albumData];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.activityIndicator stopAnimating];
                [self.tableView reloadData];
            });
        }
        else {
            NSLog(@"Error: %@",error.userInfo);
        }
    }];
}

@end
