//
//  SearchModel.m
//  Gogo
//
//  Created by Thuong on 9/24/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "SearchModel.h"

@implementation SearchModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"postID": @"id",
             @"avatar": @"image",
             @"author_name": @"author_name",
             @"title":@"title",
             @"numberComment": @"number_comment",
             @"numberLike": @"number_like"
             };
}
@end
