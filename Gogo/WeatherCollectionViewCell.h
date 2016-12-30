//
//  WeatherCollectionViewCell.h
//  Gogo
//
//  Created by HungTran on 11/24/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblDay;
@property (weak, nonatomic) IBOutlet UILabel *iconWeather;
@property (weak, nonatomic) IBOutlet UILabel *lblHighTemperature;
@property (weak, nonatomic) IBOutlet UILabel *lblLowTemperature;

@end
