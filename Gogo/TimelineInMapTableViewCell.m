//
//  TimelineInMapTableViewCell.m
//  Gogo
//
//  Created by Thuong on 11/5/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "TimelineInMapTableViewCell.h"

@implementation TimelineInMapTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization codes
    self.vContent.layer.cornerRadius = 5;
}
- (void)layoutSubviews;
{
    [super layoutSubviews];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
