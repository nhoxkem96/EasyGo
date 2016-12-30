

//
//  NUAPI.m
//  Nushi
//


#import "StaticData.h"

@implementation StaticData

+ (StaticData*)sharedInstance;
{
    // comment to develop multi-server base
    static StaticData *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[StaticData alloc] init];
    });
    
    return sharedInstance;
}
//

//
- (instancetype)init
{
    self = [super init];
    if (self) {
//        NSString *strMainColor = [[NSUserDefaults standardUserDefaults] stringForKey:kUD_MainColor];
//        if (strMainColor == nil) {
//            self.mainColor = [Utils colorFromHex:@"#03A9F4"];
//        } else {
//            self.mainColor = [Utils colorFromHex:strMainColor];
//        }
        
        //_dataCamera = [[NSMutableDictionary alloc]init];
        
        //dict1[@"key"] = @"value";
        //_dataCamera[@"CAMERA_ID"] = @"value";
        
        
    }
    return self;
}

- (void) parseDataFromArray:(NSArray *) arrSystemSetting;
{

}

- (void) cleanData;
{

}

@end
