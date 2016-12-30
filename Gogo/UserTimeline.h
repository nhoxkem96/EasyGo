//
//  UserTimeline.h
//  Gogo
//
//  Created by Thuong on 9/18/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"
@interface UserTimeline :MTLModel <MTLJSONSerializing>
@property NSString *iD;
@property NSString *title;
@property NSString *authorID;
@property NSString *authorName;
@property NSString *authorAvatar;
@property NSArray *follows;
@property NSString *categoryID;
@property NSString *categoryName;
@property NSString *categoryDescription;
@property NSString *categoryIcon;
@property NSInteger number_likes;
@property NSInteger number_tag;
@property NSInteger number_comment;
@property NSArray *user_likes;
@property NSArray *image_groups;
@property NSNumber *created;
@property NSString *location;
@property NSNumber *lat;
@property NSNumber *lon;
@property BOOL is_like;
@end
