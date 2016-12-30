//
//  TextCell.m
//  Demo
//
//  Created by Trung Đức on 8/27/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import "TextCell.h"
#import "Utils.h"
@implementation TextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_lblTitle setFont: [_lblTitle.font fontWithSize:[Utils fontSizeNormal]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)displayString:(NSString *)title;
{
    self.lblTitle.text = title;
}

@end
