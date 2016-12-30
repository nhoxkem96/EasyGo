//
//  SearchTableViewCell.m
//  Gogo
//
//  Created by Thuong on 9/24/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "SearchTableViewCell.h"
#import "Utils.h"
@implementation SearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_lblTitle setFont: [_lblTitle.font fontWithSize:[Utils fontSizeNormal]]];
    [_lblNumberLike setFont: [_lblNumberLike.font fontWithSize:[Utils fontSizeSmall]]];
    [_lblNumberComment setFont: [_lblNumberComment.font fontWithSize:[Utils fontSizeSmall]]];
    [_lblNamePost setFont: [_lblNamePost.font fontWithSize:[Utils fontSizeSmall]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
