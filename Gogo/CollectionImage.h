//
//  CollectionImage.h
//  Gogo
//
//  Created by Thuong on 9/10/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CollectionImageDelegate <NSObject>
-(void)uploadComplete:(NSInteger) cellIndex;
-(void)deleteImage:(NSInteger) cellIndex;
@end
@interface CollectionImage : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgItem;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
- (IBAction)clickBtnCancel:(id)sender;
@property NSInteger cellIndex;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progress;
-(void)uploadImage:(UIImage *)image publicID:(NSString *)public_id;
@property (weak, nonatomic) id <CollectionImageDelegate> delegate;
@end
