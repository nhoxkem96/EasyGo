//
//  ChangeNameView.m
//  Gogo
//
//  Created by Thuong on 11/12/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "ChangeNameView.h"
#import "Utils.h"
@implementation ChangeNameView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.tfName.delegate = self;
    [_tfName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_tfName setFont: [_tfName.font fontWithSize:[Utils fontSizeBig]]];
}
-(void)textFieldDidChange:(UITextField *)theTextField{
    [[NSUserDefaults standardUserDefaults] setObject:theTextField.text forKey:@"nameToChange"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
