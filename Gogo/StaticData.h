#import <Foundation/Foundation.h>
#import "Utils.h"
#define kUD_MainColor @"kUD_MainColor"
#define kNotificationReloadAllFeed @"kNotificationReloadAllFeed"

@interface StaticData : NSObject

+ (StaticData*)sharedInstance;

@property UIColor *mainColor;

@property BOOL isLogOut;
@property NSArray *arrFollowed_Topics;
@property BOOL needShowIntro;
@property (nonatomic, strong) NSDictionary *screenMap;
@property NSMutableDictionary *dictDropdownData;

- (void) parseDataFromArray:(NSArray *) arrSystemSetting;
- (void) cleanData;
// save passs..
@property NSString *passWord;
//login
@property NSString *id_owner;
//list my evnet
@property NSArray *listMyEvent;
//list other user
@property NSArray *listOtherUser;
//id event
@property NSString *idEvent;
//list Feed
@property NSArray *listFeed;

@end
