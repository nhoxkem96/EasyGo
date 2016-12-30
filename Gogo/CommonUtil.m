//
//  CommonUtil.m
//  BaseProject
//
//  Created by sondv on 8/5/15.
//  Copyright (c) 2015 DaoVanSon. All rights reserved.
//

#import "CommonUtil.h"
//#import "Reachability.h"
#import "UIImage+Resize.h"
//#import "BConstant.h"
#import "Utils.h"

@implementation CommonUtil
/*
+ (void)showMessage:(NSString *)message withTitle:(NSString *)title {
    [self showMessage:message withTitle:title withConfirmButton:nil withCancelButton:[RIButtonItem itemWithLabel:@"OK"]];
}

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title cancelTitle:(NSString *)cancelTitle;
{
    [self showMessage:message withTitle:title withConfirmButton:nil withCancelButton:[RIButtonItem itemWithLabel:cancelTitle]];
}

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title withConfirmButton:(RIButtonItem *)confirm withCancelButton:(RIButtonItem*)cancel {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message cancelButtonItem:cancel otherButtonItems:confirm, nil];
    [alert show];
}
// Text co chua Emoji
+ (NSString*)encodeTextWithEmoji:(NSString*)text {
    NSData *data = [text dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *goodValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return goodValue;
}

+ (NSString*)decodeTextWithEmoji:(NSString*)text {
    if (text != nil) {
        NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
        NSString *goodValue = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
        return goodValue;
    }
    return @"";
}

+ (UIImage*)resizeImageBeforeUpload:(UIImage*)img {
    NSData *imgData = UIImageJPEGRepresentation(img, 1.0);
    if (imgData.length > gSizeImageMax) {
        img = [img resizeImage];
    }
    return img;
}

+ (BOOL)checkNetworkConnected {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        // [self showDialogNoNetworkConnection];
    }
    return networkStatus != NotReachable;
}
*/
+ (CGSize)calculateSizeLabelWithText:(NSString*)text andMaxWidthView:(CGFloat)width andSizeText:(CGFloat)sizeText {
    UIFont *font = [UIFont systemFontOfSize:sizeText];
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:(text != nil ? text : @"") attributes:@{NSFontAttributeName: font}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGSize size = rect.size;
    size.height = ceilf(size.height);
    size.width  = ceilf(size.width);
    return size;
}

+ (NSString *) getNameById:(int)Id inArr:(NSArray *)arr;
{
    for (NSDictionary *dic in arr) {
        if ([dic[@"Id"] intValue] == Id) {
            return dic[@"Name"];
        }
    }
    return nil;
}

+ (NSString *) getIdByName:(NSString *)Name inArr:(NSArray *)arr;
{
    for (NSDictionary *dic in arr) {
        if ([Name isEqualToString:dic[@"Name"]]) {
            return SAFE_STR(dic[@"Id"]);
        }
    }
    return nil;
}

+ (NSDictionary *) getDictByName:(NSString *)Name inArr:(NSArray *)arr;
{
    for (NSDictionary *dic in arr) {
        if ([Name isEqualToString:dic[@"Name"]]) {
            return dic;
        }
    }
    return nil;
}

@end
