//
//  SingleObject.m
//  Gogo
//
//  Created by Thuong on 9/18/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "SingleObject.h"

@implementation SingleObject
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"code": @"code",
             @"message": @"message",
             @"result": @"result",
             };
}
@end
