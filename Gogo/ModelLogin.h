//
//  ModelLogin.h
//  Gogo
//
//  Created by Thuong on 9/14/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"
@interface ModelLogin : MTLModel <MTLJSONSerializing>
@property (weak , nonatomic) NSString * name;
@property (weak , nonatomic) NSString * email;
@property (weak , nonatomic) NSString * iD;
@property (weak , nonatomic) NSString * birthday;
@property (weak , nonatomic) NSString * avatar;
@property (weak , nonatomic) NSString * loginToken;
@end
