//
//  ImageGroup.h
//  Gogo
//
//  Created by Thuong on 9/15/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"
@interface ImageGroup :  MTLModel <MTLJSONSerializing>
@property NSString *title;
@property NSArray *photos;
@end
