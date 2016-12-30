//
//  Image_Groups_Post.h
//  Gogo
//
//  Created by Thuong on 9/21/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonModel.h"
@protocol Image_Groups_Post;
@interface Image_Groups_Post : JSONModel
@property NSString *title;
@property NSArray *photos;
@end
