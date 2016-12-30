//
//  UserTimeline.m
//  Gogo
//
//  Created by Thuong on 9/18/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "UserTimeline.h"

@implementation UserTimeline
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"iD": @"id",
             @"title": @"title",
             @"authorID": @"author.id",
             @"authorName": @"author.name",
             @"authorAvatar": @"author.avatar",
             @"follows": @"author.follows",
             @"categoryID": @"category._id",
             @"categoryName": @"category.name",
             @"categoryDescription": @"category.description",
             @"categoryIcon": @"category.icon",
             @"number_likes": @"number_likes",
             @"number_comment": @"number_comment",
             @"number_tag": @"number_tag",
             @"user_likes": @"user_likes",
             @"created": @"created",
             @"location": @"location.name",
             @"image_groups":@"image_groups",
             @"lat":@"location.lat",
             @"lon":@"location.lon",
             @"is_like":@"is_like"
             };
}
@end
