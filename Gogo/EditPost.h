//
//  EditPost.h
//  Gogo
//
//  Created by Thuong on 11/6/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EditPostDelegate <NSObject>
-(void)clickBtnEditPost;
-(void)clickBtnDeletePost;
-(void)clickBtnCancel;
@end
@interface EditPost : UIView{
    
}
- (IBAction)clickBtnSuaBaiViet:(id)sender;
- (IBAction)clickBtnXoaBaiViet:(id)sender;

- (IBAction)clickBtnHuy:(id)sender;
@property (weak, nonatomic) id <EditPostDelegate> delegate;
@end
