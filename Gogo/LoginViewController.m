//
//  LoginViewController.m
//  Gogo
//
//  Created by Thuong on 8/28/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "LoginViewController.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "SingleObject.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
@import Firebase;
@import FirebaseInstanceID;
@import FirebaseMessaging;
#define kClientId @"981241735796-v70v2evigbc57oms91cq1r2o6rg4s0p9.apps.googleusercontent.com"
#define URLSERVER @"http://easygo.com.vn/api/user/login"
@interface LoginViewController ()
@end
@implementation LoginViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.login = [[ModelLogin alloc]init];
    self.info = [[UserInfo alloc] init];
    // Do any additional setup after loading the view.
    UIImage *image  = [UIImage imageNamed:@"LoginBackground.jpg"];
    UIImage *background = [Utils imageWithImage:image scaledToSize:CGSizeMake(self.view.frame.size.width , self.view.frame.size.height)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:background];
    
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    
    
    self.btnLoginFacebook.layer.cornerRadius = 5 ;
    self.btnLoginFacebook.layer.masksToBounds = YES;
    
    self.btnLoginGoogle.layer.cornerRadius = 5;
    self.btnLoginGoogle.layer.masksToBounds = YES;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark - login facebook
- (IBAction)clickBtnLoginFacebook:(id)sender {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile", @"user_friends",@"email" , @"user_birthday"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             if ([result.grantedPermissions containsObject:@"email"])
             {
                 [self fetchUserInfo];
             }
        }
     }];
    
    
}
-(void)fetchUserInfo
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, picture.type(large), email, birthday , friends , friendlists"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 
                 self.login = [MTLJSONAdapter modelOfClass:[ModelLogin class]
                                                  fromJSONDictionary:result
                                                               error:&error];
                 NSLog(@"%@" , result);
                 self.login.birthday = @"08/08/1996";
                 self.login.loginToken =[[FBSDKAccessToken currentAccessToken]tokenString];
                 
                 NSDictionary *params = @{
                                          @"name":self.login.name,
                                          @"email":self.login.email,
                                          @"facebook_id":self.login.iD,
                                          @"birthday":self.login.birthday,
                                          @"avatar":self.login.avatar,
                                          @"facebook_token":self.login.loginToken
                                          
                                          };
                 NSURL * url = [[NSURL alloc]initWithString:URLSERVER];
                 AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                 manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                 
                 [manager POST:url.absoluteString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                     SingleObject *object = [MTLJSONAdapter modelOfClass:[SingleObject class]
                                             fromJSONDictionary:responseObject
                                                          error:nil];
                     if(object.code == 1){
                         
                         self.info = [MTLJSONAdapter modelOfClass:[UserInfo class]
                                               fromJSONDictionary:object.result
                                                            error:nil];
                         NSLog(@"%@" , self.info);
                         [[NSUserDefaults standardUserDefaults] setObject:self.info.access_token forKey:@"access_token"];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                         NSLog(@"success");
                         [[NSUserDefaults standardUserDefaults] setObject:self.info.access_token forKey:@"access_token"];
                         [[NSUserDefaults standardUserDefaults] setObject:self.info.iD forKey:@"userID"];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                         [[NSUserDefaults standardUserDefaults] setObject:@"facebook"forKey:@"typeLogin"];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                         [self fcm];

                     }
                     else NSLog(@"%@" , object.message);
                     [self dismiss];

                 } 
                       failure:^(NSURLSessionTask *operation, NSError *error) {
                           NSLog(@"Error: %@", error);
                       }];
             }
             else
             {
                 NSLog(@"Error %@",error);
             }
         }];
        
    }
}
#pragma mark - login G+
- (IBAction)clickBtnLoginGoogle:(id)sender {
    [GPPSignIn sharedInstance].clientID = kClientId;
    [GPPSignIn sharedInstance].scopes= [NSArray arrayWithObjects:kGTLAuthScopePlusLogin,kGTLAuthScopePlusUserinfoProfile,kGTLAuthScopePlusUserinfoEmail , nil];

    [GPPSignIn sharedInstance].delegate=self;
    [GPPSignIn sharedInstance].shouldFetchGoogleUserEmail = YES;
    [GPPSignIn sharedInstance].shouldFetchGoogleUserID=YES;
    [GPPSignIn sharedInstance].shouldFetchGoogleUserEmail=YES;
    [[GPPSignIn sharedInstance] authenticate];
    [[GPPSignIn sharedInstance] setHomeServerClientID:kClientId];

}

- (IBAction)clickBtnCancel:(id)sender {
    if ([self.delegate respondsToSelector:@selector(dismissViewController)]) {
        [self.delegate dismissViewController];
    }
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
-(void)finishedWithAuth:(GTMOAuth2Authentication *)auth
error:(NSError *)error
{
    if (!error)
    {
        GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
        
        NSLog(@"email %@ ", [NSString stringWithFormat:@"Email: %@",[GPPSignIn sharedInstance].authentication.userEmail]);
        NSLog(@"Received error %@ and auth object %@",error, auth);
        GTLServicePlus* plusService = [[GTLServicePlus alloc] init] ;
        plusService.retryEnabled = YES;
        [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
        plusService.apiVersion = @"v1";
        [plusService executeQuery:query
                completionHandler:^(GTLServiceTicket *ticket,
                                    GTLPlusPerson *person,
                                    NSError *error) {
                    if (error) {
                    } else {
                        self.login.email = [GPPSignIn sharedInstance].authentication.userEmail;
                        self.login.iD = person.identifier;
                        self.login.name = [person.name.givenName stringByAppendingFormat:@" %@", person.name.familyName];
                        self.login.loginToken = [GPPSignIn sharedInstance].authentication.accessToken;
                        self.login.avatar = person.image.url;
                        self.login.birthday = @"1900-01-01";
                        NSDictionary *params = @{
                                                 @"name":self.login.name,
                                                 @"email":self.login.email,
                                                 @"google_id":self.login.iD,
                                                 @"birthday":self.login.birthday,
                                                 @"avatar":self.login.avatar,
                                                 @"goole_token":self.login.loginToken
                                                 };
                        
                        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                        NSURL * url = [[NSURL alloc]initWithString:URLSERVER];
                        [manager POST:url.absoluteString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                            NSLog(@"%@", responseObject);
                            SingleObject *object = [MTLJSONAdapter modelOfClass:[SingleObject class]
                                                             fromJSONDictionary:responseObject
                                                                          error:nil];
                            if(object.code == 1){
                                self.info = [MTLJSONAdapter modelOfClass:[UserInfo class]
                                                      fromJSONDictionary:object.result
                                                                   error:nil];
                                NSLog(@"%@", self.info);
                                [[NSUserDefaults standardUserDefaults] setObject:self.info.access_token forKey:@"access_token"];
                                [[NSUserDefaults standardUserDefaults] setObject:self.info.iD forKey:@"userID"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                [[NSUserDefaults standardUserDefaults] setObject:@"google" forKey:@"typeLogin"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                [self fcm];
                            }
                            else NSLog(@"%@" , object.message);
                            [self dismiss];
                            
                        }
                              failure:^(NSURLSessionTask *operation, NSError *error) {
                                  NSLog(@"Error: %@", error);
                              }];

                    }
                }];
    }
    else
    {
        NSLog(@"Error: %@", error);
    }
}
-(void)fcm{
    NSString *old_fcm_token = [[NSUserDefaults standardUserDefaults]
                               stringForKey:@"fcm_token"];
    NSLog(@"%@" , old_fcm_token);
    NSString *string = [NSString stringWithFormat:@"access_token %@" , self.info.access_token];
    NSURL * url = [[NSURL alloc]initWithString:@"http://easygo.com.vn/api/fcm"];
    NSString *myString = [NSString stringWithFormat:@"fcm_id=%@" , old_fcm_token];
    NSData *requestData = [myString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    if (requestData.length>0) {
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setValue:string forHTTPHeaderField:@"Authorization"];
        [urlRequest setHTTPBody: requestData];
    }
    NSURLSessionDataTask * dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data.length>0 && error==nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            NSLog(@"Dict=%@",dict);
        }
    }];
    [dataTask resume];

//    NSDictionary *params = @{
//                             @"fcm_id":old_fcm_token
//                             };
//    NSString *string = [NSString stringWithFormat:@"access_token %@" , self.info.access_token];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
//    [manager POST:@"http://easygo.com.vn/api/fcm" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//    } failure:^(NSURLSessionTask *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
}
-(void)dismiss{
    if ([self.delegate respondsToSelector:@selector(dismissViewController)]) {
        [self.delegate dismissViewController];
    }
//    UINavigationController *firstTabNC = [[self.tabBarController viewControllers] objectAtIndex:0];
//    HomeViewController *vc = (HomeViewController*)[[firstTabNC viewControllers] objectAtIndex:0];
//    [vc resetData];
//    [vc.homeTableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popToViewController:self animated:YES];
}
-(void)viewWillAppear: (BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.tabBarController.tabBar setHidden:YES];
}

-(void)viewWillDisappear: (BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.tabBarController.tabBar setHidden:NO];
}
@end
