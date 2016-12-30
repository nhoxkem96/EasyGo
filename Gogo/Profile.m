//
//  Profile.m
//  Gogo
//
//  Created by Thuong on 9/18/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "Profile.h"

@implementation Profile
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"name": @"result.name",
             @"avatar": @"result.avatar",
             @"banner": @"result.banner",
             @"number_following": @"result.number_following",
             @"number_follower": @"result.number_follower",
             @"is_follow":@"result.is_follow"
             };
}
@end
