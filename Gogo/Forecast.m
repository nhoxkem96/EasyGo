//
//  Forecast.m
//  Gogo
//
//  Created by HungTran on 11/24/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "Forecast.h"

@implementation Forecast
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"code": @"code",
             @"date": @"date",
             @"high": @"high",
             @"low":@"low",
             @"text": @"text",
             @"day": @"day"
             };
}
@end
