//
//  AlertView.h
//  Gogo
//
//  Created by Thuong on 10/9/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownPicker.h"
#import "NIDropDown.h"
#import "CustomIOSAlertView.h"
@protocol AlearViewDelegate <NSObject>
-(void)clickBtnPost:(NSString *)idCategory location:(NSString*)location lat:(float)lat lon:(float)lon;
@end
@interface AlertView : UIView<UITextFieldDelegate,NIDropDownDelegate , CustomIOSAlertViewDelegate>{
    NIDropDown *dropDown;
}
@property (weak, nonatomic) id <AlearViewDelegate> delegate;
@property (strong, nonatomic) DownPicker *downPicker;
@property (weak, nonatomic) IBOutlet UITextField *txtCategory;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;
@property (weak, nonatomic) IBOutlet UIButton *btnCategory;
- (IBAction)clickBtnCategory:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnPost;
- (IBAction)clickBtnPost:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property NSString *idCategory;
@property NSMutableArray *arrayCategory;
@property NSMutableArray *arrayIdCategory;
@property CGFloat lat;
@property CGFloat lon;
@end
