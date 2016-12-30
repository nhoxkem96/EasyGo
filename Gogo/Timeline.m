//
//  Timeline.m
//  Gogo
//
//  Created by Thuong on 9/15/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "Timeline.h"

@implementation Timeline
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"idPost": @"id",
             @"title": @"title",
             @"authorID": @"author.id",
             @"authorName": @"author.name",
             @"authorAvatar": @"author.avatar",
             @"categoryID": @"category._id",
             @"categoryName": @"category.name",
             @"categoryDescription": @"category.description",
             @"categoryLink": @"category.link",
             @"number_like": @"number_likes",
             @"number_comment": @"number_comment",
             @"number_tag": @"number_tag",
             @"number_follow":@"number_follow",
             @"time_created": @"created",
             @"location": @"location.name",
             @"image_groups":@"image_groups",
             @"is_like":@"is_like",
             @"is_follow":@"is_follow",
             @"lat":@"location.lat",
             @"lon":@"location.lon"
             };
}
@end
