//
//  PostModel.h
//  Gogo
//
//  Created by Thuong on 9/21/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "Image_Groups_Post.h"
#import "ImageGroup.h"
#import "LocationPost.h"
@interface PostModel : JSONModel
@property NSString *title;
@property NSString * category;
@property LocationPost *location;
@property NSArray *user_tagged;
@property(nonatomic, strong) NSMutableArray<Image_Groups_Post> *image_groups;
@end
