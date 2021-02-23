//
//  UXHelper.m
//
//  Created by Anass Bouassaba on 20/02/15.
//  Copyright (c) 2015 Anass Bouassaba. All rights reserved.
//

#import "UXHelper.h"

@implementation UXHelper

+ (UIActivityIndicatorView*)centeredActivityIndicatorViewWithParentView:(UIView*)parantView
{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [parantView addSubview:activityIndicator];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:activityIndicator
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:parantView
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1
                                  constant:0];
    [parantView addConstraint:heightConstraint];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:activityIndicator
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:parantView
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1
                                  constant:0];
    [parantView addConstraint:widthConstraint];
    
    return activityIndicator;
}

@end
