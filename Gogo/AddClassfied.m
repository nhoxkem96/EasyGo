//
//  AddClassfied.m
//  Gogo
//
//  Created by Thuong on 10/22/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "AddClassfied.h"
#import "Utils.h"
@implementation AddClassfied
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _btnDangtin.layer.borderWidth = 1;
    _btnDangtin.layer.borderColor = [[UIColor clearColor] CGColor];
    _btnDangtin.layer.cornerRadius = 5;
    _txtContent.delegate = self;
    _txtContent.layer.borderWidth = 0.5f;
    _txtContent.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _txtContent.layer.cornerRadius = 5;
    // add some sample data
    
    // bind yourTextField to DownPicker
    [_tfTitle setFont: [_tfTitle.font fontWithSize:[Utils fontSizeBig]]];
    [_tfLocation setFont: [_tfLocation.font fontWithSize:[Utils fontSizeBig]]];
    [_txtContent setFont: [_txtContent.font fontWithSize:[Utils fontSizeBig]]];
    [_btnDangtin.titleLabel setFont: [_btnDangtin.titleLabel.font fontWithSize:[Utils fontSizeBig]]];
    
    if ([_txtContent.text isEqualToString:@""]) {
        _txtContent.text = @"Nhập nội dung...";
        _txtContent.textColor = [UIColor lightGrayColor];
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"Nhập nội dung..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Nhập nội dung...";
        textView.textColor = [UIColor lightGrayColor];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)clickBtnDangtin:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickBtnDangtin:Content:Location:)]) {
        [self.delegate clickBtnDangtin:_tfTitle.text Content:_txtContent.text Location:_tfLocation.text];
    }
}
@end
