//
//  Classfieds.m
//  Gogo
//
//  Created by Thuong on 10/20/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "Classfieds.h"

@implementation Classfieds
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"authorID": @"author.id",
             @"authorName": @"author.name",
             @"authorAvatar": @"author.avatar",
             @"title": @"title",
             @"content":@"content",
             @"location":@"location",
             @"created":@"created"
             };
}
@end
