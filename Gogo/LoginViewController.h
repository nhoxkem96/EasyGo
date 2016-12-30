//
//  LoginViewController.h
//  Gogo
//
//  Created by Thuong on 8/28/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GooglePlus/GooglePlus.h>
#import "ModelLogin.h"
#import "AFNetworking.h"
#import "UserInfo.h"
@protocol LoginViewControllerDelegate <NSObject>

- (void)dismissViewController;
@end
@interface LoginViewController : UIViewController <GPPSignInDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnLoginFacebook;
@property (weak, nonatomic) IBOutlet UIButton *btnLoginGoogle;
- (IBAction)clickBtnLoginFacebook:(id)sender;
- (IBAction)clickBtnLoginGoogle:(id)sender;
- (IBAction)clickBtnCancel:(id)sender;
@property NSMutableArray* arrayDataLoginFacebook;
@property (strong,nonatomic) ModelLogin *login;
@property (strong,nonatomic) UserInfo *info;
@property (weak, nonatomic) id <LoginViewControllerDelegate> delegate;
@end
