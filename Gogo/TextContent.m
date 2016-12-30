//
//  TextContent.m
//  Gogo
//
//  Created by Thuong on 9/18/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "TextContent.h"
#import "Utils.h"
@implementation TextContent

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_lblContent setFont: [_lblContent.font fontWithSize:[Utils fontSizeNormal]]];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.lblContent.preferredMaxLayoutWidth = 283;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)displayString:(NSString *)content;
{
    self.lblContent.text = content;
}

@end
