//
//  NotificationModel.h
//  Gogo
//
//  Created by Thuong on 9/25/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"
@interface NotificationModel : MTLModel <MTLJSONSerializing>
@property NSString *iD;
@property NSString *content;
@property NSString *user_id;
@property NSString *post_id;
@property NSString *image;
@property NSNumber *created;
@property NSInteger status;
@property NSString *comment_id;
@end
