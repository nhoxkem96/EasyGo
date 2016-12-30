//
//  FlightModel.h
//  Gogo
//
//  Created by Thuong on 12/30/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"
@interface FlightModel : MTLModel <MTLJSONSerializing>
@property NSString *airlines;
@property NSString *fromPlace;
@property NSString *toPlace;
@property NSString *totalPrice;
@property NSString *departTime;
@property NSString *landingTime;
@end
