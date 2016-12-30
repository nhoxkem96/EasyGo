//
//  TQUtils.m
//  12Q
//
//  Created on 3/22/14.
//  Copyright (c) 2014 Twelvebits Inc. All rights reserved.
//

#import "Utils.h"
#import <CommonCrypto/CommonDigest.h>
#import <objc/runtime.h>
@implementation Utils

static id instance = nil;
static id _shareInstance = nil;
static int fontSmall;
static int fontNormal;
static int fontBig;
static BOOL checkOpen = NO;
static NSDateFormatter *formatter = nil;
-(instancetype)init{
    self = [super init];
    if (self) {
        if ([UIScreen mainScreen].bounds.size.height == 480 ){
            // iPhone 4
            fontSmall = 11;
            fontNormal = 13;
            fontBig = 15;
        } else if( [UIScreen mainScreen].bounds.size.height == 568) {
            // IPhone 5
            fontSmall = 12;
            fontNormal = 14;
            fontBig = 16;
        } else if ([UIScreen mainScreen].bounds.size.width == 375 ){
            // iPhone 6
            fontSmall = 13;
            fontNormal = 15;
            fontBig = 17;
        } else if ([UIScreen mainScreen].bounds.size.width == 414) {
            // iPhone 6+
            fontSmall = 14;
            fontNormal = 16;
            fontBig = 18;
        }

    }
    return self;
}
+(NSString *)weatherIcon:(NSInteger)code;{
    if(code == 0){
        return @"\uf056";
    }
    else if(code == 1){
        return @"\uf00e";
    }
    else if(code == 2){
        return @"\uf073";
    }
    else if(code == 3){
        return @"\uf010";
    }
    else if(code == 4){
        return @"\uf010";
    }
    else if(code == 5){
        return @"\uf017";
    }
    else if(code == 6){
        return @"\uf017";
    }
    else if(code == 7){
        return @"\uf017";
    }
    else if(code == 8){
        return @"\uf015";
    }
    else if(code == 9){
        return @"\uf01a";
    }
    else if(code == 10){
        return @"\uf015";
    }
    else if(code == 11){
        return @"\uf01a";
    }
    else if(code == 12){
        return @"\uf01a";
    }
    else if(code == 13){
        return @"\uf01b";
    }
    else if(code == 14){
        return @"\uf00a";
    }
    else if(code == 15){
        return @"\uf065";
    }
    else if(code == 16){
        return @"\uf01b";
    }
    else if(code == 17){
        return @"\uf015";
    }
    else if(code == 18){
        return @"\uf017";
    }
    else if(code == 19){
        return @"\uf063";
    }
    else if(code == 20){
        return @"\uf014";
    }
    else if(code == 21){
        return @"\uf021";
    }
    else if(code == 22){
        return @"\uf062";
    }
    else if(code == 23){
        return @"\uf050";
    }
    else if(code == 24){
        return @"\uf050";
    }
    else if(code == 25){
        return @"\uf076";
    }
    else if(code == 26){
        return @"\uf013";
    }
    else if(code == 27){
        return @"\uf031";
    }
    else if(code == 28){
        return @"\uf002";
    }
    else if(code == 29){
        return @"\uf031";
    }
    else if(code == 30){
        return @"\uf002";
    }
    else if(code == 31){
        return @"\uf02e";
    }
    else if(code == 32){
        return @"\uf00d";
    }
    else if(code == 33){
        return @"\uf083";
    }
    else if(code == 34){
        return @"\uf00c";
    }
    else if(code == 35){
        return @"\uf017";
    }
    else if(code == 36){
        return @"\uf072";
    }
    else if(code == 37){
        return @"\uf00e";
    }
    else if(code == 38){
        return @"\uf00e";
    }
    else if(code == 39){
        return @"\uf00e";
    }
    else if(code == 40){
        return @"\uf01a";
    }
    else if(code == 41){
        return @"\uf064";
    }
    else if(code == 42){
        return @"\uf01b";
    }
    else if(code == 43){
        return @"\uf065";
    }
    else if(code == 44){
        return @"\uf00c";
    }
    else if(code == 45){
        return @"\uf00e";
    }
    else if(code == 46){
        return @"\uf01b";
    }
    else if(code == 47){
        return @"\uf00e";
    }
    else{
        return @"\uf077";
    }
}
+(void)setOpenApp:(BOOL)status;{
    checkOpen = status;
}
+ (BOOL) checkOpenApp{
    return checkOpen;
}
+ (NSUInteger)fontSizeSmall;{
    if ([UIScreen mainScreen].bounds.size.height == 480 ){
        // iPhone 4
        return 10;
    } else if( [UIScreen mainScreen].bounds.size.height == 568) {
        // IPhone 5
        return 11;
    } else if ([UIScreen mainScreen].bounds.size.width == 375 ){
        // iPhone 6
        return 13;
    } else if([UIScreen mainScreen].bounds.size.width == 414){
        // iPhone 6+
        return 15;
    }else{
        return 15;
    }

}
+ (NSUInteger)fontSizeNormal;{
    if ([UIScreen mainScreen].bounds.size.height == 480 ){
        // iPhone 4
        return 12;
    } else if( [UIScreen mainScreen].bounds.size.height == 568) {
        // IPhone 5
        return 13;
    } else if ([UIScreen mainScreen].bounds.size.width == 375 ){
        // iPhone 6
        return 15;
    } else if([UIScreen mainScreen].bounds.size.width == 414){
        // iPhone 6+
        return 17;
    }else{
        return 17;
    }

}
+ (NSUInteger)fontSizeBig;{
    if ([UIScreen mainScreen].bounds.size.height == 480 ){
        // iPhone 4
        return 14;
    } else if( [UIScreen mainScreen].bounds.size.height == 568) {
        // IPhone 5
        return 15;
    } else if ([UIScreen mainScreen].bounds.size.width == 375 ){
        // iPhone 6
        return 17;
    } else if([UIScreen mainScreen].bounds.size.width == 414){
        // iPhone 6+
        return 19;
    }else{
        return 19;
    }

}
+ (Utils *) sharedInstance;
{
    NSLog(@"Start");
    if (_shareInstance == nil) {
        _shareInstance = [[Utils alloc] init];
    }
    return _shareInstance;
}

+ (BOOL)isLabelTruncated:(UILabel *)mylabel;
{
    CGSize perfectSize = [mylabel.text sizeWithFont:mylabel.font constrainedToSize:CGSizeMake(mylabel.bounds.size.width, NSIntegerMax) lineBreakMode:mylabel.lineBreakMode];
    if (perfectSize.height > mylabel.bounds.size.height) {
        return YES;
    }
    return NO;
}
+ (UIFont *)findAdaptiveFontWithName:(NSString *)fontName forUILabelSize:(CGSize)labelSize withMinimumSize:(NSInteger)minSize
{
    UIFont *tempFont = nil;
    NSString *testString = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    NSInteger tempMin = minSize;
    NSInteger tempMax = 256;
    NSInteger mid = 0;
    NSInteger difference = 0;
    
    while (tempMin <= tempMax) {
        mid = tempMin + (tempMax - tempMin) / 2;
        tempFont = [UIFont fontWithName:fontName size:mid];
        difference = labelSize.height - [testString sizeWithFont:tempFont].height;
        
        if (mid == tempMin || mid == tempMax) {
            if (difference < 0) {
                return [UIFont fontWithName:fontName size:(mid - 1)];
            }
            
            return [UIFont fontWithName:fontName size:mid];
        }
        
        if (difference < 0) {
            tempMax = mid - 1;
        } else if (difference > 0) {
            tempMin = mid + 1;
        } else {
            return [UIFont fontWithName:fontName size:mid];
        }
    }
    
    return [UIFont fontWithName:fontName size:mid];
}
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
+ (UIColor *)colorFromHex:(NSString *)stringColor
{
    int red, green, blue;
    sscanf([stringColor UTF8String], "#%02X%02X%02X", &red, &green, &blue);
    
    UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
    return color;
}

+ (void) applyAttributeText:(NSString *)text1 text:(NSString *)text2 color1:(UIColor *)color1 color2:(UIColor *)color2 inLabel:(UILabel *)lbl;
{
    NSDictionary *attrs1 = @{ NSForegroundColorAttributeName : color2,
                              NSFontAttributeName : lbl.font};
    NSMutableAttributedString * str1 = [[NSMutableAttributedString alloc] initWithString:text2 attributes:attrs1];
    
    NSDictionary *attrs2 = @{ NSForegroundColorAttributeName : color1,
                              NSFontAttributeName : lbl.font};
    NSMutableAttributedString * str2 = [[NSMutableAttributedString alloc] initWithString:text1 attributes:attrs2];
    
    [str2 appendAttributedString:str1];
    lbl.attributedText = str2;
}

+ (NSString *) localizeString: (NSString *) translation_key;
{
    NSString * language = [[NSUserDefaults standardUserDefaults] stringForKey:kUD_Language];
    if (!(language == nil || [language isEqualToString:@""])) {
        if ([language isEqualToString:@"German"]) {
            language = @"de";
        }
        if ([language isEqualToString:@"Norwegian"]) {
            language = @"nb";
        }
        if ([language isEqualToString:@"Spanish"]) {
            language = @"es";
        }
        if ([language isEqualToString:@"Swedish"]) {
            language = @"sv";
        }
        if ([language isEqualToString:@"French"]) {
            language = @"fr";
        }
        if ([language isEqualToString:@"Dansk"]) {
            language = @"da";
        }
        if ([language isEqualToString:@"Portuguese"]) {
            language = @"pt";
        }
        if ([language isEqualToString:@"English"]) {
            language = @"en";
        }
        NSBundle * languageBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:language ofType:@"lproj"]];
        NSString * str=[languageBundle localizedStringForKey:translation_key value:@"" table:nil];
        return str;
    }
    NSString * s = NSLocalizedString(translation_key, nil);
    return s;
}

+ (NSInteger) numberOfLineFromString :(NSString *)str width:(float)_width;
{
    if (!str || str.length ==0){
        return 1;
    }
    if (str.length ==0)
    {
        return 1;
    }
    CGSize maximumLabelSize = CGSizeMake(_width,9999);
    
    CGSize expectedLabelSize = [str sizeWithFont:[UIFont systemFontOfSize:13]
                               constrainedToSize:maximumLabelSize
                                   lineBreakMode:NSLineBreakByWordWrapping];
    
    return expectedLabelSize.height/13;
}

+ (UILabel *)copyLabel:(UILabel *)label;
{
    UILabel *copy = [[UILabel alloc] initWithFrame:label.frame];
    copy.text = label.text;
    copy.font = label.font;
    copy.numberOfLines = label.numberOfLines;
    copy.lineBreakMode = label.lineBreakMode;
    copy.textAlignment = label.textAlignment;
    return copy;
}

+ (void) addKey:(NSString *)key value:(id)value toDict:(NSMutableDictionary *)dict;
{
    if (key == nil || value == nil) {
        return;
    }
    dict[key] = value;
}

+ (UITextView *)copyTextView:(UITextView *)label;
{
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject: label];
    UITextView* copy = [NSKeyedUnarchiver unarchiveObjectWithData: archivedData];
    return copy;
}

+ (NSString *) md5:(NSString *) input;
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}

+ (void) fitLabel:(UILabel *)lbl toWidth:(int) width numberOfLine:(int) numberOfLine;
{
    [Utils setWidhView:lbl width:width];
    lbl.numberOfLines = numberOfLine;
    [lbl sizeToFit];
    NSLog(@"pre: %d after: %d", width, (int)lbl.frame.size.width);
    
//    lbl.layer.borderColor = kColorRed.CGColor;
//    lbl.layer.borderWidth = 1.0f;

}


+ (void) setWidhView:(UIView *)view width:(int)width;
{
    view.frame = CGRectMake(view.frame.origin.x,
                            view.frame.origin.y,
                            width,
                            view.frame.size.height);
}
+ (void) setHeightView:(UIView *)view height:(int)height;
{
    view.frame = CGRectMake(view.frame.origin.x,
                            view.frame.origin.y,
                            view.frame.size.width,
                            height);
}

+ (void) setXView:(UIView *)view height:(int)x;
{
    view.frame = CGRectMake(x,
                            view.frame.origin.y,
                            view.frame.size.width,
                            view.frame.size.height);
}


+ (void) setYView:(UIView *)view height:(int)y;
{
    view.frame = CGRectMake(view.frame.origin.x,
                            y,
                            view.frame.size.width,
                            view.frame.size.height);
}

+ (NSString *)fullNameFromFirst:(NSString *)fName last:(NSString *)lName middle:(NSString *)middleName;
{
    NSString *strResult = @"";
    if (![@"" isEqualToString:SAFE_STR(fName)]) {
        strResult = [strResult stringByAppendingFormat:@"%@",SAFE_STR(fName)];
    }
    
    if (![@"" isEqualToString:SAFE_STR(lName)]) {
        strResult = [strResult stringByAppendingFormat:@" %@",SAFE_STR(lName)];
    }
    
    if (![@"" isEqualToString:SAFE_STR(middleName)]) {
        strResult = [strResult stringByAppendingFormat:@" %@",SAFE_STR(middleName)];
    }
    return strResult;
}

+ (CGFloat) measureHeightOfUITextView:(UITextView *)textView;
{
    if (textView.text == nil || textView.text.length == 0) {
        return 0.0f;
    }
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_0)
    {
        CGSize textViewSize = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, FLT_MAX)];
        return textViewSize.height;
    }
    else
    {
        return textView.contentSize.height;
    }
}
+ (NSDateFormatter *) dateFormatterShort;
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM' 'dd','yyyy' 'HH':'mm' 'a"];
    return formatter;
}

+ (NSDateFormatter *) dateFormatterCommon;
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"];
    return formatter;
}

+ (NSDateFormatter *) dateFormatterISO8601;
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    return formatter;
}

+ (NSString *)genSafeString:(NSString *)str;
{
    if (str == nil || (id)str == [NSNull null]) {
        return @"";
    }
    if ([str isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)str stringValue];
    }
    return str;
}
+ (NSString *)genSafeInt:(NSString *)str;
{
    if (str == nil || (id)str == [NSNull null]) {
        return @"0";
    }
    if ([str isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)str stringValue];
    }
    return str;
}


+ (NSString *) convertString:(NSString *)string from:(NSDateFormatter *)typeFrom to:(NSDateFormatter *)typeTo;
{
    NSDate *date = [typeFrom dateFromString:string];
    return [typeTo stringFromDate:date];
}

+ (id) validateData:(id)obj;
{
    if (obj == [NSNull null]) {
        return nil;
    }
    return obj;
}

+ (NSDateFormatter *) dateFormatterDateOnlyVietnam;
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    return formatter;
}

+ (NSDateFormatter *) dateFormatterDateForNewsOnlyVietnam;
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    return formatter;
}
+ (NSDateFormatter *) dateFormatterDateForNewsOnlyVietnamSameYear;
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM HH:mm"];
    return formatter;
}
+ (NSDateFormatter *) dateFormatterDateForBirthDayServer;
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    return formatter;
}
+ (NSString *)urlencode:(NSString *)str;
{
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[str UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

+ (NSString *)normalizeString:(NSString *)start;
{
//    NSString* finish = [[start componentsSeparatedByCharactersInSet:[[NSCharacterSet letterCharacterSet] invertedSet]] componentsJoinedByString:@""];
    
    NSData *data = [[start lowercaseString] dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *newStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    return newStr;
}

+ (NSDateFormatter *) dateFormatterDOBDisplay;
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    return formatter;
}
+ (BOOL) isHTTPLink:(NSString *)link
{
    return ([link rangeOfString:@"http:"].location != NSNotFound) || ([link rangeOfString:@"https:"].location != NSNotFound);
}

+ (NSDateFormatter *) dateFormatterDateOnly;
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return formatter;
}
+ (NSDictionary *)getComponentFromDate:(NSDate *)date{
    if (date == nil) {
        return nil;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date]; // Get necessary date components
    
    [dict setObject:@([components month]) forKey:@"month"];
    [dict setObject:@([components day]) forKey:@"day"];
    [dict setObject:@([components year]) forKey:@"year"];
    return dict;
}
+ (void) configFont:(id)lbl fontName:(NSString *) fontName;
{
    if ([lbl isKindOfClass:[UITextField class]]) {
        UITextField *tf = (UITextField *)lbl;
        UIFont *font = [UIFont fontWithName:fontName size:tf.font.pointSize];
        tf.font = font;
    } else if ([lbl isKindOfClass:[UITextView class]]) {
        UITextView *tf = (UITextView *)lbl;
        UIFont *font = [UIFont fontWithName:fontName size:tf.font.pointSize];
        tf.font = font;
    } else if ([lbl isKindOfClass:[UILabel class]]) {
        UILabel *tf = (UILabel *)lbl;
        UIFont *font = [UIFont fontWithName:fontName size:tf.font.pointSize];
        tf.font = font;
    } else if ([lbl isKindOfClass:[UIButton class]]) {
        UIButton *tf = (UIButton *)lbl;
        UIFont *font = [UIFont fontWithName:fontName size:tf.titleLabel.font.pointSize];
        [tf.titleLabel setFont:font];
    }
}
+ (UIView *)copyView:(UIView *)view;
{
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:view];
    UIView* copy = [NSKeyedUnarchiver unarchiveObjectWithData: archivedData];
    return copy;
}

+ (UIButton *)copyButton:(UIButton *)button;
{
    UIButton *copy = [UIButton buttonWithType:UIButtonTypeCustom];
    copy.frame = button.frame;
    // background
    [copy setBackgroundImage:[button backgroundImageForState:UIControlStateNormal] forState:UIControlStateNormal];
    [copy setBackgroundImage:[button backgroundImageForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
    [copy setBackgroundImage:[button backgroundImageForState:UIControlStateDisabled] forState:UIControlStateDisabled];
    [copy setBackgroundImage:[button backgroundImageForState:UIControlStateSelected] forState:UIControlStateSelected];
    [copy setBackgroundImage:[button backgroundImageForState:UIControlStateApplication] forState:UIControlStateApplication];
    [copy setBackgroundImage:[button backgroundImageForState:UIControlStateReserved] forState:UIControlStateReserved];
    
    // image
    [copy setImage:[button imageForState:UIControlStateNormal] forState:UIControlStateNormal];
    [copy setImage:[button imageForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
    [copy setImage:[button imageForState:UIControlStateDisabled] forState:UIControlStateDisabled];
    [copy setImage:[button imageForState:UIControlStateSelected] forState:UIControlStateSelected];
    [copy setImage:[button imageForState:UIControlStateApplication] forState:UIControlStateApplication];
    [copy setImage:[button imageForState:UIControlStateReserved] forState:UIControlStateReserved];
    
    // title
    [copy setTitle:[button titleForState:UIControlStateNormal] forState:UIControlStateNormal];
    [copy setTitle:[button titleForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
    [copy setTitle:[button titleForState:UIControlStateDisabled] forState:UIControlStateDisabled];
    [copy setTitle:[button titleForState:UIControlStateSelected] forState:UIControlStateSelected];
    [copy setTitle:[button titleForState:UIControlStateApplication] forState:UIControlStateApplication];
    [copy setTitle:[button titleForState:UIControlStateReserved] forState:UIControlStateReserved];
    
    copy.titleLabel.font = button.titleLabel.font;
    
    copy.imageView.contentMode = button.imageView.contentMode;
    
    return copy;
}


+ (NSString *)applicationDocumentsDirectory {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

+ (NSString *) stringByTrimmed:(NSString *) stringToTrim;
{
    if (stringToTrim == nil) {
        return @"";
    }
    NSError *error = nil;
    NSString *stringReplaced2 = [stringToTrim stringByReplacingOccurrencesOfString:@"　" withString:@" "];
    NSString *stringReplaced = [stringReplaced2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"  +" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *trimmedString = [regex stringByReplacingMatchesInString:stringReplaced options:0 range:NSMakeRange(0, [stringReplaced length]) withTemplate:@" "];
    return trimmedString;
}

+ (void) playButtonSound
{
    //#if !TARGET_IPHONE_SIMULATOR
    //    NSString *pathAudioFile = [[NSBundle mainBundle] pathForResource:@"Tock" ofType:@"caf"];
    //    NSError *error = nil;
    //    NSData *audioData = [NSData dataWithContentsOfFile:pathAudioFile];
    //    TQUtils *utils = [TQUtils shareInstance];
    //    if (utils.audioPlayer2 == nil) {
    //        utils.audioPlayer2 = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
    //        utils.musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    //    }
    //    float vol = utils.musicPlayer.volume;
    //    utils.audioPlayer2.volume = (vol * 1.8);
    //    [utils.audioPlayer2 play];
    //#endif
}

+ (void) showResetNotification;
{
    //#if !TARGET_IPHONE_SIMULATOR
    //    NSString *pathAudioFile = [[NSBundle mainBundle] pathForResource:@"sound_notification" ofType:@"mp3"];
    //    NSError *error = nil;
    //    NSData *audioData = [NSData dataWithContentsOfFile:pathAudioFile];
    //    TQUtils *utils = [TQUtils shareInstance];
    //    if (utils.audioPlayer == nil) {
    //        utils.audioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
    //    }
    //    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    //    float vol = musicPlayer.volume;
    //    utils.audioPlayer.volume = vol;
    //    [utils.audioPlayer play];
    //#endif
}

+ (void) showNotification:(NSString *) notificationMessage;
{
    NSLog(@"showNotification");
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([vc isKindOfClass:[UINavigationController class]]) {
        NSLog(@"showNotification_UINavigationController");
        UINavigationController *nav = (UINavigationController *) vc;
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, -60, nav.view.frame.size.height, 60)];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            lbl.font = [UIFont systemFontOfSize:30];
        } else {
            lbl.font = [UIFont systemFontOfSize:15];
        }
        [Utils configFont:lbl fontName:kFontHelveticaMedium];
        lbl.numberOfLines = 2;
        lbl.text = notificationMessage;
        lbl.textColor = kColorWhite;
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.backgroundColor = kColorMainColor;
        int widthNotification = nav.view.frame.size.width;
        
        lbl.frame = CGRectMake(0, -60, widthNotification, 60);
        [[UIApplication sharedApplication].keyWindow addSubview:lbl];
        [UIView animateWithDuration:2.0f animations:^{
            lbl.frame = CGRectMake(0, 20, widthNotification, 60);
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:2.0f animations:^{
                lbl.frame = CGRectMake(0, -60, widthNotification, 60);
            } completion:^(BOOL finished) {
                [lbl removeFromSuperview];
            }];
        });
    }
}

+ (void)shakeView:(UIView *)viewToShake;
{
    CGFloat t = 10.0;
    CGAffineTransform translateRight  = CGAffineTransformTranslate(CGAffineTransformIdentity, t, 0.0);
    CGAffineTransform translateLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, 0.0);
    
    viewToShake.transform = translateLeft;
    
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:3.0];
        viewToShake.transform = translateRight;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.04 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform = CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}

+ (BOOL) isEmailFormatValid:(NSString *) email;
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isEmailValid = [emailTest evaluateWithObject:email];
    return isEmailValid;
}
+ (NSString*) stringJSONByDictionary:(id)dict;
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (!jsonData) {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"[]";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

+ (id) dictByJSONString:(NSString *)str;
{
    if (!str) {
        return nil;
    }
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    id JSON = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
    
    return JSON;
}

+ (void) customizeSegmentationControl
{
    UIImage *unselectedBackgroundImage = [[UIImage imageNamed:@"btnSegmentControlNoSelect"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 30, 10)];
    UIImage *selectedBackgroundImage = [[UIImage imageNamed:@"btnSegmentControlSelect"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 30, 10)];
    
    [[UISegmentedControl appearance] setBackgroundImage:unselectedBackgroundImage
                                               forState:UIControlStateNormal
                                             barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setBackgroundImage:selectedBackgroundImage
                                               forState:UIControlStateSelected
                                             barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setDividerImage:[UIImage imageNamed:@"btnSegmentControlDividerNo"]
                                 forLeftSegmentState:UIControlStateNormal
                                   rightSegmentState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont systemFontOfSize:16], UITextAttributeFont,
                                [UIColor blackColor], UITextAttributeTextColor, nil];
    NSDictionary *attributesDisable = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIFont systemFontOfSize:16], UITextAttributeFont,
                                       kColorGrayDisable, UITextAttributeTextColor, nil];
    
    [[UISegmentedControl appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [[UISegmentedControl appearance] setTitleTextAttributes:attributesDisable forState:UIControlStateDisabled];
    NSDictionary *highlightedAttributes = [NSDictionary
                                           dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [[UISegmentedControl appearance] setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
}

+ (BOOL) isEmpty:(id) val;
{
    if (val == nil || [@"" isEqualToString:val] || (id)val == [NSNull null]) {
        return YES;
    }
    return NO;
}

+ (CGRect) boundsiOS7;
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    if (screenRect.size.width > screenRect.size.height) {
        return CGRectMake(screenRect.origin.x, screenRect.origin.y, screenRect.size.height, screenRect.size.width);
    }
    
    return screenRect;
}

+ (CGSize) sizeOfDevice;
{
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    if (screenRect.size.width < screenRect.size.height) {
        return CGSizeMake(screenRect.size.width, screenRect.size.height);
    }
    return CGSizeMake(screenRect.size.height, screenRect.size.width);
}

+(UIViewController *) getVisibleViewControllerFrom:(UIViewController *) vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [self getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}
+ (NSString *)numberWithThousandSeparator:(NSString *)number;
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setGroupingSeparator:@","];
    [numberFormatter setGroupingSize:3];
    [numberFormatter setUsesGroupingSeparator:YES];
    [numberFormatter setDecimalSeparator:@"."];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:2];
    NSString *theString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:number.floatValue]];
    return theString;
}

+ (NSString *)dateDescriptionInVietNam:(NSString *)strDate;
{
    NSDate *date = [[Utils dateFormatterCommon] dateFromString:strDate];
    if (date == nil) {
        return @"";
    }
    NSTimeInterval timeDiff = -[date timeIntervalSinceNow];
    NSInteger yearCurrent = [[[Utils getComponentFromDate:[NSDate date]] objectForKey:@"year"] integerValue];
    NSInteger yearNewsPost = [[[Utils getComponentFromDate:date] objectForKey:@"year"] integerValue];
    if (timeDiff < 60) {
        return LocalizedString(@"_TIME_DIFF_JUST_START_");
    } else if (timeDiff < 60 * 60) {
        return [NSString stringWithFormat:@"%d %@", (int) timeDiff/60, LocalizedString(@"_TIME_DIFF_MINUTE_")];
    } else if (timeDiff < 60 * 60 * 24) {
        return [NSString stringWithFormat:@"%d %@", (int) timeDiff/(60*60), LocalizedString(@"_TIME_DIFF_HOUR_")];
    } else if(yearNewsPost == yearCurrent){
        NSString *strTime = [Utils convertString:strDate from:[Utils dateFormatterCommon] to:[Utils dateFormatterDateForNewsOnlyVietnamSameYear]];
        strTime =[strTime stringByReplacingOccurrencesOfString:@"00:00" withString:@""];
        return strTime;
    }else{
        return [Utils convertString:strDate from:[Utils dateFormatterCommon] to:[Utils dateFormatterDateForNewsOnlyVietnam]];
    }
    return nil;
}
+ (UIViewController*) getTopMostViewController
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(window in windows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                break;
            }
        }
    }
    
    for (UIView *subView in [window subviews])
    {
        UIResponder *responder = [subView nextResponder];
        
        //added this block of code for iOS 8 which puts a UITransitionView in between the UIWindow and the UILayoutContainerView
        if ([responder isEqual:window])
        {
            //this is a UITransitionView
            if ([[subView subviews] count])
            {
                UIView *subSubView = [subView subviews][0]; //this should be the UILayoutContainerView
                responder = [subSubView nextResponder];
            }
        }
        
        if([responder isKindOfClass:[UIViewController class]]) {
            return [self topViewController: (UIViewController *) responder];
        }
    }
    
    return nil;
}
+ (UIViewController *) topViewController: (UIViewController *) controller
{
    BOOL isPresenting = NO;
    do {
        // this path is called only on iOS 6+, so -presentedViewController is fine here.
        UIViewController *presented = [controller presentedViewController];
        isPresenting = presented != nil;
        if(presented != nil) {
            controller = presented;
        }
        
    } while (isPresenting);
    
    return controller;
}

+(void)setCornerRadiusView:(UIView *)view withCornerRadius:(CGFloat)corner;
{
    CALayer *imageLayer = view.layer;
    [imageLayer setCornerRadius:corner];
    [imageLayer setBorderWidth:0];
    [imageLayer setMasksToBounds:YES];
}
+(NSString *) formatInterval: (NSTimeInterval) interval
{
    unsigned long milliseconds = interval;
    unsigned long seconds = milliseconds / 1000;
    milliseconds %= 1000;
    unsigned long minutes = seconds / 60;
    seconds %= 60;
    unsigned long hours = minutes / 60;
    minutes %= 60;
    
    NSMutableString * result = [NSMutableString new];
    
    if(hours)
        [result appendFormat: @"%d:", (int)hours];
    
    [result appendFormat: @"%2d:", (int)minutes];
    [result appendFormat: @"%2d:", (int)seconds];
    [result appendFormat: @"%2d", (int)milliseconds];
    
    return result;
}

+(void)fixSizeLable:(UILabel *)label withScare:(CGSize)sizeScare
{
    NSString *textContent = label.text;
    UIFont *font = label.font;
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize size = [textContent sizeWithAttributes:attribute];
    size.width += sizeScare.width;
    size.height += sizeScare.height;
    CGRect frameLabel = label.frame;
    frameLabel.size = size;
    label.frame = frameLabel;

}
+ (NSString *)platformString
{
    NSString *platform = [UIDevice currentDevice].model;
    return platform;
}
+(NSString *)versionApp
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}
+(NSDictionary *)removeObjectNullInDict:(NSDictionary *)dicts
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict addEntriesFromDictionary:dicts];
    for (NSString *key in dict.allKeys) {
        id object = dict[key];
        if ([object isKindOfClass:[NSNull class]]) {
            [dict removeObjectForKey:key];
        }
        if ([object isKindOfClass:[NSDictionary class]]) {
            object = [self removeObjectNullInDict:object];
        }
    }
    return dict;
}
+ (void)cloneObjectFrom:(id)source toTaget: (id)taget {
    NSArray *property = [self allPropertyNamesOfClass:taget];
    for (int i = 0; i < property.count; i++) {
        NSString *propertyName = property[i];
        NSString *strSetting = [NSString stringWithFormat:@"set%@:", [self capitalizedFirstLetter:propertyName]];
        id value1 = [source valueForKey:propertyName];
        SEL setter = NSSelectorFromString(strSetting);
        [taget performSelector:setter withObject:value1];
    }
}

+ (NSString *) capitalizedFirstLetter: (NSString *)str {
    NSString *retVal = str;
    if (str.length <= 1) {
        retVal = str.capitalizedString;
    } else {
        retVal = [NSString stringWithFormat:@"%@%@",[[str substringToIndex:1] uppercaseString],[str substringFromIndex:1]];
    }
    return retVal;
}
+ (NSArray *)allPropertyNamesOfClass:(id)object{
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([object class], &count);
    
    NSMutableArray *rv = [NSMutableArray array];
    
    unsigned i;
    for (i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        [rv addObject:name];
    }
    
    free(properties);
    
    return rv;
}

+ (UIStoryboard *)mainStoryboard
{
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

+ (UIStoryboard *)magazineStoryboard
{
    return [UIStoryboard storyboardWithName:@"Magazine" bundle:nil];
}

+ (UIStoryboard *)pagesStoryboard
{
    return [UIStoryboard storyboardWithName:@"MainPages" bundle:nil];
}
@end
