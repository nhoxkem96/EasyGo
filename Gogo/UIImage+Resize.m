//
//  UIImage+Resize.m
//  GTravel
//
//  Created by sondv on 6/29/15.
//  Copyright (c) 2015 DaoVanSon. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

- (UIImage*)resizeImage {
    CGFloat scale = [[UIScreen mainScreen]scale];
    CGFloat ratio = self.size.width / 320;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, self.size.height / ratio), NO, scale);
    [self drawInRect:CGRectMake(0, 0 , 320, self.size.height / ratio)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
