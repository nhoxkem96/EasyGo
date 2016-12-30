//
//  BottomCell.m
//  Gogo
//
//  Created by Thuong on 8/31/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "BottomCell.h"

@implementation BottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (void)layoutSubviews;
{
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    CALayer *TopBorder = [CALayer layer];
    TopBorder.frame = CGRectMake(15.0f, 0.0f, self.contentView.frame.size.width - 30.0f,0.5f);
    TopBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.contentView.layer addSublayer:TopBorder];
}

- (IBAction)clickBtnLike:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickBtnLike)]) {
        [self.delegate clickBtnLike];
    }
}
- (IBAction)clickBtnComment:(id)sender {
}

- (IBAction)clickBtnShare:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickBtnShare)]) {
        [self.delegate clickBtnShare];
    }
}

- (IBAction)clickBtnReport:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickBtnReport)]) {
        [self.delegate clickBtnReport];
    }
}
@end
