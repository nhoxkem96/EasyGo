//
//  Category.m
//  Gogo
//
//  Created by Thuong on 10/9/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "Category.h"

@implementation Category
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"category_Id": @"id",
             @"name": @"name"
             };
}
@end
