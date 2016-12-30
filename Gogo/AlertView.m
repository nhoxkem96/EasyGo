//
//  AlertView.m
//  Gogo
//
//  Created by Thuong on 10/9/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "AlertView.h"
#import "Object.h"
#import "Category.h"
#import "AFNetworking.h"
#import "Utils.h"
@import GooglePlaces;
@import GooglePlacePicker;
@import GoogleMaps;
@interface AlertView (){
    GMSPlacesClient *_placesClient;
    GMSPlacePicker *_placePicker;
    GMSMapView *googleMapView;
}
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@end
@implementation AlertView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self getData];
    _btnCategory.layer.borderWidth = 1;
    _btnCategory.layer.borderColor = [[UIColor clearColor] CGColor];
    _btnCategory.layer.cornerRadius = 5;
    
    self.btnPost.layer.borderWidth = 1;
    self.btnPost.layer.borderColor = [[UIColor clearColor] CGColor];
    self.btnPost.layer.cornerRadius = 5;
//    self.contentView.layer.cornerRadius = 3;
    self.arrayCategory = [[NSMutableArray alloc] init];
    self.arrayIdCategory = [[NSMutableArray alloc]init];
    self.txtLocation.delegate = self;
    // bind yourTextField to DownPicker
    [self.txtLocation addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_txtLocation setFont: [_txtLocation.font fontWithSize:[Utils fontSizeBig]]];
    [_btnCategory.titleLabel setFont: [_btnCategory.titleLabel.font fontWithSize:[Utils fontSizeBig]]];
    [_lblLocation setFont:[_txtLocation.font fontWithSize:[Utils fontSizeBig]]];
    _placesClient = [GMSPlacesClient sharedClient];
    UITapGestureRecognizer *tapGestureRecognizerUsername = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationTapped)];
    tapGestureRecognizerUsername.numberOfTapsRequired = 1;
    [_lblLocation addGestureRecognizer:tapGestureRecognizerUsername];
    _lblLocation.userInteractionEnabled = YES;
}
-(void)locationTapped{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    if ([locationManager locationServicesEnabled])
    {
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        [locationManager startUpdatingLocation];
    }
    
    
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(coordinate.latitude + 0.001,
                                                                  coordinate.longitude + 0.001);
    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(coordinate.latitude - 0.001,
                                                                  coordinate.longitude - 0.001);
    GMSCoordinateBounds *viewport = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast
                                                                         coordinate:southWest];
    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:viewport];
    _placePicker = [[GMSPlacePicker alloc] initWithConfig:config];
    [_placePicker pickPlaceWithCallback:^(GMSPlace *place, NSError *error) {
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        
        if (place != nil) {
            self.nameLabel.text = place.name;
            self.lblLocation.text =place.formattedAddress;
            self.lat = place.coordinate.latitude;
            self.lon = place.coordinate.longitude;
            NSLog(@"%f %f" , place.coordinate.latitude , place.coordinate.longitude);
        } else {
            self.nameLabel.text = @"No place selected";
            self.addressLabel.text = @"";
        }
    }];
    

}
-(void)getData{
    NSURL *URL = [NSURL URLWithString:@"http:easygo.com.vn/api/categories"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        Object *object = [[Object alloc]init];
        object.code = [[responseObject objectForKey:@"code"] integerValue];
        object.result =  [responseObject objectForKey:@"result"];
        NSLog(@"%@" , [responseObject objectForKey:@"code"]);
        NSLog(@"%@" , [responseObject objectForKey:@"result"]);
        if(object.code == 1){
            NSArray *array = [[NSArray alloc]init];
            array = [MTLJSONAdapter modelsOfClass:[Category class] fromJSONArray:object.result error:nil];
            for(Category *category in array){
                [self.arrayCategory addObject:category.name];
                NSLog(@"%@" , category.category_Id);
                [self.arrayIdCategory addObject:category.category_Id];
            }
            NSLog(@"%@" , self.arrayCategory);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
-(void)textFieldDidChange :(UITextField *)theTextField{
    [[NSUserDefaults standardUserDefaults] setObject:theTextField.text forKey:@"location"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField resignFirstResponder];
//    if ([self.delegate respondsToSelector:@selector(beginEditLocation)]) {
//        [self.delegate beginEditLocation];
//    }
}
- (IBAction)clickBtnCategory:(id)sender {

    if(dropDown == nil) {
        CGFloat f = self.arrayCategory.count * 40;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :self.arrayCategory :nil :@"down"];
        dropDown.delegate = self;
        
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
    [self.txtLocation resignFirstResponder];
}
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    [self rel];
    NSLog(@"%@", _btnCategory.titleLabel.text);

}

-(void)rel{
    //    [dropDown release];
    dropDown = nil;
}
-(void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}
- (IBAction)clickBtnPost:(id)sender {
    for(int i = 0 ; i < self.arrayCategory.count;i++){
        if(self.arrayCategory[i] == _btnCategory.titleLabel.text){
            self.idCategory = self.arrayIdCategory[i];
        }
    }
    NSLog(@"%@" , self.idCategory);
    if ([self.delegate respondsToSelector:@selector(clickBtnPost:location:lat:lon:)]) {
        [self.delegate clickBtnPost:self.idCategory location:self.lblLocation.text lat:self.lat lon:self.lon];
    }
}
@end
