//
//  DetailViewController.m
//
//  Created by Anass Bouassaba on 20/02/15.
//  Copyright (c) 2015 Anass Bouassaba. All rights reserved.
//

#import "DetailViewController.h"
#import "UXHelper.h"
#import <FacebookSDK/FacebookSDK.h>

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [self.photoData objectForKey:@"name"];
    
    _activityIndicator = [UXHelper centeredActivityIndicatorViewWithParentView:self.view];
    [_activityIndicator startAnimating];
    
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor blackColor];
    
    _imageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imageView];
    
    __block NSURL *imageUrl = [NSURL URLWithString:[self.photoData objectForKey:@"large_image_url"]];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSData * imageData = [NSData dataWithContentsOfURL:imageUrl];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicator stopAnimating];
            self.imageView.image = [UIImage imageWithData:imageData];
        });
    });
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Enhance!" style:UIBarButtonItemStylePlain target:self action:@selector(editImage)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    _uploading = NO;
}

- (void)editImage
{
    _editorController = [[AdobeUXImageEditorViewController alloc] initWithImage:self.imageView.image];
    [_editorController setDelegate:self];
    [self presentViewController:_editorController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - AdobeUXImageEditorViewControllerDelegate

- (void)photoEditor:(AdobeUXImageEditorViewController *)editor finishedWithImage:(UIImage *)image
{
    if (_uploading) return;
    _uploading = YES;
    
    __block UIAlertView *loadingAlertView = [[UIAlertView alloc] initWithTitle:@"Uploading to Facebook ..."
                                message:@"Please wait, your photo is being uploaded to Facebook in the same Album as the original one"
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:nil, nil];
    [loadingAlertView show];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *graphPath = [NSString stringWithFormat:@"%@/photos", [_albumData objectForKey:@"album_id"]];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys: image, @"picture", nil];
    FBRequest *imageUploadRequest = [FBRequest requestWithGraphPath:graphPath parameters:parameters HTTPMethod:@"POST"];
    
    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
    
    [connection addRequest:imageUploadRequest
         completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                 [self dismissViewControllerAnimated:YES completion:nil];
                 [loadingAlertView dismissWithClickedButtonIndex:0 animated:YES];
                 
                 if (!error) {
                     NSLog(@"Photo uploaded successfuly! %@",result);
                     
                     [[[UIAlertView alloc] initWithTitle:@"Photo Successfuly Uploaded"
                                                 message:@"Photo successfuly uploaded to your Facebook album"
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil, nil] show];
                 }
                 else {
                     NSLog(@"Photo uploaded failed :( %@",error.userInfo);
                     
                     [[[UIAlertView alloc] initWithTitle:@"Error"
                                                 message:@"An error occured while trying to upload your photo to Facebook"
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil, nil] show];
                 }
             });
             _uploading = NO;
         }];
    
    [connection start];
}

- (void)photoEditorCanceled:(AdobeUXImageEditorViewController *)editor
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
