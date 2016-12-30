//
//  FlightViewController.m
//  Gogo
//
//  Created by Thuong on 12/30/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "FlightViewController.h"
#import "Utils.h"
#import "AFNetworking.h"
#import "SingleObject.h"
#import "FlightModel.h"
#import "SearchFlightTableViewController.h"
@interface FlightViewController ()<kDropDownListViewDelegate>{
    int check;
    int indexPointsGo;
    int indexLanding;
}

@end

@implementation FlightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrayPosition = @[@"Hồ Chí Minh (SGN)" , @"Hà Nội (HAN)", @"Vinh (VII)", @"Buôn Ma Thuột (BMV)", @"Đà Nẵng (DAD)", @"Hải Phòng (HPH)", @"Nha Trang (CXR)", @"Phú Quốc (PQC)", @"Đà Lạt (DLI)", @"Huế (HUI)" , @"Cà Mau (CAH)", @"Cần Thơ (VCA)", @"Côn Đảo (VCS)", @"Điện Biên (DIN)", @"Đồng Hới (VDH)", @"Pleiku (PXU)", @"Quy Nhơn (UIH)", @"Rạch Giá (VKG)", @"Tam Ky (VCL)", @"Tuy Hoa (TBB)", @"Quảng Ngãi (XNG)", @"Thanh Hóa (THD)"];
    arrayPositionCode = @[@"SGN" , @"HAN", @"VII", @"BMV", @"DAD", @"HPH", @"CXR", @"PQC", @"DLI", @"HUI", @"CAH", @"VCA", @"VCS", @"DIN", @"VDH", @"PXU", @"UIH", @"VKG", @"VCL", @"TBB", @"XNG", @"THD"];
    _toolBar.hidden = true;
    _datePicker.hidden = true;
    CALayer *line = [CALayer layer];
    line.frame = CGRectMake(15, self.viewSelectPointsGo.frame.size.height - 0.3, self.viewSelectPointsGo.frame.size.width - 30,0.3);
    line.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.viewSelectPointsGo.layer addSublayer:line];
    _btnSearch.layer.borderWidth = 0.3f;
    _btnSearch.layer.borderColor = [[UIColor whiteColor] CGColor];
    _btnSearch.layer.cornerRadius = self.btnSearch.frame.size.height / 2;
    indexLanding = -1;
    indexPointsGo = -1;
}
-(void)viewDidLayoutSubviews{
    CALayer *line = [CALayer layer];
    line.frame = CGRectMake(15, self.viewSelectPointsGo.frame.size.height - 0.3, self.viewSelectPointsGo.frame.size.width - 30,0.3);
    line.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.viewSelectPointsGo.layer addSublayer:line];
    
    _btnSearch.layer.borderWidth = 0.3f;
    _btnSearch.layer.borderColor = [[UIColor whiteColor] CGColor];
    _btnSearch.layer.cornerRadius = self.btnSearch.frame.size.height / 2;
}
-(void)setFont{
    [_btnDatePicker.titleLabel setFont:[UIFont systemFontOfSize:[Utils fontSizeBig]]];
    [_btnSelectLanding.titleLabel setFont:[UIFont systemFontOfSize:[Utils fontSizeBig]]];
    [_btnSelectPointsGo.titleLabel setFont:[UIFont systemFontOfSize:[Utils fontSizeBig]]];
}
-(void)showPopUpWithTitle:(NSString*)popupTitle withOption:(NSArray*)arrOptions xy:(CGPoint)point size:(CGSize)size isMultiple:(BOOL)isMultiple{
    
    if(check == 0){
        dropdownLanding = [[DropDownListView alloc] initWithTitle:popupTitle options:arrOptions xy:point size:size isMultiple:isMultiple];
        dropdownLanding.delegate = self;
        [dropdownLanding showInView:self.view animated:YES];
        
        /*----------------Set DropDown backGroundColor-----------------*/
        [dropdownLanding SetBackGroundDropDown_R:1 G:1 B:1 alpha:1];
        
    }
    else{
        dropdownSelectPointsGo = [[DropDownListView alloc] initWithTitle:popupTitle options:arrOptions xy:point size:size isMultiple:isMultiple];
        dropdownSelectPointsGo.delegate = self;
        [dropdownSelectPointsGo showInView:self.view animated:YES];
        
        /*----------------Set DropDown backGroundColor-----------------*/
        [dropdownSelectPointsGo SetBackGroundDropDown_R:1 G:1 B:1 alpha:1];

    }
    
}
- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex{
    /*----------------Get Selected Value[Single selection]-----------------*/
    if(check == 0){
        [_btnSelectLanding setTitle:[arrayPosition objectAtIndex:anIndex] forState:UIControlStateNormal];
        indexLanding = (int)anIndex;
    }
    else{
        [_btnSelectPointsGo setTitle:[arrayPosition objectAtIndex:anIndex] forState:UIControlStateNormal];
        indexPointsGo = (int)anIndex;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickBtnPointGo:(id)sender {
    check  = 1;
    [dropdownSelectPointsGo fadeOut];
    float x = self.btnSelectPointsGo.frame.origin.x;
    float y = self.btnSelectPointsGo.frame.origin.y;
    CGSize size = CGSizeMake(self.btnSelectPointsGo.frame.size.width, [UIScreen mainScreen].bounds.size.height * 300/568);
    [self showPopUpWithTitle:@"Chọn địa điểm" withOption:arrayPosition xy:CGPointMake(x,y) size:size isMultiple:NO];
}
- (IBAction)clickBtnLanding:(id)sender {
    check = 0;
    [dropdownLanding fadeOut];
    float x = self.btnSelectLanding.frame.origin.x;
    float y = self.btnSelectLanding.frame.origin.y;
    CGSize size = CGSizeMake(self.btnSelectLanding.frame.size.width, [UIScreen mainScreen].bounds.size.height * 300/568);
    [self showPopUpWithTitle:@"Chọn địa điểm" withOption:arrayPosition xy:CGPointMake(x,y) size:size isMultiple:NO];
}
- (IBAction)clickBtnXong:(id)sender {
    _datePicker.hidden = true;
    _toolBar.hidden = true;
}
- (IBAction)clickBtnSearch:(id)sender {
    
    if(indexLanding == indexPointsGo && indexLanding != -1){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Địa điểm trùng nhau."
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"Đồng ý"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if(indexPointsGo == -1 || indexLanding == -1){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Vui lòng chọn địa điểm."
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"Đồng ý"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if([self.btnDatePicker.titleLabel.text caseInsensitiveCompare:@"Thời gian khởi hành"] == NSOrderedSame){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Vui lòng chọn thời gian."
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"Đồng ý"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else{
        NSString *date = [self.btnDatePicker.titleLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSDictionary *params = @{
                                 @"Adult":@"1",
                                 @"Child":@"0",
                                 @"DepartDate":date,
                                 @"FromPlace":[arrayPositionCode objectAtIndex:indexPointsGo],
                                 @"Infant":@"0",
                                 @"ReturnDate":date,
                                 @"ToPlace":[arrayPositionCode objectAtIndex:indexLanding]
                                 
                                 };
        NSLog(@"%@" , params);
        NSURL * url = [[NSURL alloc]initWithString:@"http:easygo.com.vn:9696/api/flight"];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Authorization"];
        [manager POST:url.absoluteString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            SingleObject *object = [MTLJSONAdapter modelOfClass:[SingleObject class]
                                             fromJSONDictionary:responseObject
                                                          error:nil];
            NSLog(@"%@" , object.result);
            NSLog(@"sads %@" , responseObject);
            if(object.code == 1){
                NSMutableArray *results = [[NSMutableArray alloc]init];
                NSArray *array = object.result;
                for(int i = 0 ; i < array.count;i++){
                    FlightModel *flight = [[FlightModel alloc]init];
                    flight.airlines = [[object.result objectAtIndex:i] objectForKey:@"AirlineCode"];
                    flight.fromPlace = [[object.result objectAtIndex:i] objectForKey:@"FromPlace"];
                    flight.toPlace = [[object.result objectAtIndex:i] objectForKey:@"ToPlace"];
                    flight.totalPrice = [[object.result objectAtIndex:i] objectForKey:@"TotalPrice"];
                    flight.departTime = [[object.result objectAtIndex:i] objectForKey:@"DepartTime"];
                    flight.landingTime = [[object.result objectAtIndex:i] objectForKey:@"LandingTime"];
                    [results addObject:flight];
                }
                
                if(results.count == 0){
                    NSLog(@"k co");
                }
                else{
                    SearchFlightTableViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"SearchFlightTableViewController"];
                    vc.result = results;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            }
            else NSLog(@"%@" , object.message);
        }
              failure:^(NSURLSessionTask *operation, NSError *error) {
                  NSLog(@"Error: %@", error);
              }];

    }
    
}

- (IBAction)clickBtnDatePicker:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yy-MM-yyyy"];
    [_btnDatePicker setTitle:[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate: _datePicker.date]] forState:UIControlStateNormal];
    _datePicker.hidden = false;
    _toolBar.hidden = false;
}

- (IBAction)changeDatePicker:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy "];
    [_btnDatePicker setTitle:[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate: _datePicker.date]] forState:UIControlStateNormal];
}
@end
