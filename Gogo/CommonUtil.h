//
//  CommonUtil.h
//  BaseProject
//
//  Created by sondv on 8/5/15.
//  Copyright (c) 2015 DaoVanSon. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "UIAlertView+Blocks.h"

@interface CommonUtil : NSObject

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title;
//+ (void)showMessage:(NSString *)message withTitle:(NSString *)title withConfirmButton:(RIButtonItem *)confirm withCancelButton:(RIButtonItem*)cancel;
// Encode and decode Emoji
+ (NSString*)encodeTextWithEmoji:(NSString*)text;
+ (NSString*)decodeTextWithEmoji:(NSString*)text;

+ (BOOL)checkNetworkConnected;
//+ (CGSize)calculateSizeLabelWithText:(NSString*)text andMaxWidthView:(CGFloat)width andSizeText:(CGFloat)sizeText;
//+ (UIImage*)resizeImageBeforeUpload:(UIImage*)img;
+ (void)showMessage:(NSString *)message withTitle:(NSString *)title cancelTitle:(NSString *)cancelTitle;
+ (NSString *) getNameById:(int)Id inArr:(NSArray *)arr;
+ (NSString *) getIdByName:(NSString *)Name inArr:(NSArray *)arr;
+ (NSDictionary *) getDictByName:(NSString *)Name inArr:(NSArray *)arr;

@end
