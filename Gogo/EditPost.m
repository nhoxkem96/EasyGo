//
//  EditPost.m
//  Gogo
//
//  Created by Thuong on 11/6/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "EditPost.h"

@implementation EditPost

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)clickBtnSuaBaiViet:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickBtnEditPost)]) {
        [self.delegate clickBtnEditPost];
    }
}

- (IBAction)clickBtnXoaBaiViet:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickBtnDeletePost)]) {
        [self.delegate clickBtnDeletePost];
    }
}
- (IBAction)clickBtnHuy:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickBtnCancel)]) {
        [self.delegate clickBtnCancel];
    }
}
@end
