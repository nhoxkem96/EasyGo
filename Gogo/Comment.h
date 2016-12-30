//
//  Comment.h
//  Gogo
//
//  Created by Thuong on 9/22/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"
@interface Comment : MTLModel <MTLJSONSerializing>
@property NSString *commentID;
@property NSString *authorID;
@property NSString *authorName;
@property NSString *authorAvatar;
@property NSString *content;
@property NSNumber *created;
@end
