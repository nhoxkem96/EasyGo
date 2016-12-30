//
//  LocationPost.h
//  Gogo
//
//  Created by Thuong on 10/28/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonModel.h"
@protocol LocationPost;
@interface LocationPost : JSONModel
@property NSString *name;
@property float lat;
@property float lon;
@end
