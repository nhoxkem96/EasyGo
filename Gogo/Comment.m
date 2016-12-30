//
//  Comment.m
//  Gogo
//
//  Created by Thuong on 9/22/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "Comment.h"

@implementation Comment
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"commentID":@"id",
             @"authorID": @"author.id",
             @"authorName": @"author.name",
             @"authorAvatar": @"author.avatar",
             @"content": @"content",
             @"created": @"created"
             };
}
@end
