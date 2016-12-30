//
//  FlightModel.m
//  Gogo
//
//  Created by Thuong on 12/30/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "FlightModel.h"

@implementation FlightModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"airlines": @"result.AirlineCode",
             @"fromPlace": @"result.FromPlace",
             @"toPlace": @"result.ToPlace",
             @"totalPrice":@"result.TotalPrice",
             @"departTime": @"result.DepartTime",
             @"landingTime": @"result.LandingTime"
             };
}
@end
