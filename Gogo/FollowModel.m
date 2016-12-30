//
//  FollowModel.m
//  Gogo
//
//  Created by Thuong on 11/3/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "FollowModel.h"

@implementation FollowModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"iD": @"id",
             @"avatar": @"avatar",
             @"name":@"name"
             };
}
@end
