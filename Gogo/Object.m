//
//  Object.m
//  Gogo
//
//  Created by Thuong on 9/15/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "Object.h"

@implementation Object
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"code": @"code",
             @"message": @"message",
             @"result": @"result",
             };
}
@end
