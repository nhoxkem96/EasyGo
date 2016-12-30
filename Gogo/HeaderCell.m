//
//  HeaderCell.m
//  Demo
//
//  Created by Trung Đức on 8/27/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import "HeaderCell.h"
#import "Utils.h"
@implementation HeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_lblUserName setFont: [_lblUserName.font fontWithSize:[Utils fontSizeBig]]];
    [_lblAddress setFont: [_lblAddress.font fontWithSize:[Utils fontSizeSmall]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)clickBtnFollow:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickBtnFollow)]) {
        [self.delegate clickBtnFollow];
    }
}

- (void)displayUser:(NSString *)userName image:(NSString *)imageName address:(NSString *)address followCount:(NSString *)followCount;
{
    self.imvUser.image = [UIImage imageNamed:imageName];
    self.lblUserName.text = userName;
    self.lblAddress.text = address;
    
}

- (void)layoutSubviews;
{
    [super layoutSubviews];
    [self.imvUser layoutIfNeeded];
    
    self.imvUser.layer.cornerRadius = self.imvUser.frame.size.height / 2;
    self.imvUser.layer.masksToBounds = YES;
}


@end
