//
//  TopView.m
//  Gogo
//
//  Created by Thuong on 9/10/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "TopView.h"
#import "Utils.h"
@implementation TopView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_txtTitle setFont: [_txtTitle.font fontWithSize:[Utils fontSizeBig]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
