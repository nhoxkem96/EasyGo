//
//  MyURL.m
//  Gogo
//
//  Created by Thuong on 9/17/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "MyURL.h"

@implementation MyURL
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"path": @"path",
             @"code": @"code"
             };
}
@end
