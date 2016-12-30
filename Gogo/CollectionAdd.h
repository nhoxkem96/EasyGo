//
//  CollectionAdd.h
//  Gogo
//
//  Created by Thuong on 9/10/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CollectionAddDelegate <NSObject>
-(void)clickBtnAddImage:(NSInteger)cellIndex;
@end
@interface CollectionAdd : UICollectionViewCell
- (IBAction)clickBtnAddImage:(id)sender;
@property (weak, nonatomic) id <CollectionAddDelegate> delegate;
@property NSInteger cellIndex;
@end
