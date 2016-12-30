//
//  TextViewContent.m
//  Gogo
//
//  Created by Thuong on 9/14/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "TextViewContent.h"
#import "Utils.h"
@implementation TextViewContent

- (void)awakeFromNib {
    [super awakeFromNib];
    _txtContent.delegate = self;
    _txtContent.textContainer.lineBreakMode = NSLineBreakByCharWrapping;
    _txtContent.textContainerInset = UIEdgeInsetsZero;
    [self.txtContent sizeToFit];
    [_txtContent setFont: [_txtContent.font fontWithSize:[Utils fontSizeBig]]];
}
-(void)textViewDidChange:(UITextView *)textView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(txtViewDidChange:)]) {
        [self.delegate txtViewDidChange:self];
        
    }
    NSLog(@"fuck");
    self.content = textView.text;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    UIView *containerView = [[[NSBundle mainBundle] loadNibNamed:@"PostView" owner:self options:nil] lastObject];
    textView.inputAccessoryView = containerView;
    return YES;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
