//
//  Category.h
//  Gogo
//
//  Created by Thuong on 10/9/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"
@interface Category :MTLModel <MTLJSONSerializing>
@property id category_Id;
@property NSString *name;
@end
