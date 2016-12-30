//
//  WeatherCollectionViewCell.m
//  Gogo
//
//  Created by HungTran on 11/24/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "WeatherCollectionViewCell.h"
#import "Utils.h"
@implementation WeatherCollectionViewCell
-(void)awakeFromNib{
    [super awakeFromNib];
    [self setFont];
}
-(void)setFont{
    [_lblDay setFont: [_lblDay.font fontWithSize:[Utils fontSizeBig]]];
    [_lblLowTemperature setFont: [_lblLowTemperature.font fontWithSize:[Utils fontSizeBig]]];
    [_lblHighTemperature setFont: [_lblHighTemperature.font fontWithSize:[Utils fontSizeBig]]];
    [_iconWeather setFont:[UIFont fontWithName:@"WeatherIcons-Regular" size:[Utils fontSizeBig]*2]];

}

@end
