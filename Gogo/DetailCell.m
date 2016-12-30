//
//  DetailCell.m
//  Demo
//
//  Created by Trung Đức on 8/27/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import "DetailCell.h"
#import "Utils.h"
@implementation DetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_lblNumberComment setFont: [_lblNumberComment.font fontWithSize:[Utils fontSizeSmall]]];
    [_lblNumberLike setFont: [_lblNumberLike.font fontWithSize:[Utils fontSizeSmall]]];
    [_lblTime setFont: [_lblTime.font fontWithSize:[Utils fontSizeSmall]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
