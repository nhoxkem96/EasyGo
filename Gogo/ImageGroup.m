//
//  ImageGroup.m
//  Gogo
//
//  Created by Thuong on 9/15/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "ImageGroup.h"

@implementation ImageGroup
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"title": @"title",
             @"photos": @"photos",
             };
}
@end
