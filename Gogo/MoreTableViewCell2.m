//
//  MoreTableViewCell2.m
//  Gogo
//
//  Created by Thuong on 8/28/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "MoreTableViewCell2.h"
#import "Utils.h"
@implementation MoreTableViewCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _lblTitle.lineBreakMode = NSLineBreakByCharWrapping;
    _lblTitle.numberOfLines = 0;
    _lblContent.lineBreakMode = NSLineBreakByCharWrapping;
    _lblContent.numberOfLines = 0;
    
    [_lblTitle setFont: [_lblTitle.font fontWithSize:[Utils fontSizeNormal]]];
    [_lblContent setFont: [_lblContent.font fontWithSize:[Utils fontSizeNormal]]];
    [_lblLocation setFont: [_lblLocation.font fontWithSize:[Utils fontSizeSmall]]];
    [_lblPoster setFont: [_lblPoster.font fontWithSize:[Utils fontSizeSmall]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
