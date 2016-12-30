//
//  CommentCell.m
//  Gogo
//
//  Created by Thuong on 9/22/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "CommentCell.h"
#import "Utils.h"
@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_lblCommentName setFont: [_lblCommentName.font fontWithSize:[Utils fontSizeNormal]]];
    [_lblCommentTime setFont: [_lblCommentTime.font fontWithSize:[Utils fontSizeSmall]]];
    [_lblCommentContent setFont: [_lblCommentContent.font fontWithSize:[Utils fontSizeNormal]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews;
{
    [super layoutSubviews];
    [self.imgCommentAvatar layoutIfNeeded];
    
    self.imgCommentAvatar.layer.cornerRadius = self.imgCommentAvatar.frame.size.height / 2;
    self.imgCommentAvatar.layer.masksToBounds = YES;
}
@end
