//
//  UserInfo.m
//  Gogo
//
//  Created by Thuong on 9/18/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"iD": @"id",
             @"access_token": @"access_token",
             @"avatar": @"avatar",
             @"name": @"name",
             @"email": @"email"
             };
}
@end
