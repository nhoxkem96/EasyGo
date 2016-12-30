//
//  SearchFlightTableViewCell.m
//  Gogo
//
//  Created by Thuong on 12/30/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "SearchFlightTableViewCell.h"
#import "Utils.h"
@implementation SearchFlightTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_lblFlightName setFont: [_lblFlightName.font fontWithSize:[Utils fontSizeNormal]]];
    [_lblFlightTime setFont: [_lblFlightTime.font fontWithSize:[Utils fontSizeSmall]]];
    [_lblFlightPrice setFont: [_lblFlightPrice.font fontWithSize:[Utils fontSizeSmall]]];
    self.vFlightContent.layer.borderWidth = 1.0f;
    self.vFlightContent.layer.borderColor=[[UIColor lightGrayColor] CGColor];
}
-(void)layoutSubviews{
    self.vFlightContent.layer.borderWidth = 1.0f;
    self.vFlightContent.layer.borderColor=[[UIColor lightGrayColor] CGColor];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
