//
//  LoginViewController.m
//
//  Created by Anass Bouassaba on 29/01/15.
//  Copyright (c) 2015 Anass Bouassaba. All rights reserved.
//

#import "LoginViewController.h"
#import "MasterViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Login";
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    logoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:logoImageView];
    
    _fbLoginBtn = [self createFbLoginButton];
    _fbLoginBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_fbLoginBtn];
    
    _chooseAlbumBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _chooseAlbumBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_chooseAlbumBtn setTitle:@"Show my Albums !" forState:UIControlStateNormal];
    [_chooseAlbumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _chooseAlbumBtn.backgroundColor = [UIColor orangeColor];
    [_chooseAlbumBtn addTarget:self action:@selector(openChooseAlbumViewController) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_chooseAlbumBtn];

    NSDictionary *viewsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        _fbLoginBtn, @"_fbLoginBtn",
                                        _chooseAlbumBtn, @"_chooseAlbumBtn",
                                        logoImageView, @"logoImageView", nil];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_chooseAlbumBtn(_fbLoginBtn)]-10-[_fbLoginBtn]-20-|" options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_fbLoginBtn]-20-|" options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_chooseAlbumBtn]-20-|" options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_chooseAlbumBtn]" options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[logoImageView]-20-|" options:0 metrics:nil views:viewsDictionary]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:logoImageView
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1 constant:-50]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openChooseAlbumViewController
{
    if (FBSession.activeSession.isOpen) {
        MasterViewController *masterViewController = [[MasterViewController alloc] init];
        [self.navigationController pushViewController:masterViewController animated:YES];
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"You have to login with Facebook" message:@"You cannot see and process your album photos before you login into your Facebook account" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    //MasterViewController *masterViewController = [[MasterViewController alloc] init];
    //[self.navigationController pushViewController:masterViewController animated:NO];
}

- (UIView*)createFbLoginButton
{
    // Create Login View so that the app will be granted "status_update" permission.
    FBLoginView *btn = [[FBLoginView alloc] initWithReadPermissions:[NSArray arrayWithObjects:@"user_about_me", @"user_activities", @"user_photos", @"publish_actions", nil]];
    
    btn.frame = CGRectOffset(btn.frame, 5, 100);
#ifdef __IPHONE_7_0
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        btn.frame = CGRectOffset(btn.frame, 5, 25);
    }
#endif
#endif
#endif
    btn.delegate = self;
    
    return btn;
}

@end
