//
//  PhotosViewController.m
//
//  Created by Anass Bouassaba on 29/01/15.
//  Copyright (c) 2015 Anass Bouassaba. All rights reserved.
//

#import "PhotosViewController.h"
#import "DetailViewController.h"
#import "ImageHelper.h"
#import "UXHelper.h"

@implementation PhotosViewController

#pragma mark - Managing the detail item

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = [self.albumData objectForKey:@"name"];
    self.activityIndicator = [UXHelper centeredActivityIndicatorViewWithParentView:self.view];
    [self.activityIndicator startAnimating];
    
    [self loadPhotos];
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
    return _photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIndentifier = @"PhotoCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
    }
    
    NSDictionary *photoData = [_photos objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [photoData objectForKey:@"name"];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageView.image = [ImageHelper imageWithImage:[UIImage imageWithData:[photoData objectForKey:@"small_image_data"]] scaledToSize:CGSizeMake(44.0, 44.0)];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    detailViewController.albumData = _albumData;
    detailViewController.photoData = [_photos objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark - Logic

- (void)loadPhotos
{
    NSString *requestString = [NSString stringWithFormat:@"%@/photos", [self.albumData objectForKey:@"album_id"]];
    
    [FBRequestConnection startWithGraphPath:requestString parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            _photos = [[NSMutableArray alloc] init];
            NSArray *data = [result objectForKey:@"data"];
            for (int i = 0; i < data.count; i++) {
                NSDictionary *photo = [data objectAtIndex:i];
                
                NSMutableDictionary *photoData = [[NSMutableDictionary alloc] init];
                NSString *name = [photo objectForKey:@"name"] ? [photo objectForKey:@"name"] : [photo objectForKey:@"id"];
                
                [photoData setObject:[photo objectForKey:@"id"] forKey:@"id"];
                [photoData setObject:name forKey:@"name"];
                [photoData setObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[photo objectForKey:@"picture"]]] forKey:@"small_image_data"];
                [photoData setObject:[photo objectForKey:@"source"] forKey:@"large_image_url"];
                
                [_photos addObject:photoData];
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
