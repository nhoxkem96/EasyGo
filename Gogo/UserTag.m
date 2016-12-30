//
//  UserTag.m
//  Gogo
//
//  Created by Thuong on 11/16/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "UserTag.h"

@implementation UserTag
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"iD": @"id",
             @"avatar": @"avatar",
             @"name":@"name"
             };
}
@end
