//
//  FlightViewController.h
//  Gogo
//
//  Created by Thuong on 12/30/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownListView.h"
@interface FlightViewController : UIViewController{
    DropDownListView * dropdownSelectPointsGo;
    DropDownListView *dropdownLanding;
    NSArray *arrayPosition;
    NSArray *arrayPositionCode;
}
@property (weak, nonatomic) IBOutlet UIView *viewSelectPointsGo;
- (IBAction)clickBtnSearch:(id)sender;
- (IBAction)clickBtnDatePicker:(id)sender;
- (IBAction)changeDatePicker:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnDatePicker;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectPointsGo;
- (IBAction)clickBtnPointGo:(id)sender;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
- (IBAction)clickBtnXong:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectLanding;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
- (IBAction)clickBtnLanding:(id)sender;
@end
