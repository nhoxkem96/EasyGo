//
//  FollowModel.h
//  Gogo
//
//  Created by Thuong on 11/3/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"
@interface FollowModel :MTLModel <MTLJSONSerializing>
@property NSString *iD;
@property NSString *avatar;
@property NSString *name;
@end
