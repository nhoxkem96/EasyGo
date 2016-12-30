//
//  MyURL.h
//  Gogo
//
//  Created by Thuong on 9/17/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"
@interface MyURL : MTLModel <MTLJSONSerializing>
@property NSString *path;
@property NSInteger code;
@end
