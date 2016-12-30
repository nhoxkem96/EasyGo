//
//  SearchHotelTableViewCell.m
//  Gogo
//
//  Created by Thuong on 12/29/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "SearchHotelTableViewCell.h"
#import "Utils.h"
@implementation SearchHotelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_lblHotelName setFont: [_lblHotelName.font fontWithSize:[Utils fontSizeBig]]];
    [_lblHotelPrice setFont: [_lblHotelPrice.font fontWithSize:[Utils fontSizeSmall]]];
    [_lblHotelAddress setFont: [_lblHotelAddress.font fontWithSize:[Utils fontSizeSmall]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
