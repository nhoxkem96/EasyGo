//
//  Validation.m
//  BaseProject
//
//  Created by sondv on 8/5/15.
//  Copyright (c) 2015 DaoVanSon. All rights reserved.
//

#import "Validation.h"

@implementation Validation

+ (BOOL)validateStringNotNull:(NSString *)string {
    if (string == (id)[NSNull null] || string.length == 0) {
        // Not null
        return NO;
    }
    else return YES;
}

+ (BOOL)validateEmail:(NSString*)email {
	email = [email lowercaseString];
    NSString *emailRegEx =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSPredicate *regExPredicate =
    [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    return [regExPredicate evaluateWithObject:email];
}

+ (BOOL)validateUsername:(NSString *)userName {
    if (!userName) {
        return NO;
    }
    else return YES;
}

+ (BOOL)validateUser:(NSString*)user isEqualConfirmUser:(NSString *)confirmUser {
    if (![user isEqualToString:confirmUser]) {
        return NO;
    }
    else return YES;
}

+ (BOOL)validatePassword:(NSString*)password isEqualConfirmPassword:(NSString *)confirmPassword {
    if (![password isEqualToString:confirmPassword]) {
        return NO;
    }
    else return YES;
}

@end
