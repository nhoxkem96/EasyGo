//
//  SearchHotelModel.m
//  Gogo
//
//  Created by Thuong on 12/29/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "SearchHotelModel.h"

@implementation SearchHotelModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"image": @"image",
             @"name": @"name",
             @"address": @"address",
             @"price": @"price"
             };
}
@end
