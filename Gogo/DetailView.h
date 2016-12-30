//
//  DetailView.h
//  Gogo
//
//  Created by Thuong on 9/10/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownPicker.h"
#import "NIDropDown.h"
@interface DetailView : UITableViewCell<NIDropDownDelegate>{
    NIDropDown *dropDown;
}
@property (weak, nonatomic) IBOutlet UIButton *btnCategory;
@property (weak, nonatomic) IBOutlet UITextField *txtCategory;
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;
@property (strong, nonatomic) DownPicker *downPicker;
@property (weak, nonatomic) IBOutlet UIView *contentView;
- (IBAction)clickBtnCategory:(id)sender;
@property NSMutableArray *arrayCategory;
@end
