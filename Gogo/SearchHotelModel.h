//
//  SearchHotelModel.h
//  Gogo
//
//  Created by Thuong on 12/29/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"
@interface SearchHotelModel : MTLModel <MTLJSONSerializing>
@property NSString *image;
@property NSString *name;
@property NSString *price;
@property NSString *address;
@end
