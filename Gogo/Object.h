//
//  Object.h
//  Gogo
//
//  Created by Thuong on 9/15/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"
@interface Object : MTLModel <MTLJSONSerializing>
@property NSInteger code;
@property NSString *message;
@property NSArray *result;
@end
