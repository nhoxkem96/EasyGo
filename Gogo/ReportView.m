//
//  ReportView.m
//  Gogo
//
//  Created by Thuong on 10/30/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "ReportView.h"
#import "Utils.h"
@implementation ReportView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.txtContent.delegate = self;
    [_txtContent setFont: [_txtContent.font fontWithSize:[Utils fontSizeBig]]];
    [_btnDongY.titleLabel setFont: [_btnDongY.titleLabel.font fontWithSize:[Utils fontSizeBig]]];
    [_btnHuy.titleLabel setFont: [_btnHuy.titleLabel.font fontWithSize:[Utils fontSizeBig]]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Cho chúng tôi biết lí do?"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView{
        if ([textView.text isEqualToString:@""]) {
            textView.text = @"Cho chúng tôi biết lí do?";
            textView.textColor = [UIColor lightGrayColor];
        }
}
- (IBAction)clickBtnDongY:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickDongY:)]) {
        [self.delegate clickDongY:self.txtContent.text];
    }
}

- (IBAction)clickBtnHuyBo:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickHuy)]) {
        [self.delegate clickHuy];
    }
}
@end
