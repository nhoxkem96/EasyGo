//
//  NotificationTableViewCell.m
//  Gogo
//
//  Created by Thuong on 8/28/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "NotificationTableViewCell.h"
#import "Utils.h"
#import "KIImagePager.h"
@implementation NotificationTableViewCell

- (void)awakeFromNib {
    _check = false;
    [super awakeFromNib];
    
    self.lblNotification.lineBreakMode = NSLineBreakByWordWrapping;
    self.lblNotification.numberOfLines = 0;
    

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews;

{
    [super layoutSubviews];
    [self.imgUserAvatar layoutIfNeeded];
    CALayer *botBorder = [CALayer layer];
    botBorder.frame = CGRectMake(15.0f, self.contentView.frame.size.height - 1, self.contentView.frame.size.width - 30,0.5f);
    botBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.contentView.layer addSublayer:botBorder];
    self.imgUserAvatar.layer.cornerRadius = self.imgUserAvatar.frame.size.height /2 ;
    self.imgUserAvatar.layer.masksToBounds = YES;
    [self.imgUserAvatar layoutIfNeeded];
}
- (IBAction)clickBtnCheck:(id)sender {
    _check = true;
}
@end
