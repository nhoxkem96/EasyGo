//
//  BotView.m
//  Gogo
//
//  Created by Thuong on 9/10/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "BotView.h"
#import "Utils.h"
@implementation BotView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.btnDangBaiViet.layer.cornerRadius = 5;
    [_btnDangBaiViet.titleLabel setFont: [_btnDangBaiViet.titleLabel.font fontWithSize:[Utils fontSizeBig]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickBtnDangBaiViet:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickBtnDangBaiViet)]) {
        [self.delegate clickBtnDangBaiViet];
    }
}
@end
