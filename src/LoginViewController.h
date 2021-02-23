//
//  LoginViewController.h
//
//  Created by Anass Bouassaba on 29/01/15.
//  Copyright (c) 2015 Anass Bouassaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController : UIViewController <FBLoginViewDelegate>

@property (readonly) UIView *fbLoginBtn;
@property (readonly) UIButton *chooseAlbumBtn;

- (void)openChooseAlbumViewController;

@end
