//
//  DetailViewController.h
//
//  Created by Anass Bouassaba on 20/02/15.
//  Copyright (c) 2015 Anass Bouassaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AdobeCreativeSDKImage/AdobeCreativeSDKImage.h>

@interface DetailViewController : UIViewController <AdobeUXImageEditorViewControllerDelegate>

@property NSDictionary *albumData;
@property NSDictionary *photoData;
@property (readonly) UIImageView *imageView;
@property (readonly) UIActivityIndicatorView *activityIndicator;
@property (readonly) AdobeUXImageEditorViewController *editorController;
@property (readonly) UIActivityIndicatorView *indicator;
@property (readonly) BOOL uploading;

@end
