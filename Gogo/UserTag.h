//
//  UserTag.h
//  Gogo
//
//  Created by Thuong on 11/16/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"
@interface UserTag : MTLModel <MTLJSONSerializing>
@property NSString *iD;
@property NSString *avatar;
@property NSString *name;
@property BOOL check;
@end
