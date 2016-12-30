//
//  AppDelegate.m
//  Gogo
//
//  Created by Thuong on 8/22/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <GooglePlus/GooglePlus.h>
#import "AFNetworking.h"
#import "ViewController.h"
#import "UserProfileViewController.h"
#import "HomeViewController.h"
#import "SearchViewController.h"
#import "MoreViewController.h"
#import "LoginViewController.h"
#import "NotificationController.h"
#import "Utils.h"
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
#endif
@import GoogleMaps;
@import GooglePlaces;
@import Firebase;
@import FirebaseInstanceID;
@import FirebaseMessaging;

// Implement UNUserNotificationCenterDelegate to receive display notification via APNS for devices
// running iOS 10 and above. Implement FIRMessagingDelegate to receive data message via FCM for
// devices running iOS 10 and above.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// define macro
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
@interface AppDelegate () <UIApplicationDelegate,UNUserNotificationCenterDelegate, FIRMessagingDelegate,UITabBarControllerDelegate>
@property id numberNotiNotSeen;
@end
#endif
#ifndef NSFoundationVersionNumber_iOS_9_x_Max
#define NSFoundationVersionNumber_iOS_9_x_Max 1299
#endif
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UITabBarController *tabBarController =
    (UITabBarController *)[[self window] rootViewController];
    [tabBarController setDelegate:self];
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        // iOS 7.1 or earlier. Disable the deprecation warnings.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIRemoteNotificationType allNotificationTypes =
        (UIRemoteNotificationTypeSound |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeBadge);
        [application registerForRemoteNotificationTypes:allNotificationTypes];
#pragma clang diagnostic pop
    } else {
        // iOS 8 or later
        // [START register_for_notifications]
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
            UIUserNotificationType allNotificationTypes =
            (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
            UIUserNotificationSettings *settings =
            [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        } else {
            // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
            UNAuthorizationOptions authOptions =
            UNAuthorizationOptionAlert
            | UNAuthorizationOptionSound
            | UNAuthorizationOptionBadge;
            [[UNUserNotificationCenter currentNotificationCenter]
             requestAuthorizationWithOptions:authOptions
             completionHandler:^(BOOL granted, NSError * _Nullable error) {
             }
             ];
            
            // For iOS 10 display notification (sent via APNS)
            [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];
            // For iOS 10 data message (sent via FCM)
            [[FIRMessaging messaging] setRemoteMessageDelegate:self];
#endif
        }
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        // [END register_for_notifications]
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)
                                                 name:kFIRInstanceIDTokenRefreshNotification object:nil];
    [FIRApp configure];
    [GMSPlacesClient provideAPIKey:@"AIzaSyDRZx12CFeHE5QbWO6CdnC8MxvGv1xKP18"];
    [GMSServices provideAPIKey:@"AIzaSyDRZx12CFeHE5QbWO6CdnC8MxvGv1xKP18"];
    //test
    
    if( SYSTEM_VERSION_LESS_THAN( @"10.0" ) )
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound |    UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error)
         {
             if( !error )
             {
                 [[UIApplication sharedApplication] registerForRemoteNotifications];  // required to get the app to do anything at all about push notifications
                 NSLog( @"Push registration success." );
             }
             else
             {
                 NSLog( @"Push registration FAILED" );
                 NSLog( @"ERROR: %@ - %@", error.localizedFailureReason, error.localizedDescription );
                 NSLog( @"SUGGESTIONS: %@ - %@", error.localizedRecoveryOptions, error.localizedRecoverySuggestion );  
             }  
         }];  
    }
    
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL wasHandled=false;;
    if ([url.scheme hasPrefix:@"fb"]) {
        
        wasHandled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                    openURL:url
                                                          sourceApplication:sourceApplication
                                                                 annotation:annotation
                      ];

        //Facebook callback
    }
    else       //Google Plus callback
    {
        wasHandled=  [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
        
    }
    
    NSLog ( @"application openURL");
    NSLog ( @"URL = %@", url);
    NSLog ( @"Application = %@", sourceApplication);
    
    return wasHandled;
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // Print message ID.
    
    NSArray *resultNotification = [[NSMutableArray alloc]init];
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
    [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    NSLog(@"userInfo=>%@", userInfo);
    NSString *post_id = [userInfo objectForKey:@"post_id"];
    NSString *comment_id = [userInfo objectForKey:@"comment_id"];
    NSString *user_id = [userInfo objectForKey:@"user_id"];
    UINavigationController *firstTabNC = [[((UITabBarController *)self.window.rootViewController) viewControllers] objectAtIndex:0];
    [((UITabBarController *)self.window.rootViewController) setSelectedIndex:0];
    if(user_id.length > 0){
        UserProfileViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
        vc.userID = user_id;
        [firstTabNC pushViewController:vc animated:NO];
    }else{
        ViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"ViewController"];
        vc.idPost = post_id;
        vc.commentID = comment_id;
        [firstTabNC pushViewController:vc animated:NO];
    }

    if(access_token.length > 1){
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
        NSString *url = [NSString stringWithFormat:@"http:easygo.com.vn/api/notifications?page=1"];
        [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            _numberNotiNotSeen = [responseObject objectForKey:@"number_have_not_seen"];
            if([_numberNotiNotSeen integerValue] > 0 ){
                UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
                [[tabController.tabBar.items objectAtIndex:3] setBadgeValue:[NSString stringWithFormat:@"%@" , _numberNotiNotSeen]];
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
}
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    // Print message ID.
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    NSDictionary *userInfo = notification.request.content.userInfo;
    NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
    NSLog(@"%@", userInfo);
    if(access_token.length > 1){
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
        NSString *url = [NSString stringWithFormat:@"http:easygo.com.vn/api/notifications?page=1"];
        [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            _numberNotiNotSeen = [responseObject objectForKey:@"number_have_not_seen"];
            if([_numberNotiNotSeen integerValue] > 0 ){
                UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
                
                [[tabController.tabBar.items objectAtIndex:3] setBadgeValue:[NSString stringWithFormat:@"%@" , _numberNotiNotSeen]];
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
    
    NSLog( @"Handle push from foreground" );
    // custom code to handle push while app is in the foreground
    NSLog(@"%@", notification.request.content.userInfo);
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)())completionHandler
{
    NSLog( @"Handle push from background or closed" );
    // if you set a member variable in didReceiveRemoteNotification, you  will know if this is from closed or background
    NSLog(@"%@", response.notification.request.content.userInfo);
    NSString *post_id = [response.notification.request.content.userInfo objectForKey:@"post_id"];
    NSString *comment_id = [response.notification.request.content.userInfo objectForKey:@"comment_id"];
    NSString *user_id = [response.notification.request.content.userInfo objectForKey:@"user_id"];
    UINavigationController *firstTabNC = [[((UITabBarController *)self.window.rootViewController) viewControllers] objectAtIndex:0];
    [((UITabBarController *)self.window.rootViewController) setSelectedIndex:0];
    if(user_id.length > 0){
        UserProfileViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
        vc.userID = user_id;
        [firstTabNC pushViewController:vc animated:NO];
    }else{
        ViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"ViewController"];
        vc.idPost = post_id;
        vc.commentID = comment_id;
        [firstTabNC pushViewController:vc animated:NO];
    }
}
- (void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    // Print full message
    NSLog(@"sad sad  %@", [remoteMessage appData]);
    
    // Request to reload table view data
}

#endif
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[FIRMessaging messaging] disconnect];
    NSLog(@"Disconnected from FCM");
}
- (void)tokenRefreshNotification:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSString *old_fcm_token = [[NSUserDefaults standardUserDefaults]
                     stringForKey:@"fcm_token"];
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token: %@", refreshedToken);
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"fcm_token"];
    [[NSUserDefaults standardUserDefaults] setObject:refreshedToken forKey:@"fcm_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *fcm = [[NSUserDefaults standardUserDefaults]
                     stringForKey:@"fcm_token"];
    NSLog(@"%@" , fcm);
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    
    if(access_token.length > 1){
        if(old_fcm_token.length > 1){
            NSURL * url = [[NSURL alloc]initWithString:@"http://easygo.com.vn/api/fcm"];
            NSString *myString = [NSString stringWithFormat:@"fcm_id=%@" , refreshedToken];
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
        }
        else{
            NSURL * url = [[NSURL alloc]initWithString:@"http://easygo.com.vn/api/fcm"];
            NSString *myString = [NSString stringWithFormat:@"fcm_old=%@&fcm_new=%@",old_fcm_token , refreshedToken];
            NSData *requestData = [myString dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
            
            if (requestData.length>0) {
                [urlRequest setHTTPMethod:@"PUT"];
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
        }
    }

    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
    
    // TODO: If necessary send token to application server.
}
// [END refresh_token]

// [START connect_to_fcm]
- (void)connectToFcm {
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            NSLog(@"Connected to FCM.");
        }
    }];
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
      [self connectToFcm];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    if(access_token.length < 1){
        LoginViewController *vcLogin = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        UINavigationController *firstTabNC = [[((UITabBarController *)self.window.rootViewController) viewControllers] objectAtIndex:0];
        [((UITabBarController *)self.window.rootViewController) setSelectedIndex:0];
        HomeViewController *vc = (HomeViewController*)[[firstTabNC viewControllers] objectAtIndex:0];
        [vc login];
//        [firstTabNC pushViewController:vcLogin animated:NO];
    }
    NSLog(@"controller class: %@", viewController.title);
    if([viewController.title caseInsensitiveCompare:@"NotificationNavigationController"] == NSOrderedSame){
        NSLog(@"fuck");
        NSString *access_token = [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"access_token"];
        NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
        NSLog(@"%@", string);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
        NSString *url = [NSString stringWithFormat:@"http:easygo.com.vn/api/notifications/clear"];
        [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
        [[tabController.tabBar.items objectAtIndex:3] setBadgeValue:nil];

    }
}
@end
