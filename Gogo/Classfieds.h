//
//  Classfieds.h
//  Gogo
//
//  Created by Thuong on 10/20/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"
@interface Classfieds : MTLModel <MTLJSONSerializing>
@property NSString *authorID;
@property NSString *authorName;
@property NSString *authorAvatar;
@property NSString *title;
@property NSString *content;
@property NSString *location;
@property id created;
@end
