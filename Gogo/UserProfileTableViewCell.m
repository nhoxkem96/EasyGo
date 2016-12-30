//
//  UserProfileTableViewCell.m
//  Gogo
//
//  Created by Thuong on 9/18/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "UserProfileTableViewCell.h"
#import "Utils.h"
@implementation UserProfileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.userInteractionEnabled = NO;
    UITapGestureRecognizer *tapGestureRecognizerContent = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentTapped)];
    tapGestureRecognizerContent.numberOfTapsRequired = 1;
    [_lblContent addGestureRecognizer:tapGestureRecognizerContent];
    _lblContent.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureRecognizerTitle = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleTapped)];
    tapGestureRecognizerTitle.numberOfTapsRequired = 1;
    [_lblTitle addGestureRecognizer:tapGestureRecognizerContent];
    _lblTitle.userInteractionEnabled = YES;
    [self setFont];
    self.imgAvatar.layer.borderWidth = 1.0f;
    self.imgAvatar.layer.borderColor = [UIColor whiteColor].CGColor;

}
-(void)setFont{
    
    [_lblLocation setFont: [_lblLocation.font fontWithSize:[Utils fontSizeSmall]]];
    [_lblTime setFont: [_lblTime.font fontWithSize:[Utils fontSizeSmall]]];
    [_lblUsername setFont: [_lblUsername.font fontWithSize:[Utils fontSizeBig]]];
    [_lblTitle setFont: [_lblTitle.font fontWithSize:[Utils fontSizeNormal]]];
    [_lblContent setFont: [_lblContent.font fontWithSize:[Utils fontSizeNormal]]];
    [_lblNumberLike setFont: [_lblNumberLike.font fontWithSize:[Utils fontSizeSmall]]];
    [_lblNumberComment setFont: [_lblNumberComment.font fontWithSize:[Utils fontSizeSmall]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews;
{
    [super layoutSubviews];
    [self.imgAvatar layoutIfNeeded];
    [self.vBot layoutIfNeeded];
    CALayer *TopBorder = [CALayer layer];
    TopBorder.frame = CGRectMake(15.0f, 0.0f, self.vBot.frame.size.width - 30,0.5f);
    TopBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.vBot.layer addSublayer:TopBorder];
    
    self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.height / 2;
    self.imgAvatar.layer.masksToBounds = YES;
}
- (IBAction)clickBtnLike:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickBtnLike:id:)]) {
        [self.delegate clickBtnLike:_cellIndex id:sender];
    }
}
- (IBAction)clickBtnComment:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickBtnComment:)]) {
        [self.delegate clickBtnComment:_cellIndex];
    }
}
-(void)contentTapped{
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentTapped:)]) {
        [self.delegate contentTapped:_cellIndex];
        
    }
}
-(void)titleTapped{
    if (self.delegate && [self.delegate respondsToSelector:@selector(titleTapped:)]) {
        [self.delegate titleTapped:_cellIndex];
        
    }
}
- (IBAction)clickBtnShare:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickBtnShare:)]) {
        [self.delegate clickBtnShare:_cellIndex];
    }
}

- (IBAction)clickBtnReport:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickBtnReport:)]) {
        [self.delegate clickBtnReport:_cellIndex];
    }
}
@end
