//
//  Profile.h
//  Gogo
//
//  Created by Thuong on 9/18/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"
@interface Profile :MTLModel <MTLJSONSerializing>
@property NSString *name;
@property NSString *avatar;
@property NSString *banner;
@property NSInteger number_following;
@property NSInteger number_follower;
@property BOOL is_follow;
@end
