//
//  LocationPost.m
//  Gogo
//
//  Created by Thuong on 10/28/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "LocationPost.h"

@implementation LocationPost
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"name": @"name",
             @"lon": @"lon",
             @"lat": @"lat",
             };
}
@end
