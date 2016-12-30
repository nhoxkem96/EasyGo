//
//  UserInfo.h
//  Gogo
//
//  Created by Thuong on 9/18/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"
@interface UserInfo :MTLModel <MTLJSONSerializing>
@property (strong,nonatomic) NSString *iD;
@property (strong,nonatomic) NSString *access_token;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *avatar;
@property (strong,nonatomic) NSString *email;
@end
