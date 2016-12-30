//
//  BasedViewController.h
//  Mosavik
//
//  Created by TaHoangMinh on 7/18/14.
//  Copyright (c) 2014 niw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaticData.h"
#import "Utils.h"

#define kTagCustomNavi 10001
#define kTagTabBar 20002

@interface BasedViewController : UIViewController <UIActionSheetDelegate>{
    
   // APIClient *mAPIClient;
}

@property UIToolbar *toolbarView;
@property UIView *backgroundView;
@property (nonatomic, assign) BOOL isDisablePanGeuture;
@property (weak, nonatomic) IBOutlet UIView *customNavigation;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UILabel *lblTheme;
@property NSString *strTitle;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingLblTitle;
//tabbar your...

-(void)localizableViewControl;
-(void)fillDataInitForView;
//- (void)thankNews:(id)news;
//- (void)shareNews:(id)news;
-(IBAction)backAction:(id)sender;
//- (void) handleShareNewsSuccessfully:(id)sharedNews;
//- (void) handleThankNewsSuccessfully:(id)sharedNews;
- (void) customNavigationBar;

///////// LOGIC OF APP
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
- (IBAction)btnEditClicked:(id)sender;


@property BOOL checkView;

- (void)showLoadingView;
- (void)hideLoadingView;

@end
