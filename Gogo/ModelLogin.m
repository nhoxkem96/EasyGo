//
//  ModelLogin.m
//  Gogo
//
//  Created by Thuong on 9/14/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "ModelLogin.h"

@implementation ModelLogin
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"iD": @"id",
             @"name": @"name",
             @"email": @"email",
             @"birthday": @"birthday",
             @"avatar": @"picture.data.url",
             @"loginToken": @"",
             };
}
@end
