//
//  ImageHelper.h
//
//  Created by Anass Bouassaba on 20/02/15.
//  Copyright (c) 2015 Anass Bouassaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageHelper : NSObject

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width;

@end
