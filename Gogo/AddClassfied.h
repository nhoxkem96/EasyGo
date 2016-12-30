//
//  AddClassfied.h
//  Gogo
//
//  Created by Thuong on 10/22/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddClassfiedDelegate <NSObject>
-(void)clickBtnDangtin:(NSString *)title Content:(NSString *)content Location:(NSString *)location;
@end
@interface AddClassfied : UIView<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tfTitle;
@property (weak, nonatomic) IBOutlet UITextView *txtContent;
@property (weak, nonatomic) IBOutlet UITextField *tfLocation;
@property (weak, nonatomic) IBOutlet UIButton *btnDangtin;
- (IBAction)clickBtnDangtin:(id)sender;

@property (weak, nonatomic) id <AddClassfiedDelegate> delegate;
@end
