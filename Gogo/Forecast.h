//
//  Forecast.h
//  Gogo
//
//  Created by HungTran on 11/24/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"
@interface Forecast :  MTLModel<MTLJSONSerializing>
@property NSNumber *code;
@property NSString *date;
@property NSString *day;
@property NSString *high;
@property NSString *low;
@property NSString *text;
@end
