//
//  CollectionImage.m
//  Gogo
//
//  Created by Thuong on 9/10/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "CollectionImage.h"

@interface CollectionImage()
@end
@implementation CollectionImage

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)uploadImage:(UIImage *)image publicID:(NSString *)public_id{

}
-(void)complete{
    if ([self.delegate respondsToSelector:@selector(uploadComplete:)]) {
        [self.delegate uploadComplete:_cellIndex];
    }

}
- (IBAction)clickBtnCancel:(id)sender {
    if ([self.delegate respondsToSelector:@selector(deleteImage:)]) {
        [self.delegate deleteImage:_cellIndex];
    }
}
@end
