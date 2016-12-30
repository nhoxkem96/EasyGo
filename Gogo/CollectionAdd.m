//
//  CollectionAdd.m
//  Gogo
//
//  Created by Thuong on 9/10/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "CollectionAdd.h"

@implementation CollectionAdd

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)clickBtnAddImage:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickBtnAddImage:)]) {
        [self.delegate clickBtnAddImage:_cellIndex];
    }
}
@end
