//
//  Timeline.h
//  Gogo
//
//  Created by Thuong on 9/15/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"
#import "ImageGroup.h"
#import "LocationPost.h"
@interface Timeline : MTLModel <MTLJSONSerializing>
@property (weak , nonatomic) NSString * name;
@property NSString *idPost;
@property NSString *title;
@property NSString *authorID;
@property NSString *authorName;
@property NSString *authorAvatar;
@property NSString *categoryID;
@property NSString *categoryName;
@property NSString *categoryDescription;
@property NSString *categoryLink;
@property NSInteger number_like;
@property NSInteger number_comment;
@property NSInteger number_tag;
@property NSNumber* time_created;
@property NSString *location;
@property NSArray *image_groups;
@property BOOL is_like;
@property BOOL is_follow;
@property NSNumber *number_follow;
@property float lat;
@property float lon;
@end
