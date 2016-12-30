//
//  Validation.h
//  BaseProject
//
//  Created by sondv on 8/5/15.
//  Copyright (c) 2015 DaoVanSon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Validation : NSObject

+ (BOOL)validateStringNotNull:(NSString *)string;

+ (BOOL)validateEmail:(NSString*)email;

+ (BOOL)validateUserName:(NSString *)userName;

+ (BOOL)validateUser:(NSString*)user isEqualConfirmUser:(NSString *)confirmUser;

+ (BOOL)validatePassword:(NSString*)password isEqualConfirmPassword:(NSString *)confirmPassword;

@end
