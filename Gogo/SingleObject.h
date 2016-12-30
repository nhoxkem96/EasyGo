//
//  SingleObject.h
//  Gogo
//
//  Created by Thuong on 9/18/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"
@interface SingleObject : MTLModel <MTLJSONSerializing>
@property NSInteger code;
@property NSString *message;
@property id result;
@end