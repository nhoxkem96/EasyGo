//
//  UserTagTableViewCell.m
//  Gogo
//
//  Created by Thuong on 11/16/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "UserTagTableViewCell.h"
#import "Utils.h"
@implementation UserTagTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_lblUsername setFont: [_lblUsername.font fontWithSize:[Utils fontSizeNormal]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
