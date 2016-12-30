//
//  SearchModel.h
//  Gogo
//
//  Created by Thuong on 9/24/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"
@interface SearchModel : MTLModel <MTLJSONSerializing>
@property NSString *postID;
@property NSString *avatar;
@property NSString *author_name;
@property NSString *title;
@property NSNumber *numberComment;
@property NSNumber *numberLike;
@end
